//
//  SuggestedSearchViewController.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 4.10.2024.
//

import UIKit

class SuggestedSearchViewController: UIViewController, HomeVCCarouselDelegate {
    var suggestedMovies: [Movie] = []
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    let searchBar = UISearchBar(frame: .zero)
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    let activity = UIActivityIndicatorView(style: .medium)
    
    let viewModel = SearchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavBar()
        configureLoading()
        configureTableView()
        
        viewModel.delegate = self
        Task{ await viewModel.load() }
    }
    
    private func configureNavBar() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        searchBar.delegate = self
        searchBar.tintColor = .white
        searchBar.searchTextField.leftView?.tintColor = .lightGray
        searchBar.placeholder = "Oyun, dizi veya film arayın."
        searchBar.layer.cornerRadius = 2
        
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Oyun, dizi veya film arayın.",
            attributes: [
                .foregroundColor: UIColor.lightGray,
                .font: UIFont.systemFont(ofSize: 12, weight: .light)
            ]
        )
        
        searchBar.searchTextField.font = UIFont.systemFont(ofSize: 12, weight: .light)
        
        let stackView = UIStackView(arrangedSubviews: [backButton, searchBar])
        stackView.spacing = 4
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(30)
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: false)
    }
    
    private func configureLoading() {
        activity.color = .white
        activity.hidesWhenStopped = true
        activity.isHidden = true
        
        view.addSubview(activity)
        
        activity.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func configureTableView() {
        tableView.register(SuggestedMovieCell.self, forCellReuseIdentifier: SuggestedMovieCell.identifier)
        tableView.register(HorizontalMobileTableViewCell.self, forCellReuseIdentifier: HorizontalMobileTableViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.trailing.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func didSelectMovie(movieId: Int) {
        
    }
}

extension SuggestedSearchViewController: SearchViewModelDelegate {
    func handleOutput(_ output: SearchViewModelOutput) {
        DispatchQueue.main.async {
            switch output {
            case .getMoviesBySearch(let array):
                break
            case .loadMovies(let array):
                self.suggestedMovies = array
                self.tableView.reloadData()
                
            case .setLoading(let isLoading):
                if isLoading{
                    self.activity.startAnimating()
                    self.activity.isHidden = false
                    self.tableView.isHidden = true
                } else {
                    self.activity.stopAnimating()
                    self.tableView.isHidden = false
                }
            case .selectMovie(let int):
                break
            case .error(let movieError):
                break
            }
        }
    }
}

extension SuggestedSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension SuggestedSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 160
        case 1:
            return 100
        default:
            return 0
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Önerilen Mobil Oyunlar"
        case 1:
            return "Önerilen Dizi ve Filmler"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return suggestedMovies.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: HorizontalMobileTableViewCell.identifier) as! HorizontalMobileTableViewCell
            cell.configure(movies: suggestedMovies, delegate: self)
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: SuggestedMovieCell.identifier, for: indexPath) as! SuggestedMovieCell
            cell.configure(movie: suggestedMovies[indexPath.row])
            return cell
            
        default:
            return UITableViewCell()
        }
        
        
    }
}
