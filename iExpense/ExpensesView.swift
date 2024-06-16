//
//  ExpensesView.swift
//  iExpense
//
//  Created by Víctor Ávila on 15/06/24.
//

import SwiftData
import SwiftUI

struct ExpensesView: View {
    @Query var expenses: [ExpenseItem]
    @Environment(\.modelContext) var modelContext
    
    @State private var expenseType: String
    
    var body: some View {
        ForEach(expenses) { item in
            if item.type == expenseType {
                // Title and subtitle on one side and then more information on the another side
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        
                        Text(item.type)
                    }
                    
                    Spacer()
                    
                    Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "$"))
                        .foregroundStyle(item.amount > 100 ? .red : (item.amount > 10 ? .yellow : .green))
                }
            }
        }
        // Adding the functionality to delete (for debug purposes) items via .onDelete()
        .onDelete(perform: removeItems)
    }
    
    init(expenseType: String, typesShown: [String], sortOrder: [SortDescriptor<ExpenseItem>]) {
        self.expenseType = expenseType
        _expenses = Query(filter: #Predicate<ExpenseItem> { item in
            typesShown.contains(item.type)
        }, sort: sortOrder)
    }
    
    func removeItems(at offsets: IndexSet) {
        for i in offsets {
            modelContext.delete(expenses[i])
        }
    }
}

#Preview {
    ExpensesView(expenseType: "Business", typesShown: ["Business", "Personal"], sortOrder: [SortDescriptor(\ExpenseItem.name)])
        .modelContainer(for: ExpenseItem.self)
}
