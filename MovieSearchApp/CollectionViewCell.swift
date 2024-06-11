//
//  CollectionViewCell.swift
//  MovieSearchApp
//
//  Created by 심소영 on 6/11/24.
//

import UIKit
import Alamofire
import SnapKit
import Kingfisher

class CollectionViewCell: UICollectionViewCell {
    
    static let id = "CollectionViewCell"
    
    let mainImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureMainCell(data: Result) {
        let image = "https://image.tmdb.org/t/p/original\(data.poster_path)"
        let url = URL(string: image)
        mainImage.kf.setImage(with: url)
        
    }
    func configureHierarchy(){
        contentView.addSubview(mainImage)
    }
    func configureLayout(){
        mainImage.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    func configureUI(){
        backgroundColor = .gray
    }
}



