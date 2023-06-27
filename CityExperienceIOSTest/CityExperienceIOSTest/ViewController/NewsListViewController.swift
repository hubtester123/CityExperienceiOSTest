//
//  ViewController.swift
//  CityExperienceIOSTest
//
//  Created by Tony Cheung on 24/6/2023.
//

import UIKit
import SnapKit

class NewsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    let newsViewModel = NewsViewModel()

    let refreshControl = UIRefreshControl()
    let searchBar = UISearchBar()
    let tableView = UITableView()

    override func viewDidLoad() {

        super.viewDidLoad()

        setupUI()

        setupConstraints()

        newsViewModel.didGetNews = {
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            self.tableView.reloadData()
        }

        newsViewModel.didFailTheNetworkCall = {
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
    }

    private func setupUI() {

        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self,
                                 action: #selector(didTriggerRefresh),
                                 for: .valueChanged)

        searchBar.delegate = self
        searchBar.placeholder = "Search news here"
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 56))
        bgView.addSubview(searchBar)
        tableView.tableHeaderView = bgView

        tableView.register(NewsListTableViewCell.self, forCellReuseIdentifier: "NewsTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .singleLine
        self.view.addSubview(tableView)
    }

    private func setupConstraints() {

        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }


        searchBar.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
    }

    @objc private func didTriggerRefresh() {

        refreshControl.beginRefreshing()
        newsViewModel.refreshNews()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return newsViewModel.news.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "NewsTableViewCell"

        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? NewsListTableViewCell

        if cell == nil {
            cell = NewsListTableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }

        cell?.setupWithNews(news: newsViewModel.news[indexPath.row])

        if Double(indexPath.row) > Double(newsViewModel.news.count) * 0.8 {
            newsViewModel.loadMoreNews()
        }

        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let news = newsViewModel.news[indexPath.row]
        let newsDetailViewModel = NewsDetailViewModel(news: news)
        let newsDetailViewController = NewsDetailViewController(newsDetailViewModel: newsDetailViewModel)
        navigationController?.pushViewController(newsDetailViewController, animated: true)
    }

    // MARK: UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        newsViewModel.updateSearchWord(searchWord: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        searchBar.resignFirstResponder()
    }

}

