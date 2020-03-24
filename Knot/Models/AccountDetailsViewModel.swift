//
//  AccountDetailsViewModel.swift
//  Knot
//
//  Created by Jessica Huynh on 2020-03-10.
//  Copyright © 2020 Jessica Huynh. All rights reserved.
//

import Foundation
import UIKit

protocol AccountDetailsViewModelSection {
    var type: AccountDetailsViewModel.SectionType { get }
    var title: String { get }
    var rowCount: Int { get }
}

class AccountDetailsViewModel: NSObject {
    let storageManager = StorageManager.instance
    
    enum SectionType: Int {
        case accounts
        case transactions
    }
    
    var sections = [AccountDetailsViewModelSection]()
    
    init(for accountType: Account.AccountType?) {
        var accounts: [Account]?
        
        switch accountType {
        case .investment:
            accounts = storageManager.investmentAccounts
        case .credit:
            accounts = storageManager.creditAccounts
        case .depository:
            accounts = storageManager.cashAccounts
        case .loan, .other:
            print("WARNING: Not currently supporting loan/other account types.")
            return
        case .none:
            // No account type given means we are only going to show transactions.
            sections.append(AccountDetailsViewModelTransactions(transactions: storageManager.allTransactions))
            return
        }
        
        sections.append(AccountDetailsViewModelAccounts(accounts: accounts!))
    }
}

// MARK: - Table View Data Source
extension AccountDetailsViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        
        switch section.type {
        case .accounts:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountBalanceCell", for: indexPath) as! AccountBalanceCell
            let section = section as! AccountDetailsViewModelAccounts
            
            cell.configure(using: section.accounts[indexPath.row])
            return cell
            
        case .transactions:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
            let section = section as! AccountDetailsViewModelTransactions
            
            cell.configure(using: section.transactions[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
}

// MARK: - View Model Data
class AccountDetailsViewModelAccounts: AccountDetailsViewModelSection {
    var accounts: [Account]
    
    var type: AccountDetailsViewModel.SectionType {
        .accounts
    }
    
    var title: String {
        return "Accounts"
    }
    
    var rowCount: Int {
        return accounts.count
    }
    
    init(accounts: [Account]) {
        self.accounts = accounts
    }
}

class AccountDetailsViewModelTransactions: AccountDetailsViewModelSection {
    var transactions: [Transaction]
    
    var type: AccountDetailsViewModel.SectionType {
        return .transactions
    }
    
    var title: String {
        return "Transactions"
    }
    
    var rowCount: Int {
        return transactions.count
    }
    
    init(transactions: [Transaction]) {
        self.transactions = transactions
    }
}
