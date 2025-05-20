//
//  TransactionsListModel.swift
//  Budget_Caddie
//
//  Created by Sabin on 14/04/25.
//

import Foundation

struct GetTransactionsList: Codable {
    let status: String?
    let transactionData: [TransactionsListDetails]?
    
    enum CodingKeys: String, CodingKey {
        case status
        case transactionData = "data"
    }
}

// MARK: - Datum
struct TransactionsListDetails: Codable {
    let accountID: String?
    let amount: Int?
    let merchantName: String?
    let merchantLogoURL: String?
    let transactionDate: String?
    let category: String?
    let description: String?
    let manualTransaction: Bool?
}

struct GetTransactionsStatus: Codable {
    let status: String?
    let transactionStatus: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case transactionStatus = "data"
    }
}
