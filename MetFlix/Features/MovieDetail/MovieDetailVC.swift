//
//  MovieDetailViewController.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 26.01.2024.
//

import Foundation
import UIKit

class MovieDetailVC: DataLoadingVC, UIScrollViewDelegate, MenuDetailControllerDelegate {
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    let movieInfoView = MovieInfoView()
    let favButton = UIBarButtonItem()
    let overviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .body).withSize(14)
        label.numberOfLines = 14
        return label
    }()
    
    let playButton: UIButton = {
        let button = UIButton()
        let image = Images.playButton
        button.setImage(image, for: .normal)
        return button
    }()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(SimilarMovieCell.self, forCellWithReuseIdentifier: SimilarMovieCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    let horizontalPlayButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.fill")
        button.setImage(image, for: .normal)
        
        button.setTitle("Play", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.tintColor = .black
        button.layer.cornerRadius = 4
        
        return button
    }()
    
    let horizontalDownloadButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "arrow.down.to.line")
        button.setImage(image, for: .normal)
        
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray
        button.tintColor = .white
        button.layer.cornerRadius = 4
        
        return button
    }()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        return stackView
    }()
    
    let castLabel: UILabel = {
        let label = UILabel()
        label.text = "Cast: "
        label.font = .systemFont(ofSize: 10, weight: .semibold)
        label.textColor = .lightGray
        label.numberOfLines = 2
        return label
    }()
    
    let directorsLabel: UILabel = {
        let label = UILabel()
        label.text = "Directors: "
        label.font = .systemFont(ofSize: 10, weight: .semibold)
        label.textColor = .lightGray
        return label
    }()
    
    let listButton = VerticalButton(frame: .zero)
    let givePointButton = VerticalButton(frame: .zero)
    let recommendButton = VerticalButton(frame: .zero)
    let menuController = MenuDetailController(collectionViewLayout: UICollectionViewFlowLayout())    
    let horizontalButtonStackView = UIStackView()
    
    var movieId: Int!
    var movie: Movie?
    var similarMovies = [Movie]()
    var viewModel: MovieDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        
        viewModel?.delegate = self
        viewModel?.load()
        viewModel?.getSimilarMovies()
        setupMenuController()
        
        configureImageView()
        configureScrollView()
        configureStackView()
        configureMovieInfoView()
        configureButtonStackView()
        configureOverviewLabel()
        configureCastAndDirectorsLabels()
        configureHorizontalButtonStackView()
        configureMenuController()
        configureCollectionView()
        configurePlayButton()
    }
    
    init(id: Int) {
        super.init(nibName: nil, bundle:nil)
        self.movieId = id
        self.viewModel = MovieDetailViewModel(id: id)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItems = [favButton]
    }
    
    func configureImageView() {
        let width = view.frame.width
        let imageWidth = 780 / width
        let imageHeight = 438 / imageWidth
        
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(imageHeight)
        }
    }
    
    func configureButtonStackView() {
        buttonStackView.addArrangedSubview(horizontalPlayButton)
        buttonStackView.addArrangedSubview(horizontalDownloadButton)
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(movieInfoView.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(70)
        }
        
        horizontalPlayButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        
        horizontalDownloadButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func configureHorizontalButtonStackView() {
        listButton.verticalImage = UIImage(systemName: "plus")
        listButton.verticalTitle = "My List"
        
        givePointButton.verticalImage = UIImage(systemName: "hand.thumbsup")
        givePointButton.verticalTitle = "Rate this"
        
        recommendButton.verticalImage = UIImage(systemName: "paperplane")
        recommendButton.verticalTitle = "Recommend"
        
        horizontalButtonStackView.addArrangedSubview(listButton)
        horizontalButtonStackView.addArrangedSubview(givePointButton)
        horizontalButtonStackView.addArrangedSubview(recommendButton)
        
        horizontalButtonStackView.distribution = .fillEqually
        horizontalButtonStackView.alignment = .leading
        
        horizontalButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(directorsLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(100)
            make.height.equalTo(40)
        }
    }
    
    func configureCastAndDirectorsLabels() {
        castLabel.snp.makeConstraints { make in
            make.top.equalTo(overviewLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(40)
        }
        
        directorsLabel.snp.makeConstraints { make in
            make.top.equalTo(castLabel.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(30)
        }
    }
    
    func configureStackView() {
        stackView.addArrangedSubview(movieInfoView)
        stackView.addArrangedSubview(buttonStackView)
        stackView.addArrangedSubview(overviewLabel)
        stackView.addArrangedSubview(castLabel)
        stackView.addArrangedSubview(directorsLabel)
        stackView.addArrangedSubview(horizontalButtonStackView)
        stackView.addArrangedSubview(menuController.view)
        stackView.addArrangedSubview(collectionView)
        
        scrollView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.top.equalTo(scrollView.snp.top)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.leading.equalTo(scrollView.snp.leading)
        }
    }
    
    func configurePlayButton() {
        playButton.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
        
        view.addSubview(playButton)
        
        playButton.snp.makeConstraints { make in
            make.centerX.equalTo(imageView.snp.centerX)
            make.centerY.equalTo(imageView.snp.centerY)
        }
    }
    
    func goToSeeAllScreen() {
        let destVC = SeeAllVC(endpoint: .similar, type: "Similar Movies", id: movieId)
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func configureMenuController() {
        let menuView = menuController.view!
        
        menuView.snp.makeConstraints { make in
            make.top.equalTo(horizontalButtonStackView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(40)
        }
    }
    
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(menuController.view.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(380)
        }
    }
    
    func setupMenuController() {
        menuController.delegate = self
        
        menuController.collectionView.selectItem(at: [0,0], animated: true, scrollPosition: .centeredHorizontally)
    }
    
    
    func configureScrollView() {
        view.addSubview(scrollView)
        
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        
        scrollView.delegate = self
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    
    func configureOverviewLabel() {
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
        }
    }
    
    
    @objc func infoButtonTapped() {
        viewModel?.infoButtonTapped()
    }
    
    
    func configureFavButtonItem() {
        self.favButton.target = self
        viewModel?.checkMovieIsSaved()
    }
    
    
    func configureMovieInfoView() {
        movieInfoView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.top).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(350)
        }
    }
    
    func didTapMenuItem(indexPath: IndexPath) {
        guard let selectedCell = collectionView.cellForItem(at: indexPath) else { return }

        let cellFrame = selectedCell.frame

        UIView.animate(withDuration: 0.3) {
//            self.menuController.menuBar.frame = CGRect(x: cellFrame.origin.x, y: self.menuBar.frame.origin.y, width: cellFrame.width, height: self.menuBar.frame.height)
        }
    }

    
    @objc func removeFavMovie() {
        viewModel?.removeFavMovie()
    }
    
    
    @objc func addFavMovie() {
        viewModel?.addFavMovie()
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    
    @objc func didTapPlayButton() {
        viewModel?.fetchMovieVideo()
    }
}

extension MovieDetailVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        similarMovies.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SimilarMovieCell.identifier, for: indexPath) as! SimilarMovieCell
        let movie = similarMovies[indexPath.row]
        cell.set(movie: movie)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = similarMovies[indexPath.row].id
        let destVC = MovieDetailVC(id: id)
        navigationController?.pushViewController(destVC, animated: true)
    }
}


