//
//  ANFExploreCardTableViewController.swift
//  ANF Code Test
//

import UIKit
import SwiftUI

/**
 Provided:
 Base TableViewController class. Should use 'exploreData' as a data source
 */
class ANFExploreCardTableViewController: UITableViewController {
    
    /// The primary data to use (could be in view model with `loadContent()`)
    private(set) var exploreData: [Promotion]?
    
    /// On init, fetch content as soon as possible for presentation
    /// - Parameter coder: The coder to init from
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadContentWrapper()
    }
    
    /// When initialized from code, instead of storyboard, init content as quickly
    /// as possible so the content can be made available as soon as possible
    /// - Parameters:
    ///   - nibNameOrNil:   Nib name to load from bundle
    ///   - nibBundleOrNil: Nib bundle to load from
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        loadContentWrapper()
    }
    
    /// Due to our `loadContent` being async, we need a wrapper to put it
    /// in a task
    private func loadContentWrapper() {
        Task {
            await loadContent()
        }
    }
    
    /// Lifecyle function for when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = view.frame.height
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    /// While coiuld be a view model, this function will load the content and refresh the
    /// table presented when it loads.
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
    
    /// Table view delegate function to return the number of rows in the provided section.
    /// - Note:         We are only using a single section, so we do not need to break out different
    ///                 available values
    /// - Parameters:
    ///   - tableView:  The table view requesting a resource
    ///   - section:    The current section that is requesting a value (always 1)
    /// - Returns:      Returns the count of the number of items in the `exploreData` array, used for data source
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int
    { exploreData?.count ?? 0 }
    
    /// Table view delegate method for requesting the cell that is to be built within the table.
    /// Will be fetching data from `exploreData` to construct the cell from the provided info
    /// - Parameters:
    ///   - tableView:  The table view requesting a resource
    ///   - indexPath:  The current location in the table that the resource should be loaded.
    ///                 Only the item.row is considered since there is a single section
    /// - Returns:      The constructed cell of type `ExploreMarketplaceCell`
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
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
