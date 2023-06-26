//
//  ViewController.swift
//  CityExperienceIOSTest
//
//  Created by Tony Cheung on 24/6/2023.
//

import UIKit
import SnapKit

class NewsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let newsViewModel = NewsViewModel()

    let tableView = UITableView()

    override func viewDidLoad() {

        super.viewDidLoad()

        setupUI()

        setupConstraints()

        newsViewModel.didGetNews = {
            self.tableView.reloadData()
        }

        newsViewModel.getNews()
    }

    private func setupUI() {

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
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return newsViewModel.news?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "NewsTableViewCell"

        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? NewsListTableViewCell

        if cell == nil {
            cell = NewsListTableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }

        cell?.setupWithNews(news: newsViewModel.news?[indexPath.row])

        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let news = newsViewModel.news?[indexPath.row] else { return }

        let newsDetailViewModel = NewsDetailViewModel(news: news)
        let newsDetailViewController = NewsDetailViewController(newsDetailViewModel: newsDetailViewModel)
        navigationController?.pushViewController(newsDetailViewController, animated: true)
    }

}

