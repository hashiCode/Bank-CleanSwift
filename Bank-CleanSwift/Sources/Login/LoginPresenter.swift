//
//  LoginPresenter.swift
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

protocol LoginPresentationLogic{
    
    func presentError(errorResponse: Login.ErrorResponse)
    
    func presentStatements(userResponse: Login.UserResponse)
    
    func presentLastUserName(userNameResponse: Login.UserNameResponse)
}

class LoginPresenter: LoginPresentationLogic {
    
    weak var viewController: LoginDisplayLogic?
  
    func presentError(errorResponse: Login.ErrorResponse) {
        let errorViewModel = Login.ErrorViewModel(error: errorResponse.error)
        viewController?.presentError(errorViewModel: errorViewModel)
    }
    
    func presentStatements(userResponse: Login.UserResponse) {
        let userViewModel = Login.UserViewModel(userAccount: userResponse.userAccount)
        viewController?.presentStatements(userViewModel: userViewModel)
    }
    
    func presentLastUserName(userNameResponse: Login.UserNameResponse) {
        let userNameViewModel = Login.UserNameViewModel(userName: userNameResponse.userName)
        viewController?.fillUserNameTextFieldLastLoggedUser(userNameViewModel: userNameViewModel)
    }
}
