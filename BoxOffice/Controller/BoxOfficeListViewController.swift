//
//  BoxOfficeListViewController.swift
//  BoxOffice
//
//  Created by Rhode, Rilla on 2023/03/20.
//


import UIKit

final class BoxOfficeListViewController: UIViewController {
    private let server = NetworkManager()
    private let urlMaker = URLMaker()
    private var boxOffice: BoxOffice?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CustomCollectionViewCell.self,
                                forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMainView()
        configureCollectionView()
        configureRefreshControl()
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        LoadingIndicator.showLoading()
        
        view.addSubview(collectionView)
        collectionView.setAutoLayout(equalTo: view.safeAreaLayoutGuide)
        
        fetchBoxOfficeData {
            DispatchQueue.main.async {
                LoadingIndicator.hideLoading()
                self.collectionView.reloadData()
            }
        }
    }
    
    private func configureMainView() {
        view.backgroundColor = .white
        title = Date.configureYesterday(isFormatted: true)
    }
    
    private func fetchBoxOfficeData(completion: @escaping () -> Void) {
        guard let url = urlMaker.makeBoxOfficeURL(date: Date.configureYesterday(isFormatted: false)) else { return }
        server.startLoad(url: url) { result in
            let decoder = DecodeManager()
            
            guard let verifiedFetchingResult = self.verifyFetchingResult(result: result) else { return }
            let decodedFile = decoder.decodeJSON(data: verifiedFetchingResult, type: BoxOffice.self)
            let verifiedDecodingResult = self.verifyDecodingResult(result: decodedFile)
            
            self.boxOffice = verifiedDecodingResult
            completion()
        }
    }
    
    private func verifyFetchingResult(result: Result<Data, NetworkError>) -> Data? {
        switch result {
        case .success(let data):
            return data
        case .failure(_):
            return nil
        }
    }
    
    private func verifyDecodingResult<T: Decodable>(result: Result<T, DecodeError>) -> T? {
        switch result {
        case .success(let data):
            return data
        case .failure(_):
            return nil
        }
    }
    
    private func configureRefreshControl() {
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self,
                                                 action: #selector(handleRefreshControl),
                                                 for: .valueChanged)
    }
    
    @objc private func handleRefreshControl() {
        self.fetchBoxOfficeData {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7 ) {
                self.collectionView.reloadData()
                self.collectionView.refreshControl?.endRefreshing()
            }
        }
    }
    
}

extension BoxOfficeListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = boxOffice?.boxOfficeResult.dailyBoxOfficeList.count else { return 0 }
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dailyBoxOffice = self.boxOffice?.boxOfficeResult.dailyBoxOfficeList[indexPath.item]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell else { return CustomCollectionViewCell() }
        
        cell.configureDailyBoxOffice(dailyBoxOffice: dailyBoxOffice)

        return cell
    }
}

extension BoxOfficeListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        
        let itemsPerRow: CGFloat = 1
        let itemsPerColumn: CGFloat = 8.5
       
        let cellWidth = width / itemsPerRow
        let cellHeight = height / itemsPerColumn
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
