//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Всеволод Буртик on 16.12.2024.
//

import UIKit

class HomeViewController: UIViewController {
    
    let sectionTitle = ["Trending movies", "Trending TV", "Popular", "Upcoming movies", "Top rated"]

    private let homeFeedTable: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        view.addSubview(homeFeedTable)
        view.backgroundColor = .systemBackground
        homeFeedTable.tableHeaderView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        configureNavBar()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        homeFeedTable.frame = view.bounds
    }
    
    private func fetchData() {
//        APICaller.shared.getTrendingMovies { results in
//            switch (results) {
//            case .success(let movies):
//                print(movies.first?.original_title!)
//            case .failure(let error):
//                print(error)
//            }
//        }
        
//        APICaller.shared.getTrendingTv { results in
//            
//        }
        
//        APICaller.shared.getPopular { results in
//            switch (results) {
//                case .success(let movies):
//                    print(movies.first?.original_title!)
//                case .failure(let error):
//                    print(error)
//            }
//        }
        
//        APICaller.shared.getUpcomingMovies { results in
//            switch (results) {
//                case .success(let movies):
//                    print(movies.first?.original_title!)
//                case .failure(let error):
//                    print(error)
//            }
//        }
        
        APICaller.shared.getTopRatedMovies { results in
            switch (results) {
                case .success(let movies):
                    print(movies.first?.original_title!)
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    private func configureNavBar() {
        let image = UIImage(named: "netflixLogo")?.withRenderingMode(.alwaysOriginal)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .systemRed
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell
        else { return UITableViewCell() }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        var content = header.defaultContentConfiguration()
        content.textProperties.color = .black
        content.textProperties.font = .systemFont(ofSize: 18, weight: .semibold)
        content.text = sectionTitle[section].lowercased()
        
        header.frame = CGRect(x: Int(header.bounds.origin.x) + 20, y: Int(header.bounds.origin.y), width: 100, height: Int(header.bounds.height))
        
        header.contentConfiguration = content
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}
