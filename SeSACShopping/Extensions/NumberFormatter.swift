//
//  NumberFormatter.swift
//  SeSACShopping
//
//  Created by Seryun Chun on 2024/01/21.
//

import UIKit

extension NumberFormatter {
    static func convertNumber(_ raw: String) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let rawNumber = numberFormatter.number(from: raw) ?? 0
        return numberFormatter.string(from: rawNumber) ?? "ERROR"
    }
}
