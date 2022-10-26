//
//  HomeViewController.swift
//  alteacareTest
//
//  Created by Edit sanrio Putra on 26/10/22.
//

import UIKit
import RxSwift
import SDWebImage
import RSSelectionMenu

class HomeViewController : BaseViewController {
    
    var gridCollectionview : UICollectionView!
    let viewModel = HomeViewModel()
    let searchController = UISearchController()


    var data : [HomeItemDto] = []
    var newData : [HomeItemDto] = []

    override func viewDidLoad() {
        self.title = "Doctor Profile"
        viewModel.liveData.subscribe(
            onNext: { data in
                self.hideLoading()
                self.data = data.data
                self.newData = data.data
                self.gridCollectionview.reloadData()
            }
        ).disposed(by: self.disposeBag)
        
        viewModel.liveError.subscribe(
            onNext: { error in
                Log.debug(error)
                self.hideLoading()
            }
        ).disposed(by: self.disposeBag)
        
        showLoading()
        viewModel.getCardsData()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = .done
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 4
        
        gridCollectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        gridCollectionview.register(HomeCell.self,
                                    forCellWithReuseIdentifier: HomeCell.identifier)
        
        gridCollectionview.delegate = self
        gridCollectionview.dataSource = self
        
        gridCollectionview.setCollectionViewLayout(layout, animated: true)
        view.addSubview(gridCollectionview)
        gridCollectionview.frame = view.bounds
        
    }
    
    
    
}

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = data[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCell.identifier, for: indexPath) as! HomeCell
        cell.home = data
        cell.backgroundColor = .randomColor()
        
        return cell
    }
    
}

extension HomeViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 8.0, bottom: 1.0, right: 8.0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let lay = collectionViewLayout as! UICollectionViewFlowLayout
//        let widthPerItem = collectionView.frame.width / 2 - lay.minimumInteritemSpacing
        return CGSize(width: collectionView.frame.width, height: 270)
    }
}

extension HomeViewController: UISearchBarDelegate , UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.data.removeAll()
        
        for item in self.newData {
            if (item.name.lowercased().contains(searchController.searchBar.text!.lowercased())) {
                self.data.append(item)
            }
        }
        
        if(searchController.searchBar.text!.isEmpty) {
            self.data = self.newData
        }
        gridCollectionview.reloadData()
    }
    
    
}

extension CGFloat {
    static func randomValue() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func randomColor() -> UIColor {
        return UIColor(
           red:   .randomValue(),
           green: .randomValue(),
           blue:  .randomValue(),
           alpha: 1.0
        )
    }
}
