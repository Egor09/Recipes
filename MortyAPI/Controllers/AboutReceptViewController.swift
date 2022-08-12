//
//  AboutReceptViewController.swift
//  MortyAPI
//
//  Created by Егор Филиппов on 25.05.2022.
//

import UIKit

class AboutReceptViewController: UIViewController {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let receptCollectionImageView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //         collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    //    private lazy var closeButton: UIButton = {
    //        let button = UIButton(type: .system)
    //        button.setBackgroundImage(UIImage(named: "closeButton2"), for: .normal)
    //        button.clipsToBounds = true
    //        button.translatesAutoresizingMaskIntoConstraints = false
    //        button.addTarget(self, action: #selector(closeButtonTarget), for: .touchUpInside)
    //        return button
    //    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.isEnabled = false
        pageControl.numberOfPages = recipeModel?.images.count ?? 0
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Карбонара с морепродуктами"
        label.font = .robotoBold24()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let receptDesceiptionNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Описание: "
        label.font = .robotoBold20()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let receptDesceiptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Рыбатекст используется дизайнерами, проектировщиками и фронтендерами, когда нужно быстро заполнить макеты или прототипы содержимым."
        label.numberOfLines = 20
        label.font = .robotoMedium16()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let receptInstructionsNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Рецепт: "
        label.font = .robotoBold20()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let receptInstructionsLabel: UILabel = {
        let label = UILabel()
        label.text = "Рыбатекст используется дизайнерами, проектировщиками и фронтендерами, когда нужно быстро заполнить макеты или прототипы содержимым.Рыбатекст используется дизайнерами, проектировщиками и фронтендерами, когда нужно быстро заполнить макеты или прототипы содержимым."
        label.numberOfLines = 20
        label.font = .robotoMedium16()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let difficulty: UILabel = {
        let label = UILabel()
        label.text = "Сложность: 3/5"
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        label.font = .robotoMedium18()
        label.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var collectionViewRecipe: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    //    override func viewDidLayoutSubviews() {
    //        closeButton.layer.cornerRadius = closeButton.frame.width / 2
    //    }
    
    private let idCollectionCell = "idCollectionCell"
    private let idCollectionImageCell = "idCollectionImageCell"
    
    var recipeModel: Recipe?
    var recipeArray = [Recipe]()
    var arrRandomRecipe = [Recipe]()
    var arrImages = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aboutRecipes()
        getRandomRecipe()
        setupViews()
        setConstraints()
        setDelegates()
    }
    
    private func setDelegates() {
        collectionViewRecipe.delegate = self
        collectionViewRecipe.dataSource = self
        receptCollectionImageView.delegate = self
        receptCollectionImageView.dataSource = self
    }
    
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(receptCollectionImageView)
        scrollView.addSubview(mainLabel)
        scrollView.addSubview(pageControl)
        scrollView.addSubview(receptDesceiptionNameLabel)
        scrollView.addSubview(receptDesceiptionLabel)
        scrollView.addSubview(receptInstructionsNameLabel)
        scrollView.addSubview(receptInstructionsLabel)
        scrollView.addSubview(difficulty)
        scrollView.addSubview(collectionViewRecipe)
        
        collectionViewRecipe.register(AboutReceptCollectionViewCell.self, forCellWithReuseIdentifier: idCollectionCell)
        receptCollectionImageView.register(AboutImageCollectionViewCell.self, forCellWithReuseIdentifier: idCollectionImageCell)
    }
    
    private func aboutRecipes() {
        guard let recipeModel = recipeModel else { return }
        mainLabel.text = recipeModel.name
        receptDesceiptionLabel.text = recipeModel.recipeDescription
        receptInstructionsLabel.text = recipeModel.instructions
        difficulty.text = "Сложность: \(recipeModel.difficulty)/5"
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.height
        let horizontalCenter = width / 2
        pageControl.currentPage = Int(offSet + horizontalCenter) / Int(width)
    }
    private func getRandomRecipe() {
        for _ in 0...16 {
            let randInt = Int.random(in: 0...recipeArray.count - 1)
            arrRandomRecipe.append(recipeArray[randInt])
        }
        let sortArray = unique(source: self.arrRandomRecipe)
        arrRandomRecipe = sortArray
    }
    
