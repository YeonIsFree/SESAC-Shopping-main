//
//  Result.swift
//  SeSACShopping
//
//  Created by Seryun Chun on 2024/01/21.
//

import Foundation

struct Result: Codable {
    let total: Int
    let items: [Item]
}

struct Item: Codable {
    let title: String
    let link: String
    let image: String
    let lprice: String
    let mallName: String
    let productId: String
}
