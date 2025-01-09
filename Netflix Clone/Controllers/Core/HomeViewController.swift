//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Всеволод Буртик on 16.12.2024.
//

import UIKit

enum Sections: Int{
    case TrendingMovies = 0
    case TrendingTV = 1
    case Popular = 2
    case UpcomingMovies = 3
    case TopRated = 4
}

class HomeViewController: UIViewController {
    
    private let sectionTitle = ["Trending movies", "Trending TV", "Popular", "Upcoming movies", "Top rated"]
    
    private var randomTrendingMovie: TitleViewModel?
    private var headerView: HeroHeaderUIView?

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
        
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
        configureNavBar()
        configureHeaderView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        homeFeedTable.frame = view.bounds
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
    
    private func configureHeaderView() {
        
        APICaller.shared.getTrendingMovies { [weak self ]result in
            switch result {
            case .success(let titles):
                guard let selectedTitle = titles.randomElement() else { return }
                self?.headerView?.configure(with: selectedTitle)
            case.failure(let error):
                
                DispatchQueue.main.async {
                    guard let view = self?.view else { return }
                    let _ = MessageContainerView(superview: view, title: "Something went wrong!", text: error.localizedDescription, image: UIImage(systemName: "exclamationmark.triangle"))
                }
            }
        }
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
        
        cell.delegate = self
        
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case.failure(let error):
                    
                    DispatchQueue.main.async {
                        let _ = MessageContainerView(superview: self.view, title: "Something went wrong!", text: error.localizedDescription, image: UIImage(systemName: "exclamationmark.triangle"))
                    }
                }
            }
        case Sections.TrendingTV.rawValue:
            APICaller.shared.getTrendingTv { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case.failure(let error):
                    DispatchQueue.main.async {
                        let _ = MessageContainerView(superview: self.view, title: "Something went wrong!", text: error.localizedDescription, image: UIImage(systemName: "exclamationmark.triangle"))
                    }
                }
            }
        case Sections.Popular.rawValue:
            APICaller.shared.getPopular { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case.failure(let error):
                    DispatchQueue.main.async {
                        let _ = MessageContainerView(superview: self.view, title: "Something went wrong!", text: error.localizedDescription, image: UIImage(systemName: "exclamationmark.triangle"))
                    }
                }
            }
        case Sections.UpcomingMovies.rawValue:
            APICaller.shared.getUpcomingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case.failure(let error):
                    DispatchQueue.main.async {
                        let _ = MessageContainerView(superview: self.view, title: "Something went wrong!", text: error.localizedDescription, image: UIImage(systemName: "exclamationmark.triangle"))
                    }
                }
            }
        case Sections.TopRated.rawValue:
            APICaller.shared.getTopRatedMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case.failure(let error):
                    DispatchQueue.main.async {
                        let _ = MessageContainerView(superview: self.view, title: "Something went wrong!", text: error.localizedDescription, image: UIImage(systemName: "exclamationmark.triangle"))
                    }
                }
            }
        default:
            return UITableViewCell()
        }
        
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
        content.textProperties.color = .systemGray
        content.textProperties.font = .systemFont(ofSize: 18, weight: .semibold)
        content.text = sectionTitle[section].lowercased()
        
        header.frame = CGRect(x: Int(header.bounds.origin.x) + 20, y: Int(header.bounds.origin.y), width: 100, height: Int(header.bounds.height))
        
        header.contentConfiguration = content
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let defaultOffset = view.safeAreaInsets.top
//        let offset = scrollView.contentOffset.y + defaultOffset
//        
//        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
//    }
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(model: viewModel)
            vc.navigationController?.isToolbarHidden = false
            vc.navigationController?.isNavigationBarHidden = false
            vc.navigationItem.hidesBackButton = false
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
