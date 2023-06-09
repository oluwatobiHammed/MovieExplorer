//
//  ViewController.swift
//  MovieDetails
//
//  Created by Oladipupo Oluwatobi on 08/06/2023.
//

import UIKit

class MovieListViewController: UIViewController {
    private let networkManager = NetworkManager()
    private lazy var rootDynamicTableView: UITableView = {
       // $0.delegate = self
       // $0.dataSource = self
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        //$0.refreshControl = refreshControl
        $0.contentInsetAdjustmentBehavior = .never
        return $0
    }(UITableView())

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(hexString: "#EFE5DB")
        networkManager.getSearch(page: 1, query: "spider man") { moview, err in
            
        }
    }


}

