////
////  MovieDetailViewController.swift
////  MetFlix
////
////  Created by Metehan Gürgentepe on 26.01.2024.
////
//
//
//import Foundation
//import UIKit
//
//protocol MovieDetailControllerDelegate: AnyObject {
//    func dismissBlurView()
//}
//
//class MovieDetailVC: DataLoadingVC, UIScrollViewDelegate, MenuDetailControllerDelegate {
//
//    enum Section {
//        case main
//    }
//
//    var imageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.layer.cornerRadius = 12
//        return imageView
//    }()
//
//    let movieInfoView = MovieInfoView()
//    let favButton = UIBarButtonItem()
//    let overviewLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .label
//        label.font = .preferredFont(forTextStyle: .body).withSize(14)
//        label.numberOfLines = 14
//        return label
//    }()
//
//    let playButton: UIButton = {
//        let button = UIButton()
//        let image = Images.playButton
//        button.setImage(image, for: .normal)
//        return button
//    }()
//
//    let scrollView = UIScrollView()
//    let contentView = UIView()
//    let stackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.alignment = .center
//        stackView.distribution = .fill
//        stackView.spacing = 10
//        return stackView
//    }()
//    private let popoverView = UIView()
//    private let overlayView = UIView()
//
//    let horizontalPlayButton: UIButton = {
//        let button = UIButton()
//        let image = UIImage(systemName: "play.fill")
//        button.setImage(image, for: .normal)
//
//        button.setTitle("Play", for: .normal)
//        button.setTitleColor(.black, for: .normal)
//        button.backgroundColor = .white
//        button.tintColor = .black
//        button.layer.cornerRadius = 4
//
//        return button
//    }()
//
//    let horizontalDownloadButton: UIButton = {
//        let button = UIButton()
//        let image = UIImage(systemName: "arrow.down.to.line")
//        button.setImage(image, for: .normal)
//
//        button.setTitle("Download", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.backgroundColor = .gray
//        button.tintColor = .white
//        button.layer.cornerRadius = 4
//
//        return button
//    }()
//
//    let buttonStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.alignment = .center
//        stackView.distribution = .fillEqually
//        stackView.spacing = 4
//        return stackView
//    }()
//
//    let castLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Cast: "
//        label.font = .systemFont(ofSize: 10, weight: .semibold)
//        label.textColor = .lightGray
//        label.numberOfLines = 2
//        return label
//    }()
//
//    let directorsLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Directors: "
//        label.font = .systemFont(ofSize: 10, weight: .semibold)
//        label.textColor = .lightGray
//        return label
//    }()
//
//    let xButton: UIButton = {
//        let button = UIButton()
//        let image = UIImage(systemName: "xmark")
//        button.setImage(image, for: .normal)
//        button.tintColor = .white
//        button.layer.cornerRadius = 13
//        button.backgroundColor = .black
//        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
//        return button
//    }()
//
//    let shareButton: UIButton = {
//        let button = UIButton()
//        let image = UIImage(systemName: "shareplay")
//        button.setImage(image, for: .normal)
//        button.tintColor = .white
//        button.backgroundColor = .black
//        button.layer.cornerRadius = 13
//        return button
//    }()
//    let likeButton = VerticalButton(frame: .zero)
//    let dislikeButton = VerticalButton(frame: .zero)
//    let listButton = VerticalButton(frame: .zero)
//    let givePointButton = VerticalButton(frame: .zero)
//    let recommendButton = VerticalButton(frame: .zero)
//    let menuController = MenuDetailController(collectionViewLayout: UICollectionViewFlowLayout())
//    lazy var menuView = menuController.view!
//    let horizontalButtonStackView = UIStackView()
//    var dataSource: UICollectionViewDiffableDataSource<Section, Movie>!
//    var collectionView: UICollectionView!
//
//    var movieId: Int!
//    var movie: Movie?
//    var similarMovies = [Movie]()
//    var showMovies = [Movie]()
//    var recommendedMovies: [Movie] = []
//    var viewModel: MovieDetailViewModel?
//    weak var delegate: MovieDetailControllerDelegate?
//    let currentUserId = UserSession.shared.userId
//
//    private var originalCenter: CGPoint = .zero
//    private let threshold: CGFloat = 100
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        viewModel?.delegate = self
//        Task{
//            await viewModel?.load()
//            await viewModel?.getSimilarMovies()
//            await viewModel?.getRecommendedMovies()
//        }
//
//        design()
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        self.delegate?.dismissBlurView()
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        menuController.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
//    }
//
//    init(id: Int) {
//        super.init(nibName: nil, bundle:nil)
//        self.movieId = id
//        self.viewModel = MovieDetailViewModel(id: id)
//        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createFlowLayout())
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func design() {
//        configureViewController()
//        configureImageView()
//        configureXButton()
//        configureScrollView()
//        configureStackView()
//        configureMovieInfoView()
//        configureButtonStackView()
//        configureOverviewLabel()
//        configureCastAndDirectorsLabels()
//        configureHorizontalButtonStackView()
//        configureMenuController()
//        configureCollectionView()
//        configurePlayButton()
//        configureDataSource()
//        setupPanGesture()
//
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hidePopover))
//        overlayView.addGestureRecognizer(tapGesture)
//    }
//
//    private func setupPanGesture() {
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
//        view.addGestureRecognizer(panGesture)
//    }
//
//    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
//        let translation = gesture.translation(in: view)
//
//        switch gesture.state {
//        case .began:
//            originalCenter = view.center
//
//        case .changed:
//            view.center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y + translation.y)
//
//        case .ended:
//            let velocity = gesture.velocity(in: view)
//            let shouldDismiss = abs(translation.x) > threshold || abs(translation.y) > threshold || abs(velocity.x) > 500 || abs(velocity.y) > 500
//
//            if shouldDismiss {
//                let directionX: CGFloat = translation.x > 0 ? 1 : -1
//                let directionY: CGFloat = translation.y > 0 ? 1 : -1
//
//                UIView.animate(withDuration: 0.3, animations: {
//                    self.view.center = CGPoint(x: self.originalCenter.x + directionX * self.view.bounds.width, y: self.originalCenter.y + directionY * self.view.bounds.height)
//                }) { _ in
//                    self.dismiss(animated: false)
//                    self.delegate?.dismissBlurView()
//                }
//            } else {
//                UIView.animate(withDuration: 0.3) {
//                    self.view.center = self.originalCenter
//                }
//            }
//
//        default:
//            break
//        }
//    }
//
//    private func configureXButton() {
//        view.addSubviews(xButton, shareButton)
//
//        xButton.snp.makeConstraints { make in
//            make.trailing.equalToSuperview().inset(10)
//            make.height.width.equalTo(26)
//            make.top.equalTo(imageView.snp.top).inset(10)
//        }
//
//        shareButton.snp.makeConstraints { make in
//            make.trailing.equalTo(xButton.snp.leading).offset(-4)
//            make.height.width.equalTo(26)
//            make.top.equalTo(imageView.snp.top).inset(10)
//        }
//    }
//
//
//    private func configureViewController() {
//        tabBarController?.tabBar.isHidden = true
//
//        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThickMaterialDark))
//        blurView.frame = view.bounds
//        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//        view.addSubview(blurView)
//
//        blurView.alpha = 0.8
//
//        view.layer.cornerRadius = 10
//        view.layer.masksToBounds = true
//    }
//
//
//    func configureImageView() {
//        let width = view.frame.width
//        let imageWidth = 780 / width
//        let imageHeight = 438 / imageWidth
//
//        view.addSubview(imageView)
//
//        imageView.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            make.leading.trailing.equalTo(view)
//            make.height.equalTo(imageHeight)
//        }
//    }
//
//    func configureButtonStackView() {
//        buttonStackView.addArrangedSubview(horizontalPlayButton)
//        buttonStackView.addArrangedSubview(horizontalDownloadButton)
//
//        buttonStackView.snp.makeConstraints { make in
//            make.top.equalTo(movieInfoView.snp.bottom).offset(4)
//            make.leading.trailing.equalToSuperview().inset(10)
//            make.height.equalTo(70)
//        }
//
//        horizontalPlayButton.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview()
//        }
//
//        horizontalDownloadButton.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview()
//        }
//    }
//
//    func configureHorizontalButtonStackView() {
//        listButton.verticalImage = UIImage(systemName: "plus")
//        listButton.verticalTitle = "My List"
//        listButton.addTarget(self, action: #selector(listButtonTapped), for: .touchUpInside)
//
//        givePointButton.verticalImage = UIImage(systemName: "hand.thumbsup")
//        givePointButton.verticalTitle = "Rate this"
//        givePointButton.addTarget(self, action: #selector(giveRateTapped), for: .touchUpInside)
//
//        recommendButton.verticalImage = UIImage(systemName: "paperplane")
//        recommendButton.verticalTitle = "Recommend"
//
//        horizontalButtonStackView.addArrangedSubview(listButton)
//        horizontalButtonStackView.addArrangedSubview(givePointButton)
//        horizontalButtonStackView.addArrangedSubview(recommendButton)
//
//        horizontalButtonStackView.distribution = .fillEqually
//        horizontalButtonStackView.alignment = .fill
//
//        horizontalButtonStackView.snp.makeConstraints { make in
//            make.top.equalTo(directorsLabel.snp.bottom).offset(10)
//            make.leading.equalToSuperview().inset(10)
//            make.trailing.equalToSuperview().inset(100)
//            make.height.equalTo(40)
//        }
//    }
//
//    func configureCastAndDirectorsLabels() {
//        castLabel.snp.makeConstraints { make in
//            make.top.equalTo(overviewLabel.snp.bottom).offset(10)
//            make.leading.trailing.equalToSuperview().inset(10)
//            make.height.equalTo(40)
//        }
//
//        directorsLabel.snp.makeConstraints { make in
//            make.top.equalTo(castLabel.snp.bottom).offset(2)
//            make.leading.trailing.equalToSuperview().inset(10)
//            make.height.equalTo(30)
//        }
//    }
//
//    func configureStackView() {
//        stackView.addArrangedSubview(movieInfoView)
//        stackView.addArrangedSubview(buttonStackView)
//        stackView.addArrangedSubview(overviewLabel)
//        stackView.addArrangedSubview(castLabel)
//        stackView.addArrangedSubview(directorsLabel)
//        stackView.addArrangedSubview(horizontalButtonStackView)
//        stackView.addArrangedSubview(menuView)
//        stackView.addArrangedSubview(collectionView)
//
//        scrollView.addSubview(stackView)
//
//        stackView.snp.makeConstraints { make in
//            make.width.equalTo(scrollView.snp.width)
//            make.top.equalTo(scrollView.snp.top)
//            make.bottom.equalTo(scrollView.snp.bottom)
//            make.trailing.equalTo(scrollView.snp.trailing)
//            make.leading.equalTo(scrollView.snp.leading)
//        }
//    }
//
//    func configurePlayButton() {
//        playButton.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
//
//        view.addSubview(playButton)
//
//        playButton.snp.makeConstraints { make in
//            make.centerX.equalTo(imageView.snp.centerX)
//            make.centerY.equalTo(imageView.snp.centerY)
//            make.width.height.equalTo(50)
//        }
//    }
//
//    func goToSeeAllScreen() {
//        let destVC = SeeAllVC(endpoint: .similar, type: "Similar Movies", id: movieId)
//        navigationController?.pushViewController(destVC, animated: true)
//    }
//
//    func configureMenuController() {
//        menuController.delegate = self
//
//        menuView.snp.makeConstraints { make in
//            make.top.equalTo(horizontalButtonStackView.snp.bottom).offset(10)
//            make.leading.trailing.equalToSuperview().inset(10)
//            make.height.equalTo(40)
//        }
//
//        menuController.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
//    }
//
//    func configureCollectionView() {
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.backgroundColor = .clear
//        collectionView.register(SimilarMovieCell.self, forCellWithReuseIdentifier: SimilarMovieCell.identifier)
//
//        collectionView.snp.makeConstraints { make in
//            make.top.equalTo(menuController.view.snp.bottom).offset(20)
//            make.leading.trailing.equalToSuperview().inset(10)
//            make.height.equalTo(300)
//        }
//    }
//
//    func createFlowLayout() -> UICollectionViewFlowLayout {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.minimumLineSpacing = 10
//        layout.minimumInteritemSpacing = 0
//
//        let itemsPerRow: CGFloat = 3
//        let spacing: CGFloat = 10
//        let availableWidth = ScreenSize.width - (spacing * (itemsPerRow + 1))
//        let itemWidth = availableWidth / itemsPerRow
//
//        layout.itemSize = CGSize(width: itemWidth, height: 150)
//        return layout
//    }
//
//    func updatedData(on movies: [Movie]) {
//        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
//        snapshot.appendSections([.main])
//        snapshot.appendItems(movies)
//        DispatchQueue.main.async{
//            self.dataSource.apply(snapshot,animatingDifferences: true)
//        }
//        calculateHeight(arr: movies)
//    }
//
//    func configureDataSource() {
//        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower in
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SimilarMovieCell.identifier, for: indexPath) as! SimilarMovieCell
//            let movie = self.showMovies[indexPath.item]
//            cell.set(movie: movie)
//            return cell
//        })
//    }
//
//    func configureScrollView() {
//        view.addSubview(scrollView)
//
//        scrollView.isScrollEnabled = true
//        scrollView.showsVerticalScrollIndicator = true
//
//        scrollView.delegate = self
//
//        scrollView.snp.makeConstraints { make in
//            make.top.equalTo(imageView.snp.bottom)
//            make.leading.trailing.bottom.equalToSuperview()
//        }
//    }
//
//    func configureOverviewLabel() {
//        overviewLabel.snp.makeConstraints { make in
//            make.top.equalTo(buttonStackView.snp.bottom).offset(20)
//            make.leading.trailing.equalToSuperview().inset(10)
//        }
//    }
//
//    func configureMovieInfoView() {
//        movieInfoView.snp.makeConstraints { make in
//            make.top.equalTo(stackView.snp.top).offset(10)
//            make.leading.equalToSuperview().offset(10)
//            make.height.equalTo(50)
//            make.width.equalTo(350)
//        }
//    }
//
//    func didTapMenuItem(indexPath: IndexPath) {
//        if indexPath.item == 0 {
//            showMovies = self.similarMovies
//            updatedData(on: self.showMovies)
//        } else if indexPath.item == 1 {
//            showMovies = self.recommendedMovies
//            updatedData(on: showMovies)
//        }
//    }
//
//    func calculateHeight(arr: [Movie]) {
//        let itemsPerRow: CGFloat = 3
//        let spacing: CGFloat = 10
//        let availableWidth = ScreenSize.width - (spacing * (itemsPerRow + 1))
//        let itemHeight: CGFloat = 150
//
//        let rowCount = ceil(CGFloat(arr.count) / itemsPerRow)
//        let totalSpacing = spacing * (rowCount - 1)
//        let height = rowCount * itemHeight + totalSpacing + 20
//
//        collectionView.snp.updateConstraints { make in
//            make.height.equalTo(height)
//        }
//    }
//
//    @objc func listButtonTapped() {
//        guard let id = movie?.id, let userId = currentUserId else { return }
//
//        listButton.animatedRotation()
//
//        viewModel?.addList(movieId: id, userId: userId)
//    }
//
//
//    private func setupPopover() {
//        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
//        overlayView.isHidden = false
//        view.addSubview(overlayView)
//
//        overlayView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//
//        popoverView.backgroundColor = .customDarkGray
//        popoverView.layer.cornerRadius = 40
//        popoverView.isHidden = true
//
//        self.dislikeButton.verticalImage = (viewModel?.checkIsDisliked(userId: currentUserId ?? "", movieId: movie?.id ?? 0))! ? UIImage(systemName: "hand.thumbsdown.fill") : UIImage(systemName: "hand.thumbsdown")
//        dislikeButton.verticalTitle = "Bunu sevmedim"
//        dislikeButton.addTarget(self, action: #selector(dislikeMovie), for: .touchUpInside)
//
//
//        self.likeButton.verticalImage = (viewModel?.checkIsLiked(userId: currentUserId ?? "", movieId: movie?.id ?? 0))! ? UIImage(systemName: "hand.thumbsup.fill") : UIImage(systemName: "hand.thumbsup")
//        likeButton.verticalTitle = "Buna bayıldım"
//        likeButton.addTarget(self, action: #selector(likeMovie), for: .touchUpInside)
//
//        let buttonStackView = UIStackView(arrangedSubviews: [dislikeButton, likeButton])
//        buttonStackView.axis = .horizontal
//        buttonStackView.spacing = 10
//        popoverView.addSubview(buttonStackView)
//
//        buttonStackView.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview()
//            make.centerY.equalToSuperview()
//            make.height.equalTo(50)
//            make.width.equalTo(200)
//        }
//
//        view.addSubview(popoverView)
//
//        popoverView.snp.makeConstraints { make in
//            make.centerX.equalTo(givePointButton.snp.centerX)
//            make.bottom.equalTo(givePointButton.snp.top).offset(-10)
//            make.width.equalTo(200)
//            make.height.equalTo(100)
//        }
//    }
//
//    @objc func likeMovie() {
//        guard let currentUserId = currentUserId, let id = movie?.id else { return }
//
//        let bool = viewModel?.checkIsLiked(userId: currentUserId, movieId: id)
//
//        if bool! {
//            viewModel?.removeFavMovie(userId: currentUserId, movieId: id)
//        } else {
//            viewModel?.addFavMovie(userId: currentUserId, movieId: id)
//        }
//        hidePopover()
//    }
//
//    @objc func dislikeMovie() {
//        guard let currentUserId = currentUserId, let id = movie?.id else { return }
//
//        let bool = viewModel?.checkIsLiked(userId: currentUserId, movieId: id)
//
//        if bool! {
//            viewModel?.removeFavMovie(userId: currentUserId, movieId: id)
//        } else {
//            viewModel?.addFavMovie(userId: currentUserId, movieId: id)
//        }
//        hidePopover()
//    }
//
//    @objc func hidePopover() {
//        overlayView.isHidden = true
//        popoverView.isHidden = true
//    }
//
//    @objc func giveRateTapped() {
//        setupPopover()
//
//        popoverView.isHidden = !popoverView.isHidden
//        if !popoverView.isHidden {
//            popoverView.alpha = 0
//            UIView.animate(withDuration: 0.3) {
//                self.popoverView.alpha = 1
//            }
//        } else {
//            UIView.animate(withDuration: 0.3) {
//                self.popoverView.alpha = 0
//            }
//        }
//    }
//
//    @objc func removeFavMovie() {
//        guard let currentUserId = currentUserId, let id = movie?.id else { return }
//        viewModel?.removeFavMovie(userId: currentUserId, movieId: id)
//    }
//
//
//    @objc func addFavMovie() {
//        guard let currentUserId = currentUserId, let id = movie?.id else { return }
//        viewModel?.addFavMovie(userId: currentUserId, movieId: id)
//    }
//
//    func add(childVC: UIViewController, to containerView: UIView) {
//        addChild(childVC)
//        containerView.addSubview(childVC.view)
//        childVC.view.frame = containerView.bounds
//        childVC.didMove(toParent: self)
//    }
//
//
//    @objc func didTapPlayButton() {
//        Task{
//            await viewModel?.fetchMovieVideo()
//        }
//    }
//
//    @objc func dismissView() {
//        UIView.animate(withDuration: 0.3, animations: {
//            self.delegate?.dismissBlurView()
//        }) { _ in
//            self.dismiss(animated: true)
//        }
//    }
//}
//
//extension MovieDetailVC: UICollectionViewDataSource, UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        similarMovies.count
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SimilarMovieCell.identifier, for: indexPath) as! SimilarMovieCell
//        let movie = similarMovies[indexPath.row]
//        cell.set(movie: movie)
//        return cell
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let id = similarMovies[indexPath.row].id
//        let destVC = MovieDetailVC(id: id)
//        navigationController?.pushViewController(destVC, animated: true)
//    }
//}
//
//
//extension MovieDetailVC: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: (ScreenSize.width / 3) - 20, height: 150)
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//}
//
//
//extension MovieDetailVC: MovieDetailViewModelDelegate{
//    func handleOutput(_ output: MovieDetailViewModelOutput) {
//        DispatchQueue.main.async{ [weak self] in
//            guard let self = self else { return }
//            switch output {
//            case .getDetail(let movie):
//                self.movie = movie
//                self.movieInfoView.set(movie: movie)
//                self.title = movie.title
//                self.overviewLabel.text = movie.overview
//                self.castLabel.text = "Cast Crew: " + (movie.cast?.map({ $0.name }).joined(separator: ", ") ?? "")
//                self.directorsLabel.text = "Director: " + (movie.directors?.map({ $0.name }).joined(separator: ", ") ?? "")
//
//                self.listButton.verticalImage = (viewModel?.isInMyList(movieId: movie.id, userId: currentUserId ?? ""))! ? UIImage(systemName: "checkmark") : UIImage(systemName: "plus")
//
//
//            case .setLoading(let bool):
//                switch bool {
//                case true:
//                    showLoadingView()
//                case false:
//                    dismissLoadingView()
//                }
//
//            case .error(let error):
//                presentAlertOnMainThread(title: "Error", message: error.localizedDescription, buttonTitle: "Ok")
//
//            case .downloadImage(let image):
//                self.imageView.image = image
//
//            case .getSimilarMovie(let movies):
//                self.similarMovies = movies
//                self.showMovies = movies
//                self.updatedData(on: self.similarMovies)
//
//
//            case .didTapPlayButton(let videoURL):
//                presentSafariVC(with: videoURL)
//
//
//            case .addFavMovie:
//                break
//
//            case .removeFavMovie:
//                break
//
//            case .infoButtonTapped(let url):
//                presentSafariVC(with: url)
//
//            case .configureFavButton(let image, let action):
//                favButton.action = action
//                favButton.image = image
//
//            case .getRecommendedMovies(let movies):
//                self.recommendedMovies = movies
//            }
//        }
//    }
//}
//
