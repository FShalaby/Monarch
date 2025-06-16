import SwiftUI

struct AddExpenseView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    @State private var showAlert = false
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var category: Category = .utility
    @State private var price: Double = 0.0
    @State private var date: Date = Date()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Expense Details")) {
                    TextField("Name", text: $name)

                    Picker("Category", selection: $category) {
                        ForEach(Category.allCases, id: \.self) { categoryCase in
                            Text(categoryCase.rawValue.capitalized).tag(categoryCase)
                        }
                    }
                }

                Section(header: Text("Cost & Date")) {
                    TextField("Price", value: $price, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)

                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
                .tint(.black)

                // Button inside Form but styled
                Section {
                    Button("Add") {
                        if name.trimmingCharacters(in: .whitespaces).isEmpty || price <= 0 {
                                showAlert = true
                            } else {
                                viewModel.addExpense(name: name, category: category, price: price, date: date, userId: viewModel.userId)
                                dismiss()
                            }
                    }
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(14)
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                }
                .listRowBackground(Color.clear) // removes gray background behind button
            }
            .navigationTitle("Add Expense")
            .alert("Invalid Input", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please enter a valid name and a price greater than $0.")
            }
        }
    }
}

#Preview {
    AddExpenseView(viewModel: ExpenseViewModel(userId: "previewUser"))
}
