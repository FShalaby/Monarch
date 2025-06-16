//
//  ExpenseChartView.swift
//  Monarch
//
//  Created by Fouad on 2025-06-15.
//

import SwiftUI
import Charts

struct ExpenseChartView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    @State private var animateChart: Bool = false

    var body: some View {
        let totalSpent = viewModel.categoryTotals.reduce(0) { $0 + $1.total }

        ZStack {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )

            Chart(viewModel.categoryTotals) { item in
                SectorMark(
                    angle: .value("Total", animateChart ? item.total : 0),
                    innerRadius: .ratio(0.5)
                )
                .foregroundStyle(item.category.color)
                .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
                .annotation(position: .overlay) {
                    let percentage = item.total / totalSpent
                    VStack(spacing: 2) {
                        Text(item.category.rawValue.capitalized)
                            .font(.caption2)
                            .foregroundColor(.white)
                        Text("\(Int(percentage * 100))%")
                            .font(.caption2)
                            .bold()
                            .foregroundColor(.white)
                    }
                    .shadow(radius: 2)
                }
            }
            .chartLegend(.hidden)
            .padding(30)
        }
        .padding()
        .frame(height: 300)
        .onAppear {
            withAnimation(.easeOut(duration: 1.2)) {
                animateChart = true
            }
        }
    }
}

#Preview {
    ExpenseChartView(viewModel: ExpenseViewModel())
}
