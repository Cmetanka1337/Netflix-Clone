//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by Всеволод Буртик on 16.12.2024.
//

import UIKit

class SearchViewController: UIViewController {
    
    let discoverTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()

    var titles: [Title] = [Title]()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Search"
        
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(discoverTable)
        
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
                print(error.localizedDescription)
            }
        }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(titles.count)
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.tintColor = .brown
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        print(title.id)
        let model = TitleViewModel(titleName: title.original_title ?? title.title ?? "No data", posterURL: title.poster_path ?? "Placeholder for default image")
        cell.configure(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
}