    func unique<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}



//MARK: - UICollectionViewDataSource -- Bottom

extension AboutReceptViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == receptCollectionImageView {
            return recipeModel?.images.count ?? 0
        } else {
            return arrRandomRecipe.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewRecipe {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idCollectionCell, for: indexPath) as! AboutReceptCollectionViewCell
            
            let model = arrRandomRecipe[indexPath.row]
            cell.receptConfigure(model: model)
            return cell
            
            
        } else {
            
            let cellTwo = collectionView.dequeueReusableCell(withReuseIdentifier: idCollectionImageCell, for: indexPath) as! AboutImageCollectionViewCell
            guard let urlString = recipeModel?.images else { return cellTwo }
            
            NetworkImageRequest.shared.requestData(from: urlString) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    let image = UIImage(data: data)
                    guard let image = image else { return }
                    
                    urlString.forEach {_ in
                        self.arrImages.append(image)
                        //                        print(self.arrImages)
                    }
                case .failure(_):
                    print("Error 4toto tam")
                }
//                let image1 = self.arrImages[indexPath.item]
                let sortArray = self.unique(source: self.arrImages)
                let imageArray = sortArray[indexPath.item]
                DispatchQueue.main.async() {
                    cellTwo.imageView.image = imageArray
                }
            }
            return cellTwo
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout -- Bottom

extension AboutReceptViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewRecipe {
            return CGSize(width: collectionView.frame.height,
                          height: collectionView.frame.height)
        } else {
            return CGSize(width: collectionView.frame.height,
                          height: collectionView.frame.height)
        }
    }
}


extension AboutReceptViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewRecipe {
            let characterModel =  arrRandomRecipe[indexPath.row]
            let aboutReceptViewController = AboutReceptViewController()
            aboutReceptViewController.recipeArray = recipeArray
            aboutReceptViewController.recipeModel = characterModel
            
            navigationController?.pushViewController(aboutReceptViewController, animated: true)
            navigationItem.backButtonTitle = ""
        }
    }
}


//MARK: - setConstraints

extension AboutReceptViewController {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            receptCollectionImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            receptCollectionImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            receptCollectionImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            receptCollectionImageView.heightAnchor.constraint(equalToConstant: view.frame.width)
        ])
        
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: receptCollectionImageView.bottomAnchor, constant: 5),
            pageControl.centerXAnchor.constraint(equalTo: receptCollectionImageView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 10),
            mainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            mainLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            receptDesceiptionNameLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 20),
            receptDesceiptionNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            receptDesceiptionNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            receptDesceiptionLabel.topAnchor.constraint(equalTo: receptDesceiptionNameLabel.bottomAnchor, constant: 10),
            receptDesceiptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            receptDesceiptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            receptInstructionsNameLabel.topAnchor.constraint(equalTo: receptDesceiptionLabel.bottomAnchor, constant: 20),
            receptInstructionsNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            receptInstructionsNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            receptInstructionsLabel.topAnchor.constraint(equalTo: receptInstructionsNameLabel.bottomAnchor, constant: 10),
            receptInstructionsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            receptInstructionsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            difficulty.topAnchor.constraint(equalTo: receptInstructionsLabel.bottomAnchor, constant: 20),
            difficulty.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            difficulty.heightAnchor.constraint(equalToConstant: 50),
            difficulty.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            collectionViewRecipe.topAnchor.constraint(equalTo: difficulty.bottomAnchor, constant: 20),
            collectionViewRecipe.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionViewRecipe.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionViewRecipe.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            collectionViewRecipe.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0)
        ])
    }
}
