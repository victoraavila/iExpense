//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Víctor Ávila on 15/06/24.
//

import Foundation
import SwiftData

// We could put this inside an ExpenseItem.swift file
// By conforming to the Identifiable protocol, we say that this type of data can be identified uniquely somehow (there must be a property called id that contains some kind of unique identifier (it could be an int or a string)). Finally, we can remove id:\.id from the ForEach because of this!!!
@Model
class ExpenseItem {
    let name: String = "Item"
    let type: String = "Unknown"
    let amount: Double = 0.0
    
    init(name: String, type: String, amount: Double) {
        self.name = name
        self.type = type
        self.amount = amount
    }
}