extension MovieDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (ScreenSize.width / 3) - 20, height: 100)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


extension MovieDetailVC: MovieDetailViewModelDelegate{
    func handleOutput(_ output: MovieDetailViewModelOutput) {
        DispatchQueue.main.async{ [weak self] in
            guard let self = self else { return }
            switch output {
            case .getDetail(let movie):
                self.movie = movie
                movieInfoView.set(movie: movie)
                title = movie.title
                overviewLabel.text = movie.overview
                castLabel.text = "Cast Crew: " + (movie.cast?.map({ $0.name }).joined(separator: ", ") ?? "")
                directorsLabel.text = "Director: " + (movie.directors?.map({ $0.name }).joined(separator: ", ") ?? "")
                configureFavButtonItem()
                
            case .setLoading(let bool):
                switch bool {
                case true:
                    showLoadingView()
                case false:
                    dismissLoadingView()
                }
                
            case .error(let error):
                presentAlertOnMainThread(title: "Error", message: error.localizedDescription, buttonTitle: "Ok")
                
            case .downloadImage(let image):
                self.imageView.image = image
                
            case .getSimilarMovie(let movies):
                self.similarMovies = movies
                self.collectionView.reloadData()
                self.collectionView.snp.updateConstraints { make in
                    make.height.equalTo(self.similarMovies.count * 100 / 3 + 150)
                }
                
            case .didTapPlayButton(let videoURL):
                presentSafariVC(with: videoURL)
                
                
            case .addFavMovie:
                configureFavButtonItem()
                
            case .removeFavMovie:
                configureFavButtonItem()
                
            case .infoButtonTapped(let url):
                presentSafariVC(with: url)
                
            case .configureFavButton(let image, let action):
                favButton.action = action
                favButton.image = image
            }
        }
    }
}

