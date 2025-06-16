import SwiftUI
import Charts

struct ContentView: View {
    @StateObject var viewModel = ExpenseViewModel()
    @State private var selectedCategory: Category? = nil
    @State private var showAddExpense = false
    @State private var editingExpense: Expense? = nil
    @State private var showEditExpense = false

    // Split filtering into its own variable to avoid long expressions
    var filteredExpenses: [Expense] {
        viewModel.expense.filter { selectedCategory == nil || $0.category == selectedCategory }
    }

    var total: Double {
        filteredExpenses.reduce(0) { $0 + $1.price }
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("Total: $\(total, specifier: "%.2f")")
                    .font(.headline)
                    .bold()
                    .padding(.bottom, 8)
                ExpenseChartView(viewModel: viewModel)
                    .frame(height: 250)
                    .padding(.horizontal)
                List {
                    ForEach(filteredExpenses) { item in
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
                        .onTapGesture {
                            editingExpense = item
                            showEditExpense = true
                        }
                    }
                    .onDelete(perform: viewModel.delete)
                }

            }
            .navigationTitle("Expenses")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button("All") {
                            selectedCategory = nil
                        }
                        ForEach(Category.allCases, id: \.self) { category in
                            Button(category.rawValue.capitalized) {
                                selectedCategory = category
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle.fill")
                            .imageScale(.large)
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddExpense = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .tint(.black)
            .sheet(isPresented: $showAddExpense) {
                AddExpenseView(viewModel: viewModel)
            }
            .sheet(item: $editingExpense) { expense in
                EditExpenseView(viewModel: viewModel, expense: expense)
            }
        }
    }
}

#Preview {
    ContentView()
}
