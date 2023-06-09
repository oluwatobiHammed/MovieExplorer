//
//  HomeTabSelectorHeaderView.swift
//  MovieDetails
//
//  Created by Oladipupo Oluwatobi on 09/06/2023.
//

import UIKit

protocol HomeTabSelectorHeaderViewProtocol: AnyObject {
    func tabSelected(selectedItemIndex: Int)
}

class HomeTabSelectorHeaderView: UIView {
    
    weak var delegate: HomeTabSelectorHeaderViewProtocol?
    
    let TabBarMenuCellReuseIdentifier = "TabBarMenuCellReuseIdentifier"
        
    lazy var tabBarMenuCollectionView : UICollectionView = {
        let space = CGFloat(4)
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        collectionViewFlowLayout.minimumInteritemSpacing = space
        collectionViewFlowLayout.minimumLineSpacing = space
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 8, right: space)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(HomeTabSelectorCell.self, forCellWithReuseIdentifier: TabBarMenuCellReuseIdentifier)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
        
    }()
    
    var barArray: [String]
    
    init(frame: CGRect, barArray: [String]) {
        self.barArray = barArray
        super.init(frame: frame)
        backgroundColor = .clear
    //    addSubview(tabBarMenuCollectionView)
//        tabBarMenuCollectionView.anchor(top: topAnchor,
//                                        left: leftAnchor,
//                                        bottom: bottomAnchor,
//                                        right: rightAnchor)
        tabBarMenuCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .left)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func updateSelectedItem(itemIndex: Int) {
     
        tabBarMenuCollectionView.selectItem(at: IndexPath(row: itemIndex, section: 0), animated: true, scrollPosition: .left)
        delegate?.tabSelected(selectedItemIndex: itemIndex)
    }
    
    
    
}

extension HomeTabSelectorHeaderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return barArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let tabBarMenuCell = collectionView.dequeueReusableCell(withReuseIdentifier: TabBarMenuCellReuseIdentifier, for: indexPath) as! HomeTabSelectorCell
        tabBarMenuCell.titleLabel.text = barArray[indexPath.row]
        return tabBarMenuCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.tabSelected(selectedItemIndex: indexPath.row)
    }
    
}

extension HomeTabSelectorHeaderView: HomeTabSelectorHeaderViewProtocol {
    func tabSelected(selectedItemIndex: Int) {

    }
}
