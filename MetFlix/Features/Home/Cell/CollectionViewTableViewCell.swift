//
//  CollectionViewTableViewCell.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 16.02.2024.
//

import UIKit

class CollectionViewTableViewCell: UITableViewCell, UICollectionViewDelegateFlowLayout {
    
    static let identifier = "CollectionTableViewCell"
    
    var movieArr: [Movie] = []
    var title: String?
    var action: UIAction?
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    var isRecommended: Bool = false
    
    weak var delegate: HomeVCCarouselDelegate?
    
    var isTopRated: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let height = 1170 / 200
        
        layout.itemSize = CGSize(width: 780 / height, height: 225)
        layout.minimumLineSpacing = 10
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.register(TopRatedCollectionViewCell.self, forCellWithReuseIdentifier: TopRatedCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        contentView.addSubview(collectionView)
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    public func configure(movies: [Movie], delegate: HomeVCCarouselDelegate) {
        self.movieArr = movies
        self.delegate = delegate
        DispatchQueue.main.async{
            self.collectionView.reloadData()
        }
    }
}

extension CollectionViewTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isTopRated {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopRatedCollectionViewCell.identifier, for: indexPath) as! TopRatedCollectionViewCell
            let model = movieArr[indexPath.row]
            cell.configure(movie: model, rank: indexPath.row + 1)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as! MovieCollectionViewCell
            let model = movieArr[indexPath.row]
            cell.configure(movie: model, isRecommended: isRecommended)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieId = movieArr[indexPath.row].id
        delegate?.didSelectMovie(movieId: movieId)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isTopRated {
            let height = 1170 / 200
            return .init(width: 850 / height, height: 225)
        } else {
            let height = 1170 / 200
            return .init(width: 780 / height, height: 225)
        }
    }
}
