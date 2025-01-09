//
//  ErrorContainerUIView.swift
//  Netflix Clone
//
//  Created by Всеволод Буртик on 08.01.2025.
//

import UIKit

class MessageContainerView: UIView {
    
    private var dimmingView: UIView?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingMiddle
        
        return label
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingMiddle
        
        return label
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .tertiarySystemFill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.setTitle("OK", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.tertiaryLabel.cgColor
        
        return button
    }()
    
    init(superview: UIView, title: String, text: String, image: UIImage?) {
        super.init(frame: .zero)
        
        configureWith(title: title, text: text, image: image)
        applyConstraints()
        addToSuperview(superview)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            titleLabel.widthAnchor.constraint(equalToConstant: 150),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            
            cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            cancelButton.heightAnchor.constraint(equalToConstant: 30),
            cancelButton.widthAnchor.constraint(equalToConstant: 80),
            cancelButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            textLabel.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -10),
        ])
    }
    
    private func configureWith(title: String, text: String, image: UIImage?) {
        addSubview(titleLabel)
        addSubview(textLabel)
        addSubview(cancelButton)
        addSubview(imageView)
        
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 15
        layer.borderWidth = 1
        layer.borderColor = UIColor.tertiaryLabel.cgColor
        translatesAutoresizingMaskIntoConstraints = false
        
        cancelButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        titleLabel.text = title
        textLabel.text = text
        imageView.image = image
    }
    
    private func addToSuperview(_ superview: UIView) {
        let dimmingView = UIView()
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.isUserInteractionEnabled = true
        superview.addSubview(dimmingView)
        
        superview.addSubview(self)
        
        NSLayoutConstraint.activate([
            dimmingView.topAnchor.constraint(equalTo: superview.topAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            dimmingView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            
            centerYAnchor.constraint(equalTo: superview.centerYAnchor),
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
        
        dimmingView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            dimmingView.alpha = 1
        }
        
        self.dimmingView = dimmingView
    }
    
    @objc func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.dimmingView?.alpha = 0
            self.alpha = 0
        }, completion: { _ in
            self.dimmingView?.removeFromSuperview()
            self.removeFromSuperview()
        })
    }
}
