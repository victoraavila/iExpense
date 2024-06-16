//
//  ContentView.swift
//  iExpense
//
//  Created by Víctor Ávila on 27/01/24.
//

import SwiftData
import SwiftUI

// We will make a list of expenses by creating a separate Expenses class that will be attached using @State.
// 1. What do we wanna store about an expense? The name of the item, whether it is for business or personal, and its cost.

struct ContentView: View {
    // Since we want to further delete items using .onDelete(), we have to create the list using ForEach().
    // The @State here is just to make expenses alive
    @Query var expenses: [ExpenseItem]
    @Environment(\.modelContext) var modelContext
    
    // 3 things to be done in order to show the AddView
    // 1. Add a @State property to track if we are showing the AddView or not
    // 2. Tell SwiftUI to use this boolean as a condition for showing a sheet
    // 3. Put an instance of the View inside the sheet
    @State private var showingAddExpense = false
    @State private var sortOrder = [SortDescriptor(\ExpenseItem.name)]
    
    var body: some View {
        NavigationStack() {
            List {
                Section() {
                    ExpensesView(expenseType: "Business", sortOrder: sortOrder)
                } header: {
                    Text("Business expenses")
                }
                

                Section() {
                    ExpensesView(expenseType: "Personal", sortOrder: sortOrder)
                } header: {
                    Text("Personal expenses")
                }
            }
            .navigationTitle("iExpense")
            // Adding the functionality to add (for debug purposes) items via Toolbar
            .toolbar {
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    Picker("Sort", selection: $sortOrder) {
                        Text("Sort by Name")
                            .tag([SortDescriptor(\ExpenseItem.name)])
                        
                        Text("Sort by Amount")
                            .tag([SortDescriptor(\ExpenseItem.amount)])
                    }
                }
                
                NavigationLink(destination: AddView()) {
                    Button("Add Expense", systemImage: "plus") {} // The label will be used only on VoiceOver
                }
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ExpenseItem.self, configurations: config)
        
        return ContentView()
            .modelContainer(container)
    } catch {
        return Text("Failed to create container \(error.localizedDescription)")
    }
}
