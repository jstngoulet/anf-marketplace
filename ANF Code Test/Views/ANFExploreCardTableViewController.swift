//
//  ANFExploreCardTableViewController.swift
//  ANF Code Test
//

import UIKit
import SwiftUI

class ANFExploreCardTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(
            HostingTableViewCell<PromotionView>.self,
            forCellReuseIdentifier: "ExploreContentCell"
        )
        tableView.estimatedRowHeight = 125
        
        
        
        Task {
            do {
                self.exploreData = try await ANFExplore.getMarketplaceData().promotions
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    private lazy var exploreData: [Promotion]? = {
        if let filePath = Bundle.main.path(forResource: "exploreData", ofType: "json"),
           let fileContent = try? Data(contentsOf: URL(fileURLWithPath: filePath)),
           let jsonDictionaryArray = try? JSONDecoder().decode([Promotion].self, from: fileContent) {
            return jsonDictionaryArray
        }
        return nil
    }() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
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
        
        guard let promoCell = cell as? HostingTableViewCell<PromotionView>
                , let cellData = exploreData?[indexPath.row]
        else { return cell }
        
        var promoView = PromotionView(promotiom: cellData)
        promoView.set(htmlDescription: cellData.bottomDescription?.htmlString)
        
        promoCell.set(
            rootView: promoView,
            parentController: self
        )
        
        return promoCell
    }
}
