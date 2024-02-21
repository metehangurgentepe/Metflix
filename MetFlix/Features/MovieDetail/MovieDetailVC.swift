//
//  MovieDetailViewController.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 26.01.2024.
//

import Foundation
import UIKit

protocol MovieDetailVCDelegate: AnyObject {
    func didTapInfoButton()
}

class MovieDetailVC: DataLoadingVC, UIScrollViewDelegate {
    
    let imageView: UIImageView = {
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
        let image = UIImage(named: "playButton")
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
    
    let similarMovieHeader = Header(title: "Similar Movies", action: UIAction(handler: { action in
        
    }))
    
    let infoButton = UIBarButtonItem()
    
    var movieId: Int!
    var movie: Movie?
    var similarMovies: MovieResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureScrollView()
        configureImageView()
        configureMovieInfoView()
        configureStarRatingView()
        configureOverviewLabel()
        configureHeader()
        configureCollectionView()
        configurePlayButton()
        configureInfoButton()
                
        Task {
            try await getMovieDetail()
            try await getSimilarMovies()
        }
    }
    
    init(id: Int) {
        super.init(nibName: nil, bundle:nil)
        self.movieId = id
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItems = [favButton, infoButton]
    }
    
    
    func configureHeader() {
        contentView.addSubview(similarMovieHeader)
        
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
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        contentView.addSubview(collectionView)
        
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
        
        contentView.snp.makeConstraints { make in
            make.height.equalTo(1000)
            make.width.equalTo(scrollView.snp.width)
            make.top.equalTo(scrollView.snp.top).offset(0)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.leading.equalTo(scrollView.snp.leading)
        }
    }
    
    
    func configureOverviewLabel() {
        contentView.addSubview(overviewLabel)
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(starRatingView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    
    func configureInfoButton() {
        infoButton.image = UIImage(named: "info.circle")
        infoButton.target = self
        infoButton.action = #selector(infoButtonTapped)
    }
    
    
    @objc func infoButtonTapped() {
        if let movie = movie {
            if let url = URL(string:movie.homepage ?? "") {
                presentSafariVC(with: url)
            }
            else {
                presentAlertOnMainThread(title: "Error", message: "Error Alert", buttonTitle: "Ok")
            }
        }
    }
    
    
    func configureFavButtonItem() {
        if let movie = movie {
            PersistenceManager.isSaved(favorite: movie) { [weak self] result in
                guard let self = self else { return }
                self.favButton.target = self
                switch result {
                case .success(let isSaved):
                    if isSaved {
                        self.favButton.image = UIImage(named: "heart.fill")
                        self.favButton.action = #selector(removeFavMovie)
                    } else {
                        self.favButton.image = UIImage(named: "heart")
                        self.favButton.action = #selector(addFavMovie)
                    }
                case .failure(let error):
                    self.presentAlertOnMainThread(title: "Error", message: error.rawValue, buttonTitle: "Ok")
                }
            }
        }
    }
    
    
    func configureImageView() {
        let width = view.frame.width
        
        let imageWidth = 780 / width
        
        let imageHeight = 438 / imageWidth
        
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.topMargin)
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(imageHeight)
        }
    }
    
    
    func configureMovieInfoView() {
        contentView.addSubview(movieInfoView)
                
        movieInfoView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(350)
        }
    }
    
    
    func configureStarRatingView() {
        contentView.addSubview(starRatingView)
        
        starRatingView.snp.makeConstraints { make in
            make.top.equalTo(movieInfoView.snp.bottom).offset(10)
            make.centerX.equalTo(movieInfoView.snp.centerX)
            make.height.equalTo(24)
            make.width.equalTo(150)
        }
    }
    
    
    func downloadImage() {
        if let movie = movie {
            NetworkManager.shared.downloadImage(from:(movie.backdropURL)) { [weak self] image in
                guard let self = self else { return }
                DispatchQueue.main.async{
                    if let image = image{
                        self.imageView.image = image
                    }
                }
            }
        }
    }
    
    
    @objc func removeFavMovie() {
        PersistenceManager.updateWith(favorite: movie!, actionType: .remove) { [weak self] (error: MetflixError?) in
            guard let self = self else { return }
            if let error = error {
                self.presentAlertOnMainThread(title: "Error", message: error.rawValue, buttonTitle: "Ok")
            } else {
                configureFavButtonItem()
            }
        }
    }
    
    
    @objc func addFavMovie() {
        PersistenceManager.updateWith(favorite: movie!, actionType: .add) { [weak self] (error: MetflixError?) in
            guard let self = self else { return }
            if let error = error {
                self.presentAlertOnMainThread(title: "Error", message: error.rawValue, buttonTitle: "Ok")
            } else {
                configureFavButtonItem()
            }
        }
    }
    
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    
    func getMovieDetail() async throws {
        showLoadingView()
        Task{
            do{
                self.movie = try await MovieStore.shared.fetchMovieDetail(id: movieId)
                downloadImage()
                movieInfoView.set(movie: movie!)
                starRatingView.rating = movie!.voteAverage
                title = movie!.title
                overviewLabel.text = movie!.overview
                configureFavButtonItem()
                dismissLoadingView()
            } catch {
                presentAlertOnMainThread(title: "Error", message: error.localizedDescription, buttonTitle: "Ok")
            }
        }
    }
    
    func getSimilarMovies() async throws {
        Task {
            self.similarMovies = try await MovieStore.shared.getSimilarMovies(id: movieId)
            collectionView.reloadData()
        }
    }
    
    @objc func didTapPlayButton() {
        Task{
            let video = try await MovieStore.shared.fetchMovieVideo(id: movieId).results
            let videoURLKey = video[0].key
            let url = URL(string:"https://youtube.com/watch?v=\(videoURLKey)")
            presentSafariVC(with: url!)
        }
    }
}

extension MovieDetailVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        similarMovies?.results.count ?? 20
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SimilarMovieCell.identifier, for: indexPath) as! SimilarMovieCell
        if let movieList = self.similarMovies{
            let movie = movieList.results[indexPath.row]
            cell.set(movie: movie)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movieList = self.similarMovies{
            let id = movieList.results[indexPath.row].id
            let destVC = MovieDetailVC(id: id)
            navigationController?.pushViewController(destVC, animated: true)
        }
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
