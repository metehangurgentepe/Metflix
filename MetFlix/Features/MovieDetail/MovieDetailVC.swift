//
//  MovieDetailViewController.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 26.01.2024.
//

import Foundation
import UIKit

class MovieDetailVC: DataLoadingVC, UIScrollViewDelegate {
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    let movieInfoView = MovieInfoView()
    let starRatingView = StarRatingView()
    let favButton = UIBarButtonItem()
    let overviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .subheadline)
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
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SimilarMovieCell.self, forCellWithReuseIdentifier: SimilarMovieCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    lazy var similarMovieHeader: Header = {
        let header = Header(title: "Similar Movies", action: UIAction(handler: { [weak self] action in
            self?.goToSeeAllScreen()
        }))
        return header
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    
    let infoButton = UIBarButtonItem()
    
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
        
        configureScrollView()
        configureStackView()
        configureImageView()
        configureMovieInfoView()
        configureStarRatingView()
        configureOverviewLabel()
        configureHeader()
        configureCollectionView()
        configurePlayButton()
        configureInfoButton()
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
        navigationItem.rightBarButtonItems = [favButton, infoButton]
    }
    
    func configureStackView() {
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(movieInfoView)
        stackView.addArrangedSubview(starRatingView)
        stackView.addArrangedSubview(overviewLabel)
        stackView.addArrangedSubview(similarMovieHeader)
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
    
    
    func configureHeader() {
        similarMovieHeader.snp.makeConstraints { make in
            make.top.equalTo(overviewLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(25)
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
    
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(similarMovieHeader.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(380)
        }
    }
    
    
    func configureScrollView() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        
        scrollView.delegate = self
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    func configureOverviewLabel() {
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(starRatingView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    
    func configureInfoButton() {
        infoButton.image = Images.infoButton
        infoButton.target = self
        infoButton.action = #selector(infoButtonTapped)
    }
    
    
    @objc func infoButtonTapped() {
        viewModel?.infoButtonTapped()
    }
    
    
    func configureFavButtonItem() {
        self.favButton.target = self
        viewModel?.checkMovieIsSaved()
    }
    
    
    func configureImageView() {
        let width = view.frame.width
        
        let imageWidth = 780 / width
        
        let imageHeight = 438 / imageWidth
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(imageHeight)
        }
    }
    
    
    func configureMovieInfoView() {
        movieInfoView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(350)
        }
    }
    
    
    func configureStarRatingView() {
        starRatingView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(24)
            make.width.equalTo(150)
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
        return CGSize(width: 235, height: 350)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
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
                starRatingView.rating = movie.voteAverage
                title = movie.title
                overviewLabel.text = movie.overview
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

