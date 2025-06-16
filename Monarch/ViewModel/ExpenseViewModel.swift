//
//  ExpenseViewModel.swift
//  Monarch
//
//  Created by Fouad on 2025-06-13.
//

import Foundation
class ExpenseViewModel:ObservableObject
{
    let userId: String
    @Published var expense: [Expense]=[]
    @Published var categoryTotals: [CategoryTotal] = []
    init(userId: String)
    {
        self.userId = userId
        loadExpense(for: userId)
        categoryTotal()
    }
    
    func addExpense(name: String, category: Category, price: Double, date: Date, userId: String)
    {
        let newExpense = Expense(id: UUID(), userid: userId, category: category, name: name, price: price, date: date)
        expense.append(newExpense)
        saveExpenses()
    }
    
    func updateExpense(id: UUID, name: String, category: Category, price: Double, date: Date) {
        if let index = expense.firstIndex(where: { $0.id == id }) {
            expense[index].name = name
            expense[index].category = category
            expense[index].price = price
            expense[index].date = date
            saveExpenses()
        }
    }

    func delete(at offsets: IndexSet) {
        expense.remove(atOffsets: offsets)
        saveExpenses()
    }
    
    func saveExpenses() {
        do {
            let data = try JSONEncoder().encode(expense)
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent("expenses.json")
            try data.write(to: url)
            print("✅ Expenses saved to \(url)")
        } catch {
            print("❌ Failed to save expenses:", error)
        }
    }
    
    func loadExpense(for userId: String) {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("expenses.json")
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([Expense].self, from: data)
            self.expense = decoded.filter { $0.userid == userId }
            print("✅ Expenses loaded for user: \(userId) (\(expense.count) items)")
        } catch {
            print("❌ Error loading expenses:", error)
        }
    }

    
    func categoryTotal() {
        let groupedCategories = Dictionary(grouping: expense, by: { $0.category })
        var results: [CategoryTotal] = []

        for (category, expenses) in groupedCategories {
            let total = expenses.reduce(0) { $0 + $1.price }
            results.append(CategoryTotal(category: category, total: total))
        }

        categoryTotals = results
    }
}
