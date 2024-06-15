//
//  AddView.swift
//  iExpense
//
//  Created by Víctor Ávila on 27/01/24.
//

import SwiftUI
import SwiftUIKit

struct AddView: View {
    // Read the dismiss value from the Environment (it will figure out how things are setted up to discover how to dismiss)
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var name = "Expense Name"
    @State private var type = "Business"
    @State private var amount: Double? = 0.0
    
    // We don't want to create a second Expenses here, but use the original Expenses from ContentView
//    var expenses: Expenses
    
    let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationStack {
            Form {
//                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                
//                TextField("Amount", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "$"))
                CurrencyTextField("Amount", value: $amount)
                    .keyboardType(.decimalPad)
            }
            .navigationTitle($name)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let item = ExpenseItem(name: name, type: type, amount: amount ?? 0.0)
//                        expenses.items.append(item)
                        modelContext.insert(item)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddView()
        .modelContainer(for: ExpenseItem.self)
}
