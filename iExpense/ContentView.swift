//
//  ContentView.swift
//  iExpense
//
//  Created by Víctor Ávila on 27/01/24.
//

import SwiftUI

// We will make a list of expenses by creating a separate Expenses class that will be attached using @State.
// 1. What do we wanna store about an expense? The name of the item, whether it is for business or personal, and its cost.

// We could put this inside an ExpenseItem.swift file
// By conforming to the Identifiable protocol, we say that this type of data can be identified uniquely somehow (there must be a property called id that contains some kind of unique identifier (it could be an int or a string)). Finally, we can remove id:\.id from the ForEach because of this!!!
struct ExpenseItem : Identifiable, Codable {
    // UUID: Universal Unique Identifier (we could add the id by ourselves, but we would have to check which ids were already given before). It's a sequence of 32 hex digits.
    var id = UUID() // Here, we tell Swift to create one for us. This has to be var because we set an initial value for it.
    let name: String
    let type: String
    let amount: Double
}

// The next step is to store an Array of ExpenseItem into a single Observable object.
// SwiftUI will only update the Views in which the property has changed.
@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet { // Saving to the disk every time a change is made
            // 1. Make a new JSONEncoder() that will encode our data to JSON
            // 2. Ask that to try encoding our Array to JSON
            // 3. Then, write it out UserDefaults with a particular key
            // 4. .encode() can only be applied to objects that conform to the Codable protocol
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    // A new initializer to load the UserDefaults from persistent storage
    // 1. Attempt to read the same key from UserDefaults
    // 2. Make a new JSONDecoder()
    // 3. Convert the JSON data from UserDefaults into an Array of [ExpenseItem]()
    // 4. If it worked, put it into the items Array. If not, create a new empty Array.
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) { // .self is used here to specify we want an Array of type ExpenseItem. We are referring to the type itself.
                items = decodedItems
                return
            }
        }
        // If any of those fails
        items = []
    }
}

struct ContentView: View {
    // Since we want to further delete items using .onDelete(), we have to create the list using ForEach().
    // The @State here is just to make expenses alive
    @State private var expenses = Expenses()
    
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
                    ForEach(expenses.items) { item in
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
                    .onDelete(perform: removeItems)
                } header: {
                    Text("Business expenses")
                }
                

                Section() {
                    // Here, using the name as id worked. But we could have multiple expenses with the same name, which sometimes will cause bizarre animations.
                    // Using the id as id is a much better solution, because we guarantee that there is ~no chance of repeating the same id.
                    //                ForEach(expenses.items, id: \.id) { item in
                    //                    Text(item.name)
                    ForEach(expenses.items) { item in
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
                    .onDelete(perform: removeItems)
                } header: {
                    Text("Personal expenses")
                }
                
            }
            .navigationTitle("iExpense")
            // Adding the functionality to add (for debug purposes) items via Toolbar
            .toolbar {
                NavigationLink(destination: AddView(expenses: expenses)) {
                    Button("Add Expense", systemImage: "plus") {} // The label will be used only on VoiceOver
                }
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
