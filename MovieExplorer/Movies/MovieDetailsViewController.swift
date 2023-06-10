//
//  MovieDetailsViewController.swift
//  MovieExplorer
//
//  Created by Oluwatobi Oladipupo on 10/06/2023.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    
    private var movie: Movie
    
    private let posterImage: UIImageView = {
        $0.contentMode = .scaleToFill
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    lazy var overViewContainer: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white.withAlphaComponent(0.6)
        return view
    }()
    
    
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
    }
    
    private func setUpview() {
        view.addSubview(posterImage)
        posterImage.snp.makeConstraints { make in
            make.topMargin.equalToSuperview()
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
        }
        
        view.addSubview(overViewContainer)
        overViewContainer.snp.makeConstraints { make in
            make.top.equalTo(posterImage.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(200)
        }
    }
}
