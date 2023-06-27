//
//  NewsDetailViewController.swift
//  CityExperienceIOSTest
//
//  Created by Tony Cheung on 26/6/2023.
//

import Foundation
import UIKit

class NewsDetailViewController: UIViewController {

    let newsDetailViewModel: NewsDetailViewModel

    let imageView = UIImageView()
    let titleLebel = UILabel()
    let authorLabel = UILabel()
    let sourceLabel = UILabel()
    let contentTextView = UITextView()

    init(newsDetailViewModel: NewsDetailViewModel) {
        self.newsDetailViewModel = newsDetailViewModel
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        setupUI()
        setupConstraints()
        updateUIWithViewModel()
    }

    private func setupUI() {

        self.edgesForExtendedLayout = []

        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)

        titleLebel.font = .preferredFont(forTextStyle: .headline)
        titleLebel.numberOfLines = 2
        titleLebel.sizeToFit()
        self.view.addSubview(titleLebel)

        authorLabel.font = .preferredFont(forTextStyle: .subheadline)
        self.view.addSubview(authorLabel)

        sourceLabel.font = .preferredFont(forTextStyle: .subheadline)
        self.view.addSubview(sourceLabel)

        contentTextView.font = .preferredFont(forTextStyle: .body)
        contentTextView.backgroundColor = .clear
        contentTextView.isEditable = false
        self.view.addSubview(contentTextView)
    }

    private func setupConstraints() {

        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(230)
        }

        titleLebel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLebel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        sourceLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(sourceLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-30)
        }
    }

    private func updateUIWithViewModel() {

        titleLebel.text = newsDetailViewModel.news.title
        authorLabel.text = "Author: " + (newsDetailViewModel.news.author ?? "")
        sourceLabel.text = "Source: " + (newsDetailViewModel.news.source?.name ?? "")
        contentTextView.text = newsDetailViewModel.news.content
        imageView.sd_setImage(with: URL(string: newsDetailViewModel.news.urlToImage ?? ""), placeholderImage: UIImage(named: "NoImage"))
    }

}
