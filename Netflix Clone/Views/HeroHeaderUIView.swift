//
//  HeroHeaderUIView.swift
//  Netflix Clone
//
//  Created by Всеволод Буртик on 17.12.2024.
//

import UIKit

class HeroHeaderUIView: UIView {

    let heroImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "heroImage")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
        button.backgroundColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
        button.backgroundColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImage)
        addSubview(playButton)
        addSubview(downloadButton)
        drawGradient()
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        heroImage.frame = bounds
    }
    
    public func configure(with model: Title) {
        guard let poster_path = model.poster_path, let url = URL(string: "https://image.tmdb.org/t/p/w500/\(poster_path)") else {
            DispatchQueue.main.async {
                self.heroImage.image = UIImage(named: "imagePlaceholder")
                self.downloadButton.isHidden = true
                self.playButton.isHidden = true
            }
            return
        }
    
        let action = UIAction { _ in
            DataPersistenceManager.shared.downloadTitleWith(model: model) { [weak self] results in
                switch results {
                case .success():
                    NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
                    guard let view = self else { return }
                    let downloadedView = DownloadedContainerView(superview: view)
                    downloadedView.dismissView()
                case .failure(let error):
                    DispatchQueue.main.async {
                        guard let self = self else { return }
                        let _ = MessageContainerView(superview: self, title: "Something went wrong!", text: error.localizedDescription, image: UIImage(systemName: "exclamationmark.triangle"))
                    }
                }
            }
        }
        
        DispatchQueue.main.async {
            self.downloadButton.addAction(action, for: .touchUpInside)
        }
        
        heroImage.sd_setImage(with: url)
    }
    
    private func applyConstraints(){
        
        NSLayoutConstraint.activate([
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -70),
            playButton.widthAnchor.constraint(equalToConstant: 100),
            
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -70),
            downloadButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func drawGradient() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        layer.addSublayer(gradientLayer)
        gradientLayer.frame = CGRect(x: 0, y: 370, width: Int(bounds.width), height: Int(bounds.height - 370))
    }
}
