//
//  PlaidHandler.swift
//  Budget_Caddie
//
//  Created by Sabin on 23/01/25.
//

import Foundation
import LinkKit

class PlaidHandler: NSObject {
    
    static let shared = PlaidHandler()
    var handler: Handler?
    var delegate: CustomPlaidDelegate?
   
    func startPlaidHandle(vc: UIViewController, currentLinkToken: String) {
        let linkToken = currentLinkToken
        let config = createLinkConfiguration(linkToken: linkToken)
        let creationResult = Plaid.create(config)
        
        switch creationResult {
        case .success(let handler):
            self.handler = handler

            handler.open(presentUsing: .viewController(vc))
        case .failure(let error):
            print("Handler creation error\(error)")
        }
    }
    
    private func createLinkConfiguration(linkToken: String) -> LinkTokenConfiguration {
        var linkTokenConfig = LinkTokenConfiguration(token: linkToken) { success  in
            print("Link was finished successfully! \(success)")
            print(success.publicToken)
            self.delegate?.didUpdateData(success)
        }
        linkTokenConfig.onExit = { linkEvent in
            print("User exited link early. \(linkEvent)")
        }
        linkTokenConfig.onEvent = { linkExit in
            print("Hit an event \(linkExit.eventName)")
            // Start Launch so hide the Application loader
        }
        return linkTokenConfig
    }
}
