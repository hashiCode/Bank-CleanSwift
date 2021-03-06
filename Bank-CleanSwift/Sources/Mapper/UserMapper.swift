//
//  UserMapper.swift
//  Bank-CleanSwift
//
//  Created by Scott Takahashi on 01/08/20.
//  Copyright © 2020 Scott Takahashi. All rights reserved.
//

import Foundation

class UserMapper {
    
    private struct Root: Codable {
        let userAccount: UserAccount
        let error: ErrorModel
    }
    
    private static let invalidData = "login.error.invalidData"
    
    static func map(_ data: Data) throws -> UserAccount {
        guard let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw BankError.apiError(message: invalidData)
        }

        if let _ = root.userAccount.userId {
            return root.userAccount
        } else if let error = root.error.message {
            throw BankError.apiError(message: error)
        }
        throw BankError.apiError(message: invalidData)
    }

}
