import UIKit
import WMF

@objc(WMFHistoryViewController)
class HistoryViewController: ArticleFetchedResultsViewController {

    override func setupFetchedResultsController(with dataStore: MWKDataStore) {
        let articleRequest = WMFArticle.fetchRequest()
        articleRequest.predicate = NSPredicate(format: "viewedDate != NULL")
        articleRequest.sortDescriptors = [NSSortDescriptor(keyPath: \WMFArticle.viewedDateWithoutTime, ascending: false), NSSortDescriptor(keyPath: \WMFArticle.viewedDate, ascending: false)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: articleRequest, managedObjectContext: dataStore.viewContext, sectionNameKeyPath: "viewedDateWithoutTime", cacheName: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isBarHidingEnabled = false
        navigationBar.isShadowHidingEnabled = true
        navigationBar.displayType = .largeTitle

        emptyViewType = .noHistory
        
        title = CommonStrings.historyTabTitle
        
        deleteAllButtonText = WMFLocalizedString("history-clear-all", value: "Clear", comment: "Text of the button shown at the top of history which deletes all history {{Identical|Clear}}")
        deleteAllConfirmationText =  WMFLocalizedString("history-clear-confirmation-heading", value: "Are you sure you want to delete all your recent items?", comment: "Heading text of delete all confirmation dialog")
        deleteAllCancelText = WMFLocalizedString("history-clear-cancel", value: "Cancel", comment: "Button text for cancelling delete all action {{Identical|Cancel}}")
        deleteAllText = WMFLocalizedString("history-clear-delete-all", value: "Yes, delete all", comment: "Button text for confirming delete all action")
        isDeleteAllVisible = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionViewUpdater.isGranularUpdatingEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NSUserActivity.wmf_makeActive(NSUserActivity.wmf_recentView())
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        collectionViewUpdater.isGranularUpdatingEnabled = false
    }
    
    override func deleteAll() {
        dataStore.historyList.removeAllEntries()
    }
    
    override var headerStyle: ColumnarCollectionViewController.HeaderStyle {
        return .sections
    }

    func titleForHeaderInSection(_ section: Int) -> String? {
        guard let sections = fetchedResultsController.sections, sections.count > section else {
            return nil
        }
        let sectionInfo = sections[section]
        guard let article = sectionInfo.objects?.first as? WMFArticle, let date = article.viewedDateWithoutTime else {
            return nil
        }
        
        return ((date as NSDate).wmf_midnightUTCDateFromLocal as NSDate).wmf_localizedRelativeDateFromMidnightUTCDate()
    }
    
    override func userTalkPageTitle(at indexPath: IndexPath) -> String? {
        guard let article = article(at: indexPath),
            let namespace = article.pageNamespace,
            namespace == .userTalk else {
                return nil
        }
        
        return article.displayTitle
    }
    
    override func configure(header: CollectionViewHeader, forSectionAt sectionIndex: Int, layoutOnly: Bool) {
        header.style = .history
        header.title = titleForHeaderInSection(sectionIndex)
        header.apply(theme: theme)
        header.layoutMargins = layout.itemLayoutMargins
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         if let userTalkPageTitle = userTalkPageTitle(at: indexPath),
            let siteURL = articleURL(at: indexPath)?.wmf_site {
                pushUserTalkPage(title: userTalkPageTitle, siteURL: siteURL)
                return
        }
        
        super.collectionView(collectionView, didSelectItemAt: indexPath)
    }

    override func collectionViewUpdater<T>(_ updater: CollectionViewUpdater<T>, didUpdate collectionView: UICollectionView) {
        super.collectionViewUpdater(updater, didUpdate: collectionView)
        updateVisibleHeaders()
    }

    func updateVisibleHeaders() {
        for indexPath in collectionView.indexPathsForVisibleSupplementaryElements(ofKind: UICollectionView.elementKindSectionHeader) {
            guard let headerView = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: indexPath) as? CollectionViewHeader else {
                continue
            }
            headerView.title = titleForHeaderInSection(indexPath.section)
        }
    }
    
    override var eventLoggingCategory: EventLoggingCategory {
        return .history
    }
}

// MARK: WMFSearchButtonProviding

extension HistoryViewController: WMFSearchButtonProviding {

}
