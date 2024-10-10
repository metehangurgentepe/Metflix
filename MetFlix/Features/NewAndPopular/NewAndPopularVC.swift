//
//  NewAndPopularVC.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 2.10.2024.
//

import UIKit
import SnapKit

class NewAndPopularVC: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: NewsAndPopularViewModelProtocol
    private let categoryController: CategoryController
    
    private var upcoming: [Movie] = []
    private var popularMovies: [Movie] = []
    private var top10Movies: [Movie] = []
    private var top10Series: [Series] = []
    
    // MARK: - UI Components
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.register(NewsAndPopularTableViewCell.self, forCellReuseIdentifier: NewsAndPopularTableViewCell.identifier)
        tv.delegate = self
        tv.dataSource = self
        tv.showsVerticalScrollIndicator = false
        return tv
    }()
    
    // MARK: - Lifecycle
    
    init(viewModel: NewsAndPopularViewModelProtocol = NewsAndPopularViewModel()) {
        self.viewModel = viewModel
        self.categoryController = CategoryController(
            collectionViewLayout: UICollectionViewFlowLayout(),
            categories: Section.allCases.map { $0.title },
            icons: Section.allCases.map { $0.image! }
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupNavBar()
        setupCategoryController()
        setupTableView()
    }
    
    private func setupNavBar() {
        let title = UILabel()
        title.text = "New & Popular"
        title.textColor = .white
        title.font = .preferredFont(forTextStyle: .headline).withSize(24)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: title)
        
        navigationItem.rightBarButtonItems = [
            createCustomButton(imageName: "magnifyingglass"),
            createCustomButton(imageName: "arrow.down.to.line"),
            createCustomButton(imageName: "shareplay")
        ]
    }
    
    private func setupCategoryController() {
        categoryController.delegate = self
        view.addSubview(categoryController.view)
        categoryController.view.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        categoryController.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(categoryController.view.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func setupBindings() {
        viewModel.delegate = self
    }
    
    private func loadData() {
        Task {
            await viewModel.load()
        }
    }
    
    // MARK: - Helper Methods
    
    private func createCustomButton(imageName: String) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: imageName), for: .normal)
        button.tintColor = .white
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }
    
    @objc private func buttonTapped() {
        let vc = SuggestedSearchViewController()
        vc.modalPresentationStyle = .overFullScreen
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: false)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension NewAndPopularVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section.allCases[section] {
        case .soon: return upcoming.count
        case .everyoneWatches: return popularMovies.count
        case .top10Movies: return top10Movies.count
        case .top10Series: return top10Series.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsAndPopularTableViewCell.identifier, for: indexPath) as? NewsAndPopularTableViewCell else {
            return UITableViewCell()
        }
        
        switch Section.allCases[indexPath.section] {
        case .soon:
            cell.configure(movie: upcoming[indexPath.row], index: nil, wide: false, upcoming: true, series: nil)
        case .everyoneWatches:
            cell.configure(movie: popularMovies[indexPath.row], index: nil, wide: true, upcoming: false, series: nil)
        case .top10Movies:
            cell.configure(movie: top10Movies[indexPath.row], index: indexPath.row, wide: false, upcoming: false, series: nil)
        case .top10Series:
            cell.configure(movie: nil, index: indexPath.row, wide: false, upcoming: false, series: top10Series[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionType = Section.allCases[section]
        return NewAndPopularHeader(title: sectionType.title, image: sectionType.image!)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Section.allCases[indexPath.section] == .soon ? 400 : 450
    }
}

// MARK: - UIScrollViewDelegate

extension NewAndPopularVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        handleParallaxEffect()
        updateCategorySelection()
        handleCellFading()
    }
    
    private func handleParallaxEffect() {
        let cellHeight: CGFloat = 400
        
        guard let visibleCells = tableView.visibleCells as? [NewsAndPopularTableViewCell],
              let firstVisibleIndexPath = tableView.indexPathsForVisibleRows?.first else { return }
        
        let currentSection = firstVisibleIndexPath.section
        var sectionYOffset: CGFloat = 0
        for section in 0..<currentSection {
            sectionYOffset += CGFloat(tableView.numberOfRows(inSection: section)) * cellHeight
        }
        
        let sectionOffsetY = tableView.contentOffset.y - sectionYOffset - 30
        let overallProgress = sectionOffsetY / cellHeight
        
        for cell in visibleCells {
            if let indexPath = tableView.indexPath(for: cell) {
                let rowIndex = indexPath.row
                let cellProgress = overallProgress - CGFloat(rowIndex)
                
                cell.updateDateLabelPosition(progress: max(0, min(cellProgress, 1)))
            }
        }
    }
    
    private func updateCategorySelection() {
        guard let firstVisibleIndexPath = tableView.indexPathsForVisibleRows?.first else { return }
        categoryController.collectionView.selectItem(at: IndexPath(item: firstVisibleIndexPath.section, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    
    private func handleCellFading() {
        let cellHeight: CGFloat = 400
        let fadeDistance: CGFloat = cellHeight / 2
        let tableViewOffset = tableView.contentOffset.y
        
        for case let cell as NewsAndPopularTableViewCell in tableView.visibleCells {
            guard let indexPath = tableView.indexPath(for: cell) else { continue }
            let cellFrame = tableView.rectForRow(at: indexPath)
            let cellOffsetY = cellFrame.origin.y - tableViewOffset
            
            if cellOffsetY < 0 {
                let progress = min(1, abs(cellOffsetY) / fadeDistance)
                cell.alpha = 1 - progress
            } else {
                cell.alpha = 1
            }
        }
    }
}

// MARK: - MenuControllerDelegate

extension NewAndPopularVC: MenuControllerDelegate {
    func didTapMenuItem(indexPath: IndexPath) {
        let targetIndexPath = IndexPath(row: 0, section: indexPath.item)
        if tableView.numberOfRows(inSection: targetIndexPath.section) > 0 {
            tableView.scrollToRow(at: targetIndexPath, at: .top, animated: true)
        }
    }
}

// MARK: - NewsAndPopularViewModelDelegate

extension NewAndPopularVC: NewsAndPopularViewModelDelegate {
    func handleOutput(_ output: NewsAndPopularViewModelOutput) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch output {
            case .error(let error):
                print("Error: \(error)")
            case .popularMovies(let movies):
                self.popularMovies = movies
                self.tableView.reloadSections(IndexSet(integer: Section.everyoneWatches.rawValue), with: .automatic)
            case .upcomingMovies(let upcoming):
                self.upcoming = upcoming
                self.tableView.reloadSections(IndexSet(integer: Section.soon.rawValue), with: .automatic)
            case .topRatedMovies(let topRated):
                self.top10Movies = topRated
                self.tableView.reloadSections(IndexSet(integer: Section.top10Movies.rawValue), with: .automatic)
            case .popularSeries(let top10Series):
                self.top10Series = top10Series
                self.tableView.reloadSections(IndexSet(integer: Section.top10Series.rawValue), with: .automatic)
            case .getMoviesBySearch, .setLoading, .selectMovie:
                break
            }
        }
    }
}

// MARK: - Section Enum

extension NewAndPopularVC {
    enum Section: Int, CaseIterable {
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
            case .top10Series, .top10Movies: return UIImage(named: "top-10")
            }
        }
    }
}
