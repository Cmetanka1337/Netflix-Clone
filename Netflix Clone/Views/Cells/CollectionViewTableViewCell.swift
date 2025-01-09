//
//  CollectionViewTableViewCell.swift
//  Netflix Clone
//
//  Created by Всеволод Буртик on 16.12.2024.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel)
}

class CollectionViewTableViewCell: UITableViewCell {
    
    static let identifier = "CollectionViewTableViewCell"
    private var titles: [Title] = [Title]()
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = contentView.bounds
    }
    
    public func configure(with titles: [Title]) {
        self.titles = titles
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func downloadTitleAt(indexPath: IndexPath) {
        let title = titles[indexPath.row]
        DataPersistenceManager.shared.downloadTitleWith(model: title) { results in
            switch results {
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
            case .failure(let error):
                DispatchQueue.main.async {
                    let _ = MessageContainerView(superview: self, title: "Something went wrong!", text: error.localizedDescription, image: UIImage(systemName: "exclamationmark.triangle"))
                }
            }
        }
    }
    
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        guard let posterUrl = titles[indexPath.row].poster_path else { return UICollectionViewCell() }
        cell.configure(with: posterUrl)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let title = titles[indexPath.row].original_title ?? titles[indexPath.row].title else { return }
        APICaller.shared.getVideo(query: title + " trailer") { [weak self] results in
            switch results {
            case .success(let videoElement):
                guard let self = self else { return }
                let overview = self.titles[indexPath.row].overview
                let viewModel = TitlePreviewViewModel(
                    title: title,
                    youtubeVideo: videoElement,
                    titleOverview: overview ?? "Review not found",
                    releaseDate: Date().convertToForm(titles[indexPath.row].release_date ?? ""),
                    adults: titles[indexPath.row].adult,
                    voteAverage: titles[indexPath.row].vote_average
                )
                self.delegate?.collectionViewTableViewCellDidTapCell(self, viewModel: viewModel)
            case .failure(let error):
                DispatchQueue.main.async {
                    guard let view = self?.superview else { return }
                    let _ = MessageContainerView(superview: view, title: "Something went wrong!", text: error.localizedDescription, image: UIImage(systemName: "exclamationmark.triangle"))
                }
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(actionProvider:  { _ in
            let downloadAction = UIAction(title: "Download",state: .off) { _ in
                self.downloadTitleAt(indexPath: indexPath)
            }
            return UIMenu(options: .displayInline, children: [downloadAction])
        })
        
        return config
    }
}
