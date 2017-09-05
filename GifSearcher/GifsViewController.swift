//
//  GifsViewController.swift
//  GifSearcher
//
//  Created by Yang, Zebin (Contractor) on 8/27/17.
//  Copyright © 2017 Yang, Zebin. All rights reserved.
//

import UIKit
import RxSwift

class GifsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var gifsToDisplay: [Gif]?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpObserver()
        DispatchQueue.main.async{
            self.startSpinning()
        }
        GiphyHelper.shared.fetchTrendingGifs()

        title = NSLocalizedString("~~~Gifs~~~", comment: "")
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    }

    fileprivate func setUpObserver() {
        GiphyHelper.shared.gifs.asObservable().subscribe(onNext: { (gifs) in
            self.gifsToDisplay = gifs
            ImageHelper.shared.storedGifs.removeAll()
           
            for gif in gifs {
                guard let url = gif.url else { continue }
                ImageHelper.shared.storeImageFor(url)
            }
            self.tableView.reloadData()
            DispatchQueue.main.async{
                self.stopSpinning()
            }
        }).addDisposableTo(disposeBag)
        
    }

    fileprivate func searchGifs(_ searchedContent: String) {
        GiphyHelper.shared.fetchSearchedGifs(searchedContent)
    }
    
    fileprivate func startSpinning() {
        indicatorView.isHidden = false
        indicator.startAnimating()
    }
    
    fileprivate func stopSpinning() {
        indicator.stopAnimating()
        indicatorView.isHidden = true
    }

}

// MARK: - Table view data source
extension GifsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gifsToDisplay?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GifTableViewCell.Identifier, for: indexPath) as? GifTableViewCell else {
            //Something went wrong with the identifier.
            return UITableViewCell()
        }
        
        guard let gif = gifsToDisplay?[indexPath.row] else {
            return cell
        }
        
        cell.configureWithGif(gif)
        return cell
    }
}

// MARK: - Table view delegate
extension GifsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

// MARK: - Search bar delegate
extension GifsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, text.isEmpty == false else { return }
        DispatchQueue.main.async{
            self.startSpinning()
        }
        searchGifs(text)
    }
    
}
