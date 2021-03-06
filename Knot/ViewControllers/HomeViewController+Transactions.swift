//
//  HomeViewController+Transactions.swift
//  Knot
//
//  Created by Jessica Huynh on 2020-03-16.
//  Copyright © 2020 Jessica Huynh. All rights reserved.
//

import Foundation
import UIKit

extension HomeViewController: UICollectionViewDataSource {
    func setupTransactionCollectionVew() {
        transactionCollectionView.dataSource = self
        transactionCollectionView.showsHorizontalScrollIndicator = false
        transactionCollectionView.register(
            UINib(nibName: "TransactionCollectionCell", bundle: nil),
            forCellWithReuseIdentifier: "TransactionCollectionCell")
        
        if !recentTransactions.isEmpty {
            noTransactionsFoundLabel.isHidden = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let maxTransactionsDisplayed = 6
        return (recentTransactions.count > maxTransactionsDisplayed ?
            maxTransactionsDisplayed + 1 : recentTransactions.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let lastTransactionIndex = 6
        if indexPath.row == lastTransactionIndex {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewMoreTransactionsCell", for: indexPath)
            return cell
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TransactionCollectionCell", for: indexPath) as! TransactionCollectionCell
        cell.configure(for: recentTransactions[indexPath.item])
        return cell
    }
}
