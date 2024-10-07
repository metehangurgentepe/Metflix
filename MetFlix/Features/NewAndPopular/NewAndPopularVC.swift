//
//  NewAndPopularVC.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 2.10.2024.
//

import UIKit

class NewAndPopularVC: UIViewController, MenuControllerDelegate {
    var upcoming: [Movie] = []
    var popularMovies: [Movie] = []
    var top10Movies : [Movie] = []
    var top10Series: [Series] = []
    
    enum Section: CaseIterable {
        case soon
        case everyoneWatches
        case top10Movies
        case top10Series
        
        var title: String {
            switch self {
            case .soon: return "Çok Yakında"
            case .everyoneWatches: return "Herkes Bunları İzliyor"
            case .top10Series: return "Top 10 Dizi Listesi"
            case .top10Movies: return "Top 10 Film Listesi"
            }
        }
        
        var image: UIImage? {
            switch self {
            case .soon: return UIImage(named: "popcorn")
            case .everyoneWatches: return UIImage(named: "fire")
            case .top10Series: return UIImage(named: "top-10")
            case .top10Movies: return UIImage(named: "top-10")
            }
        }
    }
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    let viewModel = NewsAndPopularViewModel()
    let categoryController = CategoryController(collectionViewLayout: UICollectionViewFlowLayout(), categories: Section.allCases.map({$0.title}), icons: Section.allCases.map({$0.image!}))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        setupCategory()
        setupTableView()
        
        viewModel.delegate = self
        
        Task{
            await viewModel.load()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setupCategory() {
        let categoryView = categoryController.view!
        
        categoryController.delegate = self
        
        view.addSubview(categoryView)
        
        categoryView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        
        categoryController.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
    }
    
    func didTapMenuItem(indexPath: IndexPath) {
        tableView.layoutIfNeeded()
        
        let indexPath = IndexPath(row: 0, section: indexPath.item)
        
        if tableView.numberOfRows(inSection: indexPath.section) > 0 {
            tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        } else {
            print("Section'da satır yok.")
        }
    }
    
    
    private func configureNavBar() {
        view.backgroundColor = .systemBackground
        let title = UILabel()
        title.text = "New & Popular"
        title.textColor = .white
        title.font = .preferredFont(forTextStyle: .headline).withSize(24)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: title)
        
        let shareButton = createCustomButton(imageName: "shareplay")
        let downloadButton = createCustomButton(imageName: "arrow.down.to.line")
        let searchButton = createCustomButton(imageName: "magnifyingglass")
        
        navigationItem.rightBarButtonItems = [
            searchButton,
            downloadButton,
            shareButton
        ]
    }
    
    private func createCustomButton(imageName: String) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: imageName), for: .normal)
        button.tintColor = .white
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        return UIBarButtonItem(customView: button)
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        let vc = SuggestedSearchViewController()
        vc.modalPresentationStyle = .overFullScreen
        hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    private func setupTableView() {
        tableView.register(NewsAndPopularTableViewCell.self, forCellReuseIdentifier: NewsAndPopularTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.showsVerticalScrollIndicator = false
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(categoryController.view.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cellHeight: CGFloat = 400
        let dateLabelHeight: CGFloat = 40
        
        guard let firstVisibleIndexPath = tableView.indexPathsForVisibleRows?.first else { return }
        let currentSection = firstVisibleIndexPath.section
        
        let numberOfRowsInSection = tableView.numberOfRows(inSection: currentSection)
        
        var sectionYOffset: CGFloat = 0
        for section in 0..<currentSection {
            sectionYOffset += CGFloat(tableView.numberOfRows(inSection: section)) * cellHeight
        }
        
        let sectionOffsetY = scrollView.contentOffset.y - sectionYOffset - 30
        let overallProgress = sectionOffsetY / cellHeight
        
        
        let visibleCells = tableView.visibleCells as! [NewsAndPopularTableViewCell]
        
        for cell in visibleCells {
            if let indexPath = tableView.indexPath(for: cell) {
                let rowIndex = indexPath.row
                let cellProgress = overallProgress - CGFloat(rowIndex)
                
                if cellProgress >= 0 && cellProgress <= 1 {
                    cell.updateDateLabelPosition(progress: cellProgress)
                } else if cellProgress > 1 {
                    cell.updateDateLabelPosition(progress: 1)
                } else {
                    cell.updateDateLabelPosition(progress: 0)
                }
            }
        }
        
        categoryController.collectionView.selectItem(at: IndexPath(item: currentSection, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        
        let tableViewOffset = scrollView.contentOffset.y
        
        for cell in visibleCells {
            if let indexPath = tableView.indexPath(for: cell) {
                let cellFrame = tableView.rectForRow(at: indexPath)
                let cellOffsetY = cellFrame.origin.y - tableViewOffset
                
                let fadeDistance: CGFloat = cellHeight / 1
                
                if cellOffsetY < 0 {
                    let progress = min(1, abs(cellOffsetY) / fadeDistance)
                    cell.alpha = 1 - progress
                } else {
                    cell.alpha = 1
                }
            }
        }
    }
}

extension NewAndPopularVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 400
        default:
            return 450
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = "\(Section.allCases[section].title)"
        let image = Section.allCases[section].image!
        return NewAndPopularHeader(title: title,image: image)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return upcoming.count
            
        case 1:
            return popularMovies.count
            
        case 2:
            return top10Movies.count
            
        case 3:
            return top10Series.count
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsAndPopularTableViewCell.identifier) as! NewsAndPopularTableViewCell
            cell.configure(movie: upcoming[indexPath.row], index: nil, wide: false, upcoming: true, series: nil)
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsAndPopularTableViewCell.identifier) as! NewsAndPopularTableViewCell
            cell.configure(movie: popularMovies[indexPath.row], index: nil, wide: true, upcoming: false, series: nil)
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsAndPopularTableViewCell.identifier) as! NewsAndPopularTableViewCell
            cell.configure(movie: top10Movies[indexPath.row], index: indexPath.row, wide: false, upcoming: false, series: nil)
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsAndPopularTableViewCell.identifier) as! NewsAndPopularTableViewCell
            cell.configure(movie: nil, index: indexPath.row, wide: false, upcoming: false, series: top10Series[indexPath.row])
            return cell
            
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

extension NewAndPopularVC: NewsAndPopularViewModelDelegate{
    func handleOutput(_ output: NewsAndPopularViewModelOutput) {
        DispatchQueue.main.async{
            switch output {
            case .error(let error):
                print(error)
            case .popularMovies(let movies):
                self.popularMovies = movies
                self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
                self.tableView.reloadData()
                
            case .getMoviesBySearch(_):
                break
                
            case .setLoading(_):
                break
                
            case .selectMovie(_):
                break
                
            case .upcomingMovies(let upcoming):
                self.upcoming = upcoming
                self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                
            case .topRatedMovies(let topRated):
                self.top10Movies = topRated
                self.tableView.reloadSections(IndexSet(integer: 2), with: .automatic)
                
            case .popularSeries(let top10Series):
                self.top10Series = top10Series
                self.tableView.reloadSections(IndexSet(integer: 3), with: .automatic)
            }
        }
    }
}
