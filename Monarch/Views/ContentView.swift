import SwiftUI
import Charts

struct ContentView: View {
    @ObservedObject var authViewModel: UserAuthViewModel
    @StateObject var viewModel: ExpenseViewModel

    @State private var selectedCategory: Category? = nil
    @State private var showAddExpense = false
    @State private var editingExpense: Expense? = nil
    @State private var showEditExpense = false

    var filteredExpenses: [Expense] {
        let all = viewModel.expense
        if let selected = selectedCategory {
            return all.filter { $0.category == selected }
        } else {
            return all
        }
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
                        ExpenseRow(item: item)
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

                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Logout") {
                        authViewModel.logout()
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
    ContentView(
        authViewModel: UserAuthViewModel(),
        viewModel: ExpenseViewModel(userId: "previewUser")
    )
}
