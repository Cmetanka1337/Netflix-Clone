//
//  DownloadsViewController.swift
//  Netflix Clone
//
//  Created by Всеволод Буртик on 16.12.2024.
//

import UIKit

class DownloadsViewController: UIViewController {
    
    var downloadsTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()

    var titles: [TitleItem] = [TitleItem]()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(downloadsTable)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        title = "Downloads"
        downloadsTable.delegate = self
        downloadsTable.dataSource = self
        
        fetchLocalStorageForDownload()
        
        NotificationCenter.default.addObserver(forName: Notification.Name("downloaded"), object: nil, queue: nil) { [weak self] _ in
            self?.fetchLocalStorageForDownload()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        downloadsTable.frame = view.bounds
    }
    
    private func fetchLocalStorageForDownload() {
        DataPersistenceManager.shared.fetchTitlesFromDatabase { [weak self] results in
            switch results {
            case .success(let titles):
                self?.titles = titles
                print("reloading table")
                DispatchQueue.main.async {
                    self?.downloadsTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DataPersistenceManager.shared.deleteTitleWith(model: titles[indexPath.row]) { [weak self] results in
                switch results {
                case .success(()):
                    self?.titles.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    DispatchQueue.main.async {
                        tableView.reloadData()
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            break
        }
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
                    let model = TitlePreviewViewModel(title: titleName, youtubeVideo: videoElement, titleOverview: title.overview ?? "No Data")
                    vc.configure(model: model)
                    
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
