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
    
    // 3 things to be done in order to show the AddView
    // 1. Add a @State property to track if we are showing the AddView or not
    // 2. Tell SwiftUI to use this boolean as a condition for showing a sheet
    // 3. Put an instance of the View inside the sheet
    @State private var showingAddExpense = false
    
    @State private var expenseTypes = [String]()
    
    var body: some View {
        NavigationStack() {
            List {
                Section() {
                    // Here, using the name as id worked. But we could have multiple expenses with the same name, which sometimes will cause bizarre animations.
                    // Using the id as id is a much better solution, because we guarantee that there is ~no chance of repeating the same id.
                    //                ForEach(expenses.items, id: \.id) { item in
                    //                    Text(item.name)
                    ForEach(expenses) { item in
                        if item.type == "Business" {
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
//                    .onDelete(perform: removeItems)
                } header: {
                    Text("Business expenses")
                }
                

                Section() {
                    // Here, using the name as id worked. But we could have multiple expenses with the same name, which sometimes will cause bizarre animations.
                    // Using the id as id is a much better solution, because we guarantee that there is ~no chance of repeating the same id.
                    //                ForEach(expenses.items, id: \.id) { item in
                    //                    Text(item.name)
                    ForEach(expenses) { item in
                        if item.type == "Personal" {
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
//                    .onDelete(perform: removeItems)
                } header: {
                    Text("Personal expenses")
                }
                
            }
            .navigationTitle("iExpense")
            // Adding the functionality to add (for debug purposes) items via Toolbar
            .toolbar {
                NavigationLink(destination: AddView()) {
                    Button("Add Expense", systemImage: "plus") {} // The label will be used only on VoiceOver
                }
            }
        }
    }
    
//    func removeItems(at offsets: IndexSet) {
//        expenses.items.remove(atOffsets: offsets)
//    }
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
