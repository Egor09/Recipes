//
//  ReceptTableViewCell.swift
//  MortyAPI
//
//  Created by Егор Филиппов on 23.05.2022.
//

import UIKit

class ReceptTableViewCell: UITableViewCell {
    
    private let receptImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "sup")
        imageView.layer.cornerRadius = 15
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.text = "Карбонара с морепродуктами"
        label.font = .robotoBold16()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let receptLabel: UILabel = {
      let label = UILabel()
        label.text = "Рыбатекст используется дизайнерами, проектировщиками и фронтендерами, когда нужно быстро заполнить макеты или прототипы содержимым."
        label.font = .robotoMedium16()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let difficultyLabel: UILabel = {
       let label = UILabel()
        label.text = "Сложность: 3/5"
        label.font = .robotoMedium16()
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        selectionStyle = .none
        
        addSubview(nameLabel)
        addSubview(receptImageView)
        addSubview(receptLabel)
        addSubview(difficultyLabel)
    }
    
    func receptConfigure(model: Recipe) {        
        nameLabel.text = model.name
        receptLabel.text = model.recipeDescription
        difficultyLabel.text = "Сложность: \(model.difficulty)/5"
        
        if receptLabel.text == nil || receptLabel.text == "" {
            receptLabel.text = "Recipe not append"
        }
        
        let urlString = model.images
        
        NetworkImageRequest.shared.requestData(from: urlString) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                self.receptImageView.image = image
            case .failure(_):
                print("Error 4toto tam")
            }
        }
    }
    
    private func setConstraint() {
        
        NSLayoutConstraint.activate([
            receptImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            receptImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            receptImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            receptImageView.widthAnchor.constraint(equalToConstant: 140)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: receptImageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            receptLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            receptLabel.leadingAnchor.constraint(equalTo: receptImageView.trailingAnchor, constant: 5),
            receptLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
        
        NSLayoutConstraint.activate([
            difficultyLabel.topAnchor.constraint(equalTo: receptLabel.bottomAnchor, constant: 10),
            difficultyLabel.leadingAnchor.constraint(equalTo: receptImageView.trailingAnchor, constant: 10)
        ])
    }
}
