//
//  HomeViewController.swift
//  alteacareTest
//
//  Created by Edit sanrio Putra on 26/10/22.
//

import UIKit
import RxSwift
import SDWebImage
import DropDown

class HomeViewController : BaseViewController {
    
    var gridCollectionview : UICollectionView!
    let viewModel = HomeViewModel()
    let searchController = UISearchController()
    
    let dropdownHospital = DropDown()
    lazy var dropdownHospitalField: UITextField = {
        let field = UITextField()
        field.font = .systemFont(ofSize: 12)
        field.placeholder = "Hospital"
        field.textAlignment = .center
        field.borderStyle = UITextField.BorderStyle.line
        field.backgroundColor = .white
        field.layer.borderWidth = 0.5
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let dropdownSpecialization = DropDown()
    lazy var dropdownSpecializationField: UITextField = {
        let field = UITextField()
        field.font = .systemFont(ofSize: 12)
        field.placeholder = "Specialization"
        field.textAlignment = .center
        field.borderStyle = UITextField.BorderStyle.line
        field.backgroundColor = .white
        field.layer.borderWidth = 0.5
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    var data : [HomeItemDto] = []
    var newData : [HomeItemDto] = []
    
    var hospitalFilter : [String] = []
    var specializationFilter : [String] = []
    var query = ""

    override func viewDidLoad() {
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.title = "Doctor Profile"
        if #available(iOS 15.0, *) {
            self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        }
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
        
        dropdownHospitalField.addTarget(self, action: #selector(hospitalOnclick), for: .editingDidBegin)
        dropdownSpecializationField.addTarget(self, action: #selector(specializationOnclick), for: .editingDidBegin)

        
        showLoading()
        viewModel.getCardsData()
        searchBar()
        setupCollectionView()
    }
    
    private func searchBar() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = .done
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.isTranslucent = true
        
        if #available(iOS 15.0, *) {
            var textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
            textFieldInsideSearchBar?.textColor = .white
        }
        
    }
    
    private func setupCollectionView() {
        
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
        
        view.addSubview(dropdownSpecializationField)
        view.addSubview(dropdownHospitalField)
//      hospital
        
        dropdownHospitalField.translatesAutoresizingMaskIntoConstraints = false
        dropdownHospitalField.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 0.45).isActive = true
        dropdownHospitalField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20).isActive = true
        dropdownHospitalField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16).isActive = true
        dropdownHospitalField.trailingAnchor.constraint(equalTo: dropdownSpecializationField.leadingAnchor,constant: -8).isActive = true
        
//      specialization
        dropdownSpecializationField.translatesAutoresizingMaskIntoConstraints = false
        dropdownSpecializationField.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 0.45).isActive = true
        dropdownSpecializationField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20).isActive = true
        dropdownSpecializationField.leadingAnchor.constraint(equalTo: dropdownHospitalField.trailingAnchor,constant: 8).isActive = true
        dropdownSpecializationField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16).isActive = true
        
//      collectionview
        view.addSubview(gridCollectionview)
//        gridCollectionview.frame = view.bounds
        gridCollectionview.translatesAutoresizingMaskIntoConstraints = false
        gridCollectionview.topAnchor.constraint(equalTo: dropdownHospitalField.bottomAnchor,constant: 8).isActive = true
        gridCollectionview.leadingAnchor.constraint(equalTo: view.leadingAnchor ).isActive = true
        gridCollectionview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        gridCollectionview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        
        
    }
    
    @objc func hospitalOnclick() {
        for items in newData {
            for hospital in items.hospital {
                dropdownHospital.dataSource.append(hospital.name)
            }
        }
        dropdownHospital.dataSource.removeDuplicates()
        dropdownHospital.multiSelectionAction = { [weak self] (indices, items) in
            print("Muti selection action called with: \(items)")
            guard let self = self else { return }
            if !items.isEmpty {
                self.dropdownHospitalField.text = items.last
                self.hospitalFilter = items
                self.data = self.data.filter({ item in
                    item.hospital.contains { hospital in
                        items.contains { hospitalFilter in
                            hospital.name == hospitalFilter
                        }
                    }
                })
            } else if self.query.isEmpty && self.specializationFilter.isEmpty {
                self.data = self.newData
            }
            self.gridCollectionview.reloadData()
        }
        dropdownHospital.anchorView = dropdownHospitalField
        dropdownHospital.direction = .bottom
        dropdownHospital.bottomOffset = CGPoint(x: 0, y: dropdownHospitalField.frame.size.height)
        dropdownHospital.show()
    }
    
    @objc func specializationOnclick() {
        for items in newData {
            dropdownSpecialization.dataSource.append(items.specialization.name)
        }
        dropdownSpecialization.dataSource.removeDuplicates()
        dropdownSpecialization.multiSelectionAction = { [weak self] (indices, items) in
            print("Muti selection action called with: \(items)")
            guard let self = self else { return }
            if !items.isEmpty {
                self.dropdownSpecializationField.text = items.last
                self.specializationFilter = items
                self.data = self.data.filter({ item in
                    items.contains { specialization in
                        item.specialization.name == specialization
                    }
                })
            } else if self.query.isEmpty && self.hospitalFilter.isEmpty {
                self.data = self.newData
            }
            self.gridCollectionview.reloadData()
        }
        dropdownSpecialization.anchorView = dropdownSpecializationField
        dropdownSpecialization.direction = .bottom
        dropdownSpecialization.bottomOffset = CGPoint(x: 0, y: dropdownSpecializationField.frame.size.height)
        dropdownSpecialization.show()
    }
    
}

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = data[indexPath.row]
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
        return CGSize(width: collectionView.frame.width, height: 270)
    }
}

extension HomeViewController: UISearchBarDelegate , UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {

        if let query = searchController.searchBar.text, query.count >= 1 {
            let filtersearchData = self.data.filter { item in
                item.name.lowercased().contains(query.lowercased())
            }
            data = filtersearchData
            self.query = query
        } else if hospitalFilter.isEmpty && specializationFilter.isEmpty {
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

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
