//
//  ChatMessage.swift
//  Talky
//
//  Created by Muhammad Rezky on 10/08/23.
//

import Foundation

struct ChatMessage: Codable, Identifiable {
    var id: String?
    let fromId, toId, text: String
    let timestamp: Date
}
