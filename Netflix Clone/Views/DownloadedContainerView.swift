//
//  DownloadedContainerView.swift
//  Netflix Clone
//
//  Created by Всеволод Буртик on 05.01.2025.
//

import UIKit

class DownloadedContainerView: UIView {
    
    private var dimmingView: UIView?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "checkmark.circle")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .label
        
        return imageView
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.text = "Downloaded"
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tintColor = .label
        
        return label
    }()
    
    init(superview: UIView) {
        super.init(frame: .zero)
        configure()
        applyConstraints()
        addToSuperview(superview)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(textLabel)
        addSubview(imageView)
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 15
        layer.borderWidth = 1
        layer.borderColor = UIColor.tertiaryLabel.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
            textLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            textLabel.heightAnchor.constraint(equalToConstant: 50),
            textLabel.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    public func dismissView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            UIView.animate(withDuration: 0.3, animations: {
                self?.dimmingView?.alpha = 1
                self?.alpha = 0
            }, completion: { _ in
                self?.dimmingView?.removeFromSuperview()
                self?.removeFromSuperview()
            })
        }
    }
    
    public func addToSuperview(_ superview: UIView) {
        let dimmingView = UIView()
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.isUserInteractionEnabled = true
        
        superview.addSubview(dimmingView)
        superview.addSubview(self)
        
        self.dimmingView = dimmingView
        
        NSLayoutConstraint.activate([
            dimmingView.topAnchor.constraint(equalTo: superview.topAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            dimmingView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor),
            widthAnchor.constraint(equalToConstant: 300),
            heightAnchor.constraint(equalToConstant: 300)
        ])
        
        dimmingView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            dimmingView.alpha = 1
        }
        
        dismissView()
    }
}
