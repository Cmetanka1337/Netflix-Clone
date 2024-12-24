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
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImage)
        addSubview(playButton)
        addSubview(downloadButton)
        drawGradient()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        heroImage.frame = bounds
    }
    
    private func configure(){
        
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
        gradientLayer.frame = CGRect(x: 0, y: 270, width: Int(bounds.width), height: Int(bounds.height - 270))
    }
}
