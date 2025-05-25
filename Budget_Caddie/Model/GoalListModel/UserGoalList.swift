//
//  GoalListModel.swift
//  Budget_Caddie
//
//  Created by Sabin on 15/04/25.
//

import Foundation

struct GetUserGoalList: Codable {
    let goal: [Goal]?
}

// MARK: - Goal
struct Goal: Codable {
    let goalId: Int?
    let goalName: String?
    let currentAmount, desiredAmount: Int?
    let completedDate: String?

    enum CodingKeys: String, CodingKey {
        case goalId
        case goalName, currentAmount, desiredAmount, completedDate
    }
}
