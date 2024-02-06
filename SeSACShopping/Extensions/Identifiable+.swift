//
//  Identifiable.swift
//  SeSACShopping
//
//  Created by Seryun Chun on 2024/01/18.
//

import Foundation

protocol Identifiable {
    static var identifier: String { get }
}

extension Identifiable {
    static var identifier: String {
        return String(describing: self)
    }
}

extension NSObject: Identifiable { } 
