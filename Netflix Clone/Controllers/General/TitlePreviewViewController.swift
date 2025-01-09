//
//  TitlePreviewViewController.swift
//  Netflix Clone
//
//  Created by Всеволод Буртик on 25.12.2024.
//

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {
    
    var onDownloadButtonTapped: ((TitlePreviewViewModel) -> Void)?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let overviewTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 18, weight: .regular)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isScrollEnabled = true
        
        return textView
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.allowsDefaultTighteningForTruncation = true
        
        return label
    }()
    
    private let voteAvagareLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.allowsDefaultTighteningForTruncation = true
        
        return label
    }()
    
    private let adultLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.allowsDefaultTighteningForTruncation = true
        
        return label
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.layer.cornerCurve = .continuous
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        
        return button
    }()
    
    private let webview: WKWebView = {
        let webview = WKWebView()
        webview.translatesAutoresizingMaskIntoConstraints = false
        
        return webview
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.isHidden = false
        navigationItem.hidesBackButton = false
        
        view.addSubview(webview)
        view.addSubview(titleLabel)
        view.addSubview(overviewTextView)
        view.addSubview(downloadButton)
        view.addSubview(releaseDateLabel)
        view.addSubview(adultLabel)
        view.addSubview(voteAvagareLabel)

        applyConstraints()
    }
    
    private func applyConstraints() {
        
        NSLayoutConstraint.activate([
            webview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -3),
            webview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 3),
            webview.heightAnchor.constraint(equalToConstant: 300),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: webview.bottomAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            releaseDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            releaseDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            voteAvagareLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            voteAvagareLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            voteAvagareLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 5),
            
            adultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            adultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            adultLabel.topAnchor.constraint(equalTo: voteAvagareLabel.bottomAnchor, constant: 5),
            
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.widthAnchor.constraint(equalToConstant: 120),
            downloadButton.heightAnchor.constraint(equalToConstant: 50),
            downloadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            overviewTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            overviewTextView.topAnchor.constraint(equalTo: adultLabel.bottomAnchor, constant: 3),
            overviewTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            overviewTextView.bottomAnchor.constraint(equalTo: downloadButton.topAnchor, constant: -20)
        ])
    }
    
    public func configure(model: TitlePreviewViewModel) {
        titleLabel.text = model.title
        overviewTextView.text = model.titleOverview
        releaseDateLabel.text = "Release Date: \(model.releaseDate)"
        adultLabel.text = model.adults == true ? "For Adults Only: Yes" : "For Adults Only: No"
        voteAvagareLabel.text = "Rating: \(model.voteAverage)"
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeVideo.id.videoId)") else { return }
        webview.load(URLRequest(url: url))
        
        APICaller.shared.search(query: model.title) { [weak self] results in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch results {
                case .success(let loadedTitles):
                    guard let title = loadedTitles.first else { return }
                    
                    let downloadAction = UIAction { [weak self] _ in
                        DataPersistenceManager.shared.downloadTitleWith(model: title) { results in
                            switch results {
                            case .success():
                                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
                                guard let view = self?.view else { return }
                                let downloadedView = DownloadedContainerView(superview: view)
                                downloadedView.dismissView()
                            case .failure(let error):
                                DispatchQueue.main.async {
                                    guard let view = self?.view else { return }
                                    let _ = MessageContainerView(superview: view, title: "Something went wrong!", text: error.localizedDescription, image: UIImage(systemName: "exclamationmark.triangle"))
                                }
                            }
                        }
                    }
                    self.downloadButton.addAction(downloadAction, for: .touchUpInside)
                    
                case .failure(let error):
                    DispatchQueue.main.async {
                        let _ = MessageContainerView(superview: self.view, title: "Something went wrong!", text: error.localizedDescription, image: UIImage(systemName: "exclamationmark.triangle"))
                    }
                }
            }
        }
    }
}
