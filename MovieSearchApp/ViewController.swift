//
//  ViewController.swift
//  MovieSearchApp
//
//  Created by 심소영 on 6/11/24.
//

import UIKit
import Alamofire
import SnapKit
import Kingfisher

class ViewController: UIViewController {
    
    var movieList = Movie(page: 0, results: [], total_pages: 0, total_results: 0)
    
    let searchBar = UISearchBar()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width - 40
        layout.itemSize = CGSize(width: width / 3, height:  width / 3)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return layout
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    func configureHierarchy(){
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.id)
    }
    func configureLayout(){
        searchBar.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(searchBar.snp.bottom)
        }
    }
    func configureUI(){
        view.backgroundColor = .white
        collectionView.backgroundColor = .black
        searchBar.backgroundColor = .gray
        collectionView.contentMode = .scaleAspectFill
    }
    func callRequest(query: String){
        let url = "\(APIURL.apiURL)\(query)&include_adult=false&language=en-US&page=1"
        let header: HTTPHeaders = ["accept": "application/json", "Authorization": APIKey.apiKey]
        AF.request(url, headers: header ).responseDecodable(of: Movie.self) { response in
            switch response.result {
            case .success(let value):
                self.movieList = value
                self.collectionView.reloadData()
            case .failure(_):
                    let alert = UIAlertController(
                        title: "'ㅈ\(self.searchBar.text ?? "")'라는",
                        message: "검색 결과가 없습니다.",
                        preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "확인", style: .cancel)
                    alert.addAction(cancel)
                    self.present(alert, animated: true)
            }
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.results.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.id, for: indexPath) as! CollectionViewCell
        let data = movieList.results[indexPath.item]
        cell.configureMainCell(data: data)
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        return cell
    }    
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            callRequest(query: searchBar.text!)
    }
}

extension ViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        callRequest(query: searchBar.text!)
    }
}
