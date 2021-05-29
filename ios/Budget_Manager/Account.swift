//
//  Account.swift
//  Budget_Manager
//
//  Created by 이다영 on 2021/05/28.
//

import Foundation

struct Account: Codable, Hashable, Identifiable {
    let id: Int
    var name: String
    var category: String
    var description: String
    var wealth_type: String
    var balance: Int
    var created_at: String
}
