//
//  UpcomingViewController.swift
//  Netflix Clone
//
//  Created by Всеволод Буртик on 16.12.2024.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    let upcomingTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()

    var titles: [Title] = [Title]()  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Upcoming"
        
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .systemGray
        
        view.addSubview(upcomingTable)
        
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        
        fetchUpcoming()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    private func fetchUpcoming() {
        APICaller.shared.getUpcomingMovies { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
            case.failure(let error):
                DispatchQueue.main.async {
                    
                    let _ = MessageContainerView(superview: self!.view, title: "Something went wrong!", text: error.localizedDescription, image: UIImage(systemName: "exclamationmark.triangle"))
                }
            }
        }
    }
}


extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
         }
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: (title.original_title ?? title.title) ?? "No Data", posterURL: title.poster_path ?? "placeholder for default image"))
        
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
                    let _ = MessageContainerView(superview: self!.view, title: "Something went wrong!", text: error.localizedDescription, image: UIImage(systemName: "exclamationmark.triangle"))
                }
            }
        }
    }
}
