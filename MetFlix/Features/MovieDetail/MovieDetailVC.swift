//
//  NewMovieDetailVC.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 10.10.2024.
//

import Foundation

import UIKit

protocol MovieDetailControllerDelegate: AnyObject {
    func dismissBlurView()
}

class MovieDetailVC: DataLoadingVC {
    
    // MARK: - Properties
    private enum Section { case main }
    private let movieId: Int
    private var movie: Movie?
    private var similarMovies = [Movie]()
    private var showMovies = [Movie]()
    private var recommendedMovies = [Movie]()
    private let viewModel: MovieDetailViewModel
    weak var delegate: MovieDetailControllerDelegate?
    
    private let currentUserId = UserSession.shared.userId
    private var originalCenter: CGPoint = .zero
    private let threshold: CGFloat = 100
    
    // MARK: - UI Components
    private lazy var imageView = UIImageView()
    private let movieInfoView = MovieInfoView()
    private let favButton = UIBarButtonItem()
    private let overviewLabel = UILabel()
    private let playButton = UIButton()
    let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    private let buttonStackView = UIStackView()
    private let horizontalButtonStackView = UIStackView()
    private let castLabel = UILabel()
    private let directorsLabel = UILabel()
    private let xButton = UIButton()
    private let shareButton = UIButton()
    private let listButton = VerticalButton(frame: .zero)
    private let givePointButton = VerticalButton(frame: .zero)
    private let recommendButton = VerticalButton(frame: .zero)
    private let menuController: MenuDetailController
    private lazy var menuView: UIView = { menuController.view }()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Movie>!
    private let collectionView: UICollectionView!
    
    private let horizontalPlayButton = UIButton()
    private let horizontalDownloadButton = UIButton()
    private let popoverView = UIView()
    private let overlayView = UIView()
    private let likeButton = VerticalButton(frame: .zero)
    private let dislikeButton = VerticalButton(frame: .zero)
    
