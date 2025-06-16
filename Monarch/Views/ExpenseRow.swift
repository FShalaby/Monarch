//
//  ExpenseRow.swift
//  Monarch
//
//  Created by Fouad on 2025-06-16.
//
import SwiftUI
struct ExpenseRow: View {
    let item: Expense

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: item.category.icon)
                .foregroundColor(item.category.color)
                .font(.title2)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                Text(item.category.rawValue.capitalized)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("$\(item.price, specifier: "%.2f")")
                    .font(.subheadline)
                Text(item.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 6)
    }
}
