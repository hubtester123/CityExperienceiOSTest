//
//  NewsListTableViewCell.swift
//  CityExperienceIOSTest
//
//  Created by Tony Cheung on 26/6/2023.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage

class NewsListTableViewCell: UITableViewCell {

    private(set) var news:News? {
        didSet {
            updateUI()
        }
    }

    let newsImageView = UIImageView()
    let titleLebel = UILabel()
    let authorLabel = UILabel()
    let sourceLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        setupUI()
        setupConstraints()
    }

    func setupWithNews(news: News?) {

        self.news = news
    }

    private func setupUI() {

        selectionStyle = .none

        newsImageView.contentMode = .scaleAspectFit
        addSubview(newsImageView)

        titleLebel.font = .preferredFont(forTextStyle: .headline)
        titleLebel.numberOfLines = 2
        titleLebel.sizeToFit()
        addSubview(titleLebel)

        authorLabel.font = .preferredFont(forTextStyle: .subheadline)
        addSubview(authorLabel)

        sourceLabel.font = .preferredFont(forTextStyle: .subheadline)
        addSubview(sourceLabel)
    }

    private func updateUI() {
        
        titleLebel.text = news?.title ?? ""
        authorLabel.text = "Author: " + (news?.author ?? "")
        sourceLabel.text = "Source: " + (news?.source?.name ?? "")
        newsImageView.sd_setImage(with: URL(string: news?.urlToImage ?? ""), placeholderImage: UIImage(named: "NoImage"))
    }

    private func setupConstraints() {

        newsImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(230)
        }

        titleLebel.snp.makeConstraints { make in
            make.top.equalTo(newsImageView.snp.bottom).offset(10)
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
            make.bottom.equalToSuperview().offset(-10)
        }
    }

}
