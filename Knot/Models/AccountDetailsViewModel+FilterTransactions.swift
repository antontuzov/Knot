//
//  AccountDetailsViewModel+FilterTransactions.swift
//  Knot
//
//  Created by Jessica Huynh on 2020-03-29.
//  Copyright © 2020 Jessica Huynh. All rights reserved.
//

import Foundation

// MARK: Delegate for time frame picker
extension AccountDetailsViewModel: TransactionsHeaderCellDelegate {
    func transactionsHeaderCell(_: TransactionsHeaderCell, didUpdateTimeFrame timeFrame: DateInterval) {
        self.timeFrame = timeFrame
        isLoading = true
        updatePostedTransactions {
            [weak self] in
            guard let self = self else { return }
            self.filterTransactions()
        }
    }
}

// MARK: - Delegate for filtering by account
extension AccountDetailsViewModel: FilterTransactionsViewControllerDelegate {
    func filterTransactionsViewController(_: FilterTransactionsViewController, filteredAccountsOnClose accountFilterItems: [AccountFilterItem]) {
        if accountFilterItems == self.accountFilterItems {
            // Filtering parameters haven't changed since last time
            return
        }
        
        isLoading = true
        self.accountFilterItems = accountFilterItems
        filterTransactions()
    }
    
    // MARK: - Helper function to filter transactions
    func filterTransactions() {
        // Make list of user's selected accounts
        var selectedAccountIDs: [String] = []
        for accountItem in accountFilterItems {
            if accountItem.isChecked {
                selectedAccountIDs.append(accountItem.account.id)
            }
        }
        
        if accounts.count == selectedAccountIDs.count {
            // User is not filtering any accounts so filtered = unfiltered
            if accountType == .credit {
                 let pendingTransactionsSection = sections[1] as! PendingTransactionsSection
                pendingTransactionsSection.filteredTransactions = pendingTransactionsSection.unfilteredTransactions
            }
            
            let postedTransactionsSection = sections.last as! PostedTransactionsSection
            postedTransactionsSection.filteredTransactions = postedTransactionsSection.unfilteredTransactions
            
            isLoading = false
            return
        }
        
        // User is filtering accounts
        if accountType == .credit {
            filterPendingTransactions(using: selectedAccountIDs)
        }
        
        filterPostedTransactions(using: selectedAccountIDs)
        isLoading = false
    }
    
    func filterPendingTransactions(using selectedAccountIDs: [String]) {
        let pendingTransactionsSection = sections[1] as! PendingTransactionsSection
        let unfilteredTransactions = pendingTransactionsSection.unfilteredTransactions
        
        pendingTransactionsSection.filteredTransactions = unfilteredTransactions.filter {
            selectedAccountIDs.contains($0.accountID)
        }
    }
    
    func filterPostedTransactions(using selectedAccountIDs: [String]) {
        let postedTransactionsSection = sections.last as! PostedTransactionsSection
        let unfilteredTransactions = postedTransactionsSection.unfilteredTransactions
        
        postedTransactionsSection.filteredTransactions = unfilteredTransactions.filter {
            selectedAccountIDs.contains($0.accountID)
        }
    }
}
