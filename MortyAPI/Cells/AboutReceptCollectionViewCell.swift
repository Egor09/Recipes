//
//  AboutReceptCollectionViewCell.swift
//  MortyAPI
//
//  Created by Егор Филиппов on 28.05.2022.
//

import UIKit

class AboutReceptCollectionViewCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
        
    }()
    
//    override func prepareForReuse() {
//        imageView.image = nil
//    }
    override func layoutSubviews() {
        imageView.layer.cornerRadius = imageView.frame.width / 10
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraint()
//        layoutSubviews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    private func setupViews() {
//        imageView.layer.cornerRadius = imageView.frame.width / 2
        backgroundColor = .clear
        addSubview(imageView)
    }
    
    func receptConfigure(model: Recipe) {
        
        let urlString = model.images
        
        NetworkImageRequest.shared.requestData(from: urlString) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                self.imageView.image = image
            case .failure(_):
                print("Error 4toto tam")
            }
        }
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
