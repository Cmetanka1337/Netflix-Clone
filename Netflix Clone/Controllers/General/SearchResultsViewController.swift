//
//  SearchResultsViewController.swift
//  Netflix Clone
//
//  Created by Всеволод Буртик on 25.12.2024.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidTapItem(_ model: TitlePreviewViewModel)
}

class SearchResultsViewController: UIViewController {
    
    public var titles: [Title] = [Title]()
    
    public weak var delegate: SearchResultsViewControllerDelegate?
    
    public  let resultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBlue
        
        view.addSubview(resultsCollectionView)
        
        resultsCollectionView.delegate = self
        resultsCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        resultsCollectionView.frame = view.bounds
    }
    
}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        titles.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path ?? "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.title else { return }
        APICaller.shared.getVideo(query: titleName + "trailer") { [weak self] results in
            DispatchQueue.main.async {
                switch results {
                case .success(let videoElement):
                    let model = TitlePreviewViewModel(
                        title: titleName,
                        youtubeVideo: videoElement,
                        titleOverview: title.overview ?? "No Data",
                        releaseDate: Date().convertToForm(title.release_date ?? ""),
                        adults: title.adult,
                        voteAverage: title.vote_average
                    )
                    self?.delegate?.searchResultsViewControllerDidTapItem(model)
                case .failure(let error):
                    DispatchQueue.main.async {
                        DispatchQueue.main.async {
                            guard let view = self?.view else { return }
                            let _ = MessageContainerView(superview: view, title: "Something went wrong!", text: error.localizedDescription, image: UIImage(systemName: "exclamationmark.triangle"))
                        }
                    }
                }
            }
        }
    }
}