    // MARK: - Initialization
    init(id: Int) {
        self.movieId = id
        self.viewModel = MovieDetailViewModel(id: id)
        self.menuController = MenuDetailController(collectionViewLayout: UICollectionViewFlowLayout())
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        super.init(nibName: nil, bundle: nil)
        
        self.collectionView.setCollectionViewLayout(self.createFlowLayout(), animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupUI()
        loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.dismissBlurView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        menuController.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
    }
    
    // MARK: - Setup
    private func setupViewModel() {
        viewModel.delegate = self
    }
    
    private func setupUI() {
        configureViewController()
        configureImageView()
        configureScrollView()
        configureXButton()
        configureStackView()
        configureMovieInfoView()
        configureButtonStackView()
        configureOverviewLabel()
        configureCastAndDirectorsLabels()
        configureHorizontalButtonStackView()
        configureMenuController()
        configureCollectionView()
        configurePlayButton()
        configureDataSource()
        setupPanGesture()
        setupPopover()
    }
    
    private func loadData() {
        Task {
            await viewModel.load()
            await viewModel.getSimilarMovies()
            await viewModel.getRecommendedMovies()
        }
    }
    
    // MARK: - UI Configuration
    private func configureViewController() {
        tabBarController?.tabBar.isHidden = true
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThickMaterialDark))
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.alpha = 0.8
        view.addSubview(blurView)
    }
    
    private func configureImageView() {
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.snp.width).multipliedBy(9.0/16.0)
        }
    }
    
    private func configureXButton() {
        xButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        xButton.tintColor = .white
        xButton.backgroundColor = .black
        xButton.layer.cornerRadius = 13
        xButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        shareButton.setImage(UIImage(systemName: "shareplay"), for: .normal)
        shareButton.tintColor = .white
        shareButton.backgroundColor = .black
        shareButton.layer.cornerRadius = 13
        
        view.addSubviews(xButton, shareButton)
        
        xButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.height.width.equalTo(26)
            make.top.equalTo(imageView.snp.top).inset(10)
        }
        
        shareButton.snp.makeConstraints { make in
            make.trailing.equalTo(xButton.snp.leading).offset(-4)
            make.height.width.equalTo(26)
            make.top.equalTo(imageView.snp.top).inset(10)
        }
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureStackView() {
        scrollView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        [movieInfoView, buttonStackView, overviewLabel, castLabel, directorsLabel,
         horizontalButtonStackView, menuView, collectionView].forEach { stackView.addArrangedSubview($0) }
    }
    
    private func configureMovieInfoView() {
        movieInfoView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.top).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.height.equalTo(50)
            make.width.equalTo(350)
        }
    }
    
    private func configureButtonStackView() {
        buttonStackView.axis = .vertical
        buttonStackView.alignment = .center
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 4
        
        buttonStackView.addArrangedSubview(horizontalPlayButton)
        buttonStackView.addArrangedSubview(horizontalDownloadButton)
        
        configureHorizontalPlayButton()
        configureHorizontalDownloadButton()
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(movieInfoView.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(70)
        }
    }
    
    private func configureHorizontalPlayButton() {
        horizontalPlayButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        horizontalPlayButton.setTitle("Play", for: .normal)
        horizontalPlayButton.setTitleColor(.black, for: .normal)
        horizontalPlayButton.backgroundColor = .white
        horizontalPlayButton.tintColor = .black
        horizontalPlayButton.layer.cornerRadius = 4
        
        horizontalPlayButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func configureHorizontalDownloadButton() {
        horizontalDownloadButton.setImage(UIImage(systemName: "arrow.down.to.line"), for: .normal)
        horizontalDownloadButton.setTitle("Download", for: .normal)
        horizontalDownloadButton.setTitleColor(.white, for: .normal)
        horizontalDownloadButton.backgroundColor = .gray
        horizontalDownloadButton.tintColor = .white
        horizontalDownloadButton.layer.cornerRadius = 4
        
        horizontalDownloadButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func configureOverviewLabel() {
        overviewLabel.textColor = .label
        overviewLabel.font = .preferredFont(forTextStyle: .body).withSize(14)
        overviewLabel.numberOfLines = 14
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
        }
    }
    
    private func configureCastAndDirectorsLabels() {
        [castLabel, directorsLabel].forEach {
            $0.font = .systemFont(ofSize: 10, weight: .semibold)
            $0.textColor = .lightGray
        }
        
        castLabel.text = "Cast: "
        castLabel.numberOfLines = 2
        
        directorsLabel.text = "Directors: "
        
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
    
    private func configureHorizontalButtonStackView() {
        horizontalButtonStackView.distribution = .fillEqually
        horizontalButtonStackView.alignment = .fill
        
        configureListButton()
        configureGivePointButton()
        configureRecommendButton()
        
        [listButton, givePointButton, recommendButton].forEach { horizontalButtonStackView.addArrangedSubview($0) }
        
        horizontalButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(directorsLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(100)
            make.height.equalTo(40)
        }
    }
    
    private func configureListButton() {
        listButton.verticalImage = UIImage(systemName: "plus")
        listButton.verticalTitle = "My List"
        listButton.addTarget(self, action: #selector(listButtonTapped), for: .touchUpInside)
    }
    
    private func configureGivePointButton() {
        givePointButton.verticalImage = UIImage(systemName: "hand.thumbsup")
        givePointButton.verticalTitle = "Rate this"
        givePointButton.addTarget(self, action: #selector(giveRateTapped), for: .touchUpInside)
    }
    
    private func configureRecommendButton() {
        recommendButton.verticalImage = UIImage(systemName: "paperplane")
        recommendButton.verticalTitle = "Recommend"
    }
    
    private func configureMenuController() {
        menuController.delegate = self
        
        menuView.snp.makeConstraints { make in
            make.top.equalTo(horizontalButtonStackView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(40)
        }
        
        menuController.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(SimilarMovieCell.self, forCellWithReuseIdentifier: SimilarMovieCell.identifier)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(menuController.view.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(300)
        }
    }
    
    private func configurePlayButton() {
        playButton.setImage(Images.playButton, for: .normal)
        playButton.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
        
        view.addSubview(playButton)
        
        playButton.snp.makeConstraints { make in
            make.centerX.equalTo(imageView.snp.centerX)
            make.centerY.equalTo(imageView.snp.centerY)
            make.width.height.equalTo(50)
        }
    }
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, _ in
            guard let self = self else { return nil }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SimilarMovieCell.identifier, for: indexPath) as! SimilarMovieCell
            let movie = self.showMovies[indexPath.item]
            cell.set(movie: movie)
            return cell
        }
    }
    
    private func createFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        
        let itemsPerRow: CGFloat = 3
        let spacing: CGFloat = 10
        let availableWidth = ScreenSize.width - (spacing * (itemsPerRow + 1))
        let itemWidth = availableWidth / itemsPerRow
        
        layout.itemSize = CGSize(width: itemWidth, height: 150)
        return layout
    }
    
    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    private func setupPopover() {
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        overlayView.isHidden = true
        view.addSubview(overlayView)
        
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        popoverView.backgroundColor = .customDarkGray
        popoverView.layer.cornerRadius = 40
        popoverView.isHidden = true
        
        configureLikeDislikeButtons()
        
        let buttonStackView = UIStackView(arrangedSubviews: [dislikeButton, likeButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 10
        popoverView.addSubview(buttonStackView)
        
        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(200)
        }
        
        view.addSubview(popoverView)
        
        popoverView.snp.makeConstraints { make in
            make.centerX.equalTo(givePointButton.snp.centerX)
            make.bottom.equalTo(givePointButton.snp.top).offset(-10)
            make.width.equalTo(280)
            make.height.equalTo(100)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hidePopover))
        overlayView.addGestureRecognizer(tapGesture)
    }
    
    private func configureLikeDislikeButtons() {
        guard let movieId = movie?.id, let userId = currentUserId else { return }
        
        let isLiked = viewModel.checkIsLiked(userId: userId, movieId: movieId)
        let isDisliked = viewModel.checkIsDisliked(userId: userId, movieId: movieId)
        
        dislikeButton.verticalImage = isDisliked ? UIImage(systemName: "hand.thumbsdown.fill") : UIImage(systemName: "hand.thumbsdown")
        dislikeButton.verticalTitle = "I don't like this movie."
        dislikeButton.addTarget(self, action: #selector(dislikeMovie), for: .touchUpInside)
        
        likeButton.verticalImage = isLiked ? UIImage(systemName: "hand.thumbsup.fill") : UIImage(systemName: "hand.thumbsup")
        likeButton.verticalTitle = "I liked this movie."
        likeButton.addTarget(self, action: #selector(likeMovie), for: .touchUpInside)
    }
    
    // MARK: - Helper Methods
    
    private func updatedData(on movies: [Movie]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        snapshot.appendSections([.main])
        snapshot.appendItems(movies)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
        calculateHeight(arr: movies)
    }
    
    private func calculateHeight(arr: [Movie]) {
        let itemsPerRow: CGFloat = 3
        let spacing: CGFloat = 10
        let itemHeight: CGFloat = 150
        
        let rowCount = ceil(CGFloat(arr.count) / itemsPerRow)
        let totalSpacing = spacing * (rowCount - 1)
        let height = rowCount * itemHeight + totalSpacing + 20
        
        collectionView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
        
        stackView.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: stackView.frame.height)
    }
    
    // MARK: - Actions
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .began:
            originalCenter = view.center
        case .changed:
            view.center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y + translation.y)
        case .ended:
            let velocity = gesture.velocity(in: view)
            let shouldDismiss = abs(translation.x) > threshold || abs(translation.y) > threshold || abs(velocity.x) > 500 || abs(velocity.y) > 500
            
            if shouldDismiss {
                let directionX: CGFloat = translation.x > 0 ? 1 : -1
                let directionY: CGFloat = translation.y > 0 ? 1 : -1
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.center = CGPoint(x: self.originalCenter.x + directionX * self.view.bounds.width, y: self.originalCenter.y + directionY * self.view.bounds.height)
                }) { _ in
                    self.dismiss(animated: false)
                    self.delegate?.dismissBlurView()
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.center = self.originalCenter
                }
            }
        default:
            break
        }
    }
    
    @objc private func listButtonTapped() {
        guard let id = movie?.id, let userId = currentUserId else { return }
        
        listButton.animatedRotation()
        
        viewModel.addList(movieId: id, userId: userId)
    }
    
    @objc private func giveRateTapped() {
        configureLikeDislikeButtons()
        
        popoverView.isHidden.toggle()
        overlayView.isHidden = popoverView.isHidden
        
        if !popoverView.isHidden {
            UIView.animate(withDuration: 0.3) {
                self.popoverView.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.popoverView.alpha = 0
            }
        }
    }
    
    @objc private func likeMovie() {
        guard let currentUserId = currentUserId, let id = movie?.id else { return }
        
        let isLiked = viewModel.checkIsLiked(userId: currentUserId, movieId: id)
        
        if isLiked {
            viewModel.removeFavMovie(userId: currentUserId, movieId: id)
        } else {
            viewModel.addFavMovie(userId: currentUserId, movieId: id)
        }
        
        configureLikeDislikeButtons()
        hidePopover()
    }
    
    @objc private func dislikeMovie() {
        guard let currentUserId = currentUserId, let id = movie?.id else { return }
        
        let isDisliked = viewModel.checkIsDisliked(userId: currentUserId, movieId: id)
        
        if isDisliked {
//            viewModel.removeDislikedMovie(userId: currentUserId, movieId: id)
        } else {
//            viewModel.addDislikedMovie(userId: currentUserId, movieId: id)
        }
        
        configureLikeDislikeButtons()
        hidePopover()
    }
    
    @objc private func hidePopover() {
        overlayView.isHidden = true
        popoverView.isHidden = true
    }
    
    @objc private func didTapPlayButton() {
        Task {
            await viewModel.fetchMovieVideo()
        }
    }
    
    @objc private func dismissView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.delegate?.dismissBlurView()
        }) { _ in
            self.dismiss(animated: true)
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
//extension MovieDetailVC: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let id = showMovies[indexPath.row].id
//        let destVC = MovieDetailVC(id: id)
//        navigationController?.pushViewController(destVC, animated: true)
//    }
//}

// MARK: - UICollectionViewDelegateFlowLayout
extension MovieDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (ScreenSize.width / 3) - 20, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - MovieDetailViewModelDelegate
extension MovieDetailVC: MovieDetailViewModelDelegate {
    func handleOutput(_ output: MovieDetailViewModelOutput) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch output {
            case .getDetail(let movie):
                self.updateUIWithMovieDetails(movie)
            case .setLoading(let isLoading):
                isLoading ? self.showLoadingView() : self.dismissLoadingView()
            case .error(let error):
                self.presentAlertOnMainThread(title: "Error", message: error.localizedDescription, buttonTitle: "Ok")
            case .downloadImage(let image):
                self.imageView.image = image
            case .getSimilarMovie(let movies):
                self.similarMovies = movies
                self.showMovies = movies
                self.updatedData(on: self.similarMovies)
            case .didTapPlayButton(let videoURL):
                self.presentSafariVC(with: videoURL)
            case .addFavMovie, .removeFavMovie:
                break
            case .infoButtonTapped(let url):
                self.presentSafariVC(with: url)
            case .configureFavButton(let image, let action):
                self.favButton.image = image
                self.favButton.action = action
            case .getRecommendedMovies(let movies):
                self.recommendedMovies = movies
            }
        }
    }
    
    private func updateUIWithMovieDetails(_ movie: Movie) {
        self.movie = movie
        movieInfoView.set(movie: movie)
        title = movie.title
        overviewLabel.text = movie.overview
        castLabel.text = "Cast Crew: " + (movie.cast?.map({ $0.name }).joined(separator: ", ") ?? "")
        directorsLabel.text = "Director: " + (movie.directors?.map({ $0.name }).joined(separator: ", ") ?? "")
        
        listButton.verticalImage = (viewModel.isInMyList(movieId: movie.id, userId: currentUserId ?? "")) ? UIImage(systemName: "checkmark") : UIImage(systemName: "plus")
    }
}

// MARK: - MenuDetailControllerDelegate
extension MovieDetailVC: MenuDetailControllerDelegate {
    func didTapMenuItem(indexPath: IndexPath) {
        if indexPath.item == 0 {
            showMovies = self.similarMovies
        } else if indexPath.item == 1 {
            showMovies = self.recommendedMovies
        }
        updatedData(on: showMovies)
    }
}
