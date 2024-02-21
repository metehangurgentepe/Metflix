//
//  CarouselView.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 17.02.2024.
//

import UIKit


class CarouselView: UIView {
    var carousel: UICollectionView = {
        let layout = CustomCollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10 / 2
        layout.minimumInteritemSpacing = 10 / 2
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.identifier)
        return collectionView
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .red
        pageControl.pageIndicatorTintColor = .cyan
        pageControl.backgroundStyle = .minimal
        pageControl.numberOfPages = 20
        pageControl.allowsContinuousInteraction = true
        return pageControl
    }()
    
    var movies: MovieResponse?
    weak var delegate: HomeVCCarouselDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
        carousel.delegate = self
        carousel.dataSource = self
    }
    
    
    convenience init(movies: MovieResponse) {
        self.init()
        self.movies = movies
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func highlightSelectedItem() {
        guard let movies = movies?.results, movies.count > 4 else { return }
        
        let indexPath = IndexPath(item: 4, section: 0)
        carousel.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    
    func createUI() {
        addSubviews(carousel, pageControl)
        
        carousel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(330)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(carousel.snp.bottom).offset(50)
            make.height.equalTo(100)
        }
    }
}

extension CarouselView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies?.results.count ?? 20
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCell.identifier, for: indexPath) as! CarouselCell
        if let image = movies?.results[indexPath.row].posterURL {
            cell.set(imageUrl: image)
        }
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 168, height: 250)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movieList = movies{
            let movieId = movieList.results[indexPath.row].id
            delegate?.didSelectMovie(movieId: movieId)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        pageControl.currentPage = currentIndex
    }
}

