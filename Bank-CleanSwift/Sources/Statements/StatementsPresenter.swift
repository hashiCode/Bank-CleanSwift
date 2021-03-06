//
//  StatementsPresenter.swift
//  Bank-CleanSwift
//
//  Created by Scott Takahashi on 02/08/20.
//  Copyright (c) 2020 Scott Takahashi. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol StatementsPresentationLogic{
    
    func presentError(errorResponse: Statements.Error.Reponse)
    
    func presetStatements(response: Statements.ShowStatements.Response)
}

class StatementsPresenter: StatementsPresentationLogic {
    
    weak var viewController: StatementsDisplayLogic?
  
    func presentError(errorResponse: Statements.Error.Reponse) {
        let viewModel = Statements.Error.ViewModel(error: errorResponse.error)
        viewController?.displayError(viewModel: viewModel)
    }
    
    func presetStatements(response: Statements.ShowStatements.Response) {
        let viewModel = Statements.ShowStatements.ViewModel(statements: response.statements)
        viewController?.displayStatements(viewModel: viewModel)
    }
}
