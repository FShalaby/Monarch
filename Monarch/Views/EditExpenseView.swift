//
//  EditExpenseView.swift
//  Monarch
//
//  Created by Fouad on 2025-06-15.
//

import SwiftUI

struct EditExpenseView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ExpenseViewModel
    var expense: Expense
    
    @State private var name: String
    @State private var category: Category
    @State private var price: Double
    @State private var date: Date

    init(viewModel: ExpenseViewModel, expense: Expense) {
        self.viewModel = viewModel
        self.expense = expense
        _name = State(initialValue: expense.name)
        _category = State(initialValue: expense.category)
        _price = State(initialValue: expense.price)
        _date = State(initialValue: expense.date)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Edit Expense")) {
                    TextField("Name", text: $name)
                    Picker("Category", selection: $category) {
                        ForEach(Category.allCases, id: \.self) {
                            Text($0.rawValue.capitalized).tag($0)
                        }
                    }
                    TextField("Price", value: $price, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }

                Section {
                    Button("Save Changes") {
                        viewModel.updateExpense(id: expense.id, name: name, category: category, price: price, date: date)
                        dismiss()
                    }
                }
            }
            .navigationTitle("Edit Expense")
        }
    }
}

#Preview {
    EditExpenseView(
        viewModel: ExpenseViewModel(),
        expense: Expense(
            id: UUID(),
            category: .food,
            name: "Sample Expense",
            price: 12.99,
            date: Date()
        )
    )
}

