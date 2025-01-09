//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by Всеволод Буртик on 16.12.2024.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let discoverTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        
        return table
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for Movie or a TV"
        controller.searchBar.searchBarStyle = .minimal
        
        return controller
    }()

    var titles: [Title] = [Title]()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Search"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .systemGray
        
        view.addSubview(discoverTable)
        
        searchController.searchResultsUpdater = self
        
        discoverTable.delegate = self
        discoverTable.dataSource = self
        
        fetchDiscover()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
    
    private func fetchDiscover() {
        APICaller.shared.getDiscoverMovies { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
            case.failure(let error):
                DispatchQueue.main.async {
                    guard let view = self?.view else { return }
                    let _ = MessageContainerView(superview: view, title: "Something went wrong!", text: error.localizedDescription, image: UIImage(systemName: "exclamationmark.triangle"))
                }
            }
        }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.tintColor = .brown
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        let model = TitleViewModel(titleName: title.original_title ?? title.title ?? "No data", posterURL: title.poster_path ?? "")
        cell.configure(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = self.titles[indexPath.row]
        let vc = TitlePreviewViewController()
        
        let titleName = title.original_title ?? title.title ?? "No Data"
        
        APICaller.shared.getVideo(query: titleName + " trailer") { [weak self] results in
            switch results {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let model = TitlePreviewViewModel(
                        title: titleName,
                        youtubeVideo: videoElement,
                        titleOverview: title.overview ?? "No Data",
                        releaseDate: Date().convertToForm(title.release_date ?? ""),
                        adults: title.adult,
                        voteAverage: title.vote_average
                    )
                    vc.configure(model: model)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case.failure(let error):
                DispatchQueue.main.async {
                    guard let view = self?.view else { return }
                    let _ = MessageContainerView(superview: view, title: "Something went wrong!", text: error.localizedDescription, image: UIImage(systemName: "exclamationmark.triangle"))
                }
            }
        }
    }
}

extension SearchViewController: UISearchResultsUpdating, SearchResultsViewControllerDelegate {
        
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let query = searchBar.text, 
                !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultController = searchController.searchResultsController as? SearchResultsViewController else { return }
        
        resultController.delegate = self
        
        APICaller.shared.search(query: query) { results in
            DispatchQueue.main.async {
                switch results {
                case .success(let titles):
                    resultController.titles = titles
                    resultController.resultsCollectionView.reloadData()
                case.failure(let error):
                    DispatchQueue.main.async {
                        let _ = MessageContainerView(superview: self.view, title: "Something went wrong!", text: error.localizedDescription, image: UIImage(systemName: "exclamationmark.triangle"))
                    }
                }
            }
        }
    }
    
    func searchResultsViewControllerDidTapItem(_ model: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            let viewModel = TitlePreviewViewModel(
                title: model.title,
                youtubeVideo: model.youtubeVideo,
                titleOverview: model.titleOverview,
                releaseDate: model.releaseDate,
                adults: model.adults,
                voteAverage: model.voteAverage
            )
            
            vc.configure(model: viewModel)
            
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
