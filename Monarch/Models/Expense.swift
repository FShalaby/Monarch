//
//  Expense.swift
//  Monarch
//
//  Created by Fouad on 2025-06-13.
//
import Foundation
import SwiftUI

enum Category:String, CaseIterable,Codable
{
    case food
    case rent
    case transportation
    case utility
    case recreational
    case other
}
struct CategoryTotal: Identifiable {
    let category: Category
    let total: Double

    var id: Category { category }
}


extension Category
{
    var icon: String
    {
        switch self
        {
            case .food: return "cart.fill"
            case .rent: return "house.fill"
            case .transportation: return "car.fill"
            case .utility: return "bolt.fill"
            case .recreational: return "gamecontroller.fill"
            case .other: return "questionmark.circle"
        }
    }
    var color: Color
    {
        switch self
        {
            case .food: return .green
            case .rent: return .blue
            case .transportation: return .orange
            case .utility: return .purple
            case .recreational: return .pink
            case .other: return .gray
        }
    }
}

struct Expense: Identifiable, Codable
{
    let id:UUID
    var userid: String
    var category:Category
    var name:String
    var price:Double
    var date:Date
}
extension Expense: Equatable {
    static func ==(lhs: Expense, rhs: Expense) -> Bool {
        lhs.id == rhs.id
    }
}

