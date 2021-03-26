//
//  UsersListVC.swift
//  KosmosAssignment
//
//  Created by Hitesh on 25/03/21.
//

import UIKit
import CoreData

class UsersListVC: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!

    //MARK:- Property
    private var userPage = UserPageData(page: 1, perPage: 0, total: 0, totalPages: 0)
    private var isLoading = false
    
    private var dataProvider:DataProvider!
    private lazy var fetchResultsController: NSFetchedResultsController<CDUser> = {
        let fetchRequest:NSFetchRequest = CDUser.fetchRequest()
        fetchRequest.fetchBatchSize = 10
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "email", ascending: true)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: PersistentStorage.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        do {
            try controller.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return controller
    }()
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataProvider = DataProvider(persistanceContainer: PersistentStorage.shared.persistentContainer, repository: ApiRepository.shared)
        fetchUser(isShowActivity: true)
        setupCollectionView()
    }
    fileprivate func updateActivityView(isShowActivity:Bool) {
        activityView.isHidden = !isShowActivity
        if isShowActivity {
            activityView.startAnimating()
        } else {
            activityView.stopAnimating()
        }
    }
    fileprivate func fetchUser(isShowActivity:Bool) {
        updateActivityView(isShowActivity: isShowActivity)
        dataProvider.fetchUsers(nextPage: userPage.page) { [weak self] (userPageData, error) in
            
            if let pageData = userPageData {
                self?.userPage = pageData
            }
            
            if let err = error {
                // show alert
                print("error:=", err.localizedDescription)
            }
            self?.isLoading = false
            
            DispatchQueue.main.async {
                self?.updateActivityView(isShowActivity: false)
            }
        }
    }
    
    func callFetch() {
        _ = self.fetchResultsController
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: self.view.bounds.width, height: 100)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = flowLayout
    }
    private func fetchNextPage(indexPath:IndexPath) {
        if let count = fetchResultsController.sections?[indexPath.section].numberOfObjects, indexPath.row == count - 1, !isLoading, userPage.page != userPage.totalPages {
            userPage.page += 1
            fetchUser(isShowActivity: false)
        }
    }

}
//MARK:- UICollectionViewDataSource
extension UsersListVC:UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchResultsController.sections?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCVCell.reusableIdentifier, for: indexPath) as! UserCVCell
        let user = fetchResultsController.object(at: indexPath).convertToUser()
        cell.configureCell(user: user)
        fetchNextPage(indexPath: indexPath)
        return cell
    }
}
//MARK:- NSFetchedResultsControllerDelegate
extension UsersListVC:UICollectionViewDelegate {

}

//MARK:- NSFetchedResultsControllerDelegate
extension UsersListVC:NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        collectionView.reloadData()
    }
}
