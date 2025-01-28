//
//  ANFExploreCardTableViewController.swift
//  ANF Code Test
//

import UIKit
import SwiftUI

class ANFExploreCardTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = view.frame.height
        tableView.rowHeight = UITableView.automaticDimension
        
        Task {
            await loadContent()
        }
    }
    
    private(set) var exploreData: [Promotion]?
    
    func loadContent() async {
        do {
            self.exploreData = try await ANFExplore.getMarketplaceData().promotions
            
            await MainActor.run {
                self.tableView.reloadData()
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        exploreData?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(
            withIdentifier: "ExploreContentCell",
            for: indexPath
        )
        
        guard let promoCell = cell as? ExploreMarketplaceCell
                , let data = exploreData?[indexPath.row]
        else { return cell }
        
        promoCell.set(promotion: data)
        return promoCell
    }
}
