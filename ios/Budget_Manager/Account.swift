//
//  Account.swift
//  Budget_Manager
//
//  Created by 이다영 on 2021/05/28.
//

import Foundation

struct Account: Codable, Hashable, Identifiable {
    let id: Int
    let name: String
    let category: String
    let description: String
    let wealth_type: String
    let balance: Int
    let created_at: String
}
