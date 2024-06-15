//
//  iExpenseApp.swift
//  iExpense
//
//  Created by Víctor Ávila on 27/01/24.
//

import SwiftData
import SwiftUI

@main
struct iExpenseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ExpenseItem.self)
    }
}
