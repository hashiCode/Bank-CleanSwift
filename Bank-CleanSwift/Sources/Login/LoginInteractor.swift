//
//  LoginInteractor.swift
//  Bank-CleanSwift
//
//  Created by Scott Takahashi on 31/07/20.
//  Copyright (c) 2020 Scott Takahashi. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol LoginBusinessLogic {
    func login(request: Login.Request)
    
    func retrieveLastLoggedUserName()
}

protocol LoginDataStore
{
    var user: UserAccount? { get set }
}

private struct ErrorMessage {
    static let invalidUserName = "login.error.invalidUser"
    static let invalidPassword = "login.error.invalidPassword"
}

class LoginInteractor: LoginBusinessLogic, LoginDataStore {
    
    var presenter: LoginPresentationLogic?
    var worker: LoginService?
    var user: UserAccount?
    
    init() {
        let bankApiProvider = BankHttpProvider(urlSession: URLSession.shared)
        self.worker = LoginWorker(apiProvider: bankApiProvider, userProvider: UserProviderImpl())
    }
  
    func login(request: Login.Request) {
        let userName = request.userName.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = request.password.trimmingCharacters(in: .whitespacesAndNewlines)
        if let error = self.userNameOrPasswordHasError(userName: userName, password: password) {
            let errorResponse = Login.ErrorResponse(error: error)
            presenter?.presentError(errorResponse: errorResponse)
        }
        else {
            worker?.login(userName: userName, password: password, callback: { [weak self] (result) in
                guard let self = self else {return}
                switch result {
                case .success(let userAccount):
                    self.worker?.saveUserName(username: userName)
                    self.user = userAccount
                    let userResponse = Login.UserResponse(userAccount: userAccount)
                    DispatchQueue.main.async {
                        self.presenter?.presentStatements(userResponse: userResponse)
                    }
                case .failure(let error):
                    let errorResponse = Login.ErrorResponse(error: error)
                    DispatchQueue.main.async {
                        self.presenter?.presentError(errorResponse: errorResponse)
                    }
                }
            })
        }
    }
    
    func retrieveLastLoggedUserName() {
        if let userName = worker?.getLastLoggedUser() {
            let userNameReponse = Login.UserNameResponse(userName: userName)
            presenter?.presentLastUserName(userNameResponse: userNameReponse)
        }
    }
    
    
}

extension LoginInteractor {
    
    private func userNameOrPasswordHasError(userName: String, password: String) -> BankError? {
        if !self.isCPF(userName) && !self.isEmail(userName) {
            return BankError.invalidUserInput(message: ErrorMessage.invalidUserName.localized())
        }
        if !self.isValidPassword(password) {
            return BankError.invalidUserInput(message: ErrorMessage.invalidPassword.localized())
        }
        return nil
    }
    
    //https://gist.github.com/LeonardoCardoso/3517ff69e4a45012fa6c8d9cbb506730
    private func isCPF(_ userName: String) -> Bool {
        let cpf = self.onlyNumbers(userName)
        guard cpf.count == 11 else { return false }

        let i1 = cpf.index(cpf.startIndex, offsetBy: 9)
        let i2 = cpf.index(cpf.startIndex, offsetBy: 10)
        let i3 = cpf.index(cpf.startIndex, offsetBy: 11)
        let d1 = Int(cpf[i1..<i2])
        let d2 = Int(cpf[i2..<i3])

        var temp1 = 0, temp2 = 0

        for i in 0...8 {
            let start = cpf.index(cpf.startIndex, offsetBy: i)
            let end = cpf.index(cpf.startIndex, offsetBy: i+1)
            let char = Int(cpf[start..<end])

            temp1 += char! * (10 - i)
            temp2 += char! * (11 - i)
        }

        temp1 %= 11
        temp1 = temp1 < 2 ? 0 : 11-temp1

        temp2 += temp1 * 2
        temp2 %= 11
        temp2 = temp2 < 2 ? 0 : 11-temp2

        return temp1 == d1 && temp2 == d2
    }
    
    private func onlyNumbers(_ userName: String) -> String {
        guard !userName.isEmpty else { return "" }
        return userName.replacingOccurrences(of: "\\D",
                                    with: "",
                                    options: .regularExpression,
                                    range: userName.startIndex..<userName.endIndex)
    }

    
    private func isEmail(_ userName: String) -> Bool {
        return self.validateRegex(regex: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}", word: userName)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        return self.validateRegex(regex: "^(?=\\P{Ll}*\\p{Ll})(?=\\P{Lu}*\\p{Lu})(?=\\P{N}*\\p{N})(?=[\\p{L}\\p{N}]*[^\\p{L}\\p{N}])[\\s\\S]{3,}$", word: password)
    }
    
    private func validateRegex(regex: String, word: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: word)
    }
}
