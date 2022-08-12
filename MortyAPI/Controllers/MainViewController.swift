//
//  ViewController.swift
//  MortyAPI
//
//  Created by Егор Филиппов on 23.05.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    

    private let tableView: UITableView = {
       let view = UITableView()
        view.backgroundColor = .none
        
        view.bounces = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    private let receptTableViewCell = ReceptTableViewCell()
    private let idReceptCell = "idReceptCell"
    
    private var recipeModel: ReceptModel?
    private var recipeArray = [Recipe]()
    
    private var filtredSearchResult = [Recipe]()
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
//        print(text)
        return text.isEmpty
    }
    private var isFiltering: Bool {
        searchController.isActive && !searchBarIsEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        setupViews()
        setContraints()
        setDelegates()
        getRecept()
        setupSearchBar()
        setupNavigationBar()
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    private func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func getRecept() {
        NetworkDataFetch.shared.fetchRecept { [weak self] recipe, error in
            guard let self = self else { return }
            if error != nil {
                print("Erorrrrrr")
            } else {
                guard let recipe = recipe else { return }
                self.recipeArray = recipe.recipes
                self.tableView.reloadData()
            }
        }
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showDetail" {
//            if let indexPath = tableView.indexPathForSelectedRow {
//                let model: Recipe
//                if isFiltering {
//                    model = filtredSearchResult[indexPath.row]
//                } else {
//                    model = recipeArray[indexPath.row]
//                }
//                let detailVC = segue.destination as! AboutReceptViewController
//                detailVC.recipeArray = recipeArray
//            }
//        }
//    }
    
    private func setupViews() {
        view.addSubview(tableView)
        tableView.register(ReceptTableViewCell.self, forCellReuseIdentifier: idReceptCell)
    }
    
//MARK: - SearchBar/NavigattionBar
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsSearchResultsController = true
        definesPresentationContext = true
    }
    
    private func setupNavigationBar() {
        let label = UILabel(text: "Рецептики", font: .robotoMedium16(), textColor: .black)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
    }
}

//MARK: - UISearchResultsUpdating

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filtredContentForSearchText(searchController.searchBar.text ?? "")
//        guard let text = searchController.searchBar.text else { return }
//        print(text)
    }
    
    private func filtredContentForSearchText(_ searchText: String) {
        filtredSearchResult = recipeArray.filter({ (recipeArray: Recipe) -> Bool in
            return recipeArray.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}

//MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
          return  filtredSearchResult.count
        }
        return recipeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: idReceptCell, for: indexPath) as? ReceptTableViewCell else {
            return UITableViewCell()
        }
//        let model = recipeArray[indexPath.row]
//        var model: Recipe
        let recipeModel = isFiltering ? filtredSearchResult[indexPath.row] : recipeArray[indexPath.row]
//        if isFiltering {
//            model = filtredSearchResult[indexPath.row]
//        } else {
//            model = recipeArray[indexPath.row]
//        }
        cell.receptConfigure(model: recipeModel)
        return cell
    }
}

//MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let characterModel = isFiltering ? filtredSearchResult[indexPath.row] : recipeArray[indexPath.row]
        let aboutReceptViewController = AboutReceptViewController()
        aboutReceptViewController.recipeArray = recipeArray
        aboutReceptViewController.recipeModel = characterModel
        
        navigationController?.pushViewController(aboutReceptViewController, animated: true)
        navigationItem.backButtonTitle = ""
//        aboutReceptViewController.modalPresentationStyle = .fullScreen
//        present(aboutReceptViewController, animated: true)
    }
}

//MARK: - setConstrains

extension MainViewController {
    
    private func setContraints() {
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
        
    }
}
