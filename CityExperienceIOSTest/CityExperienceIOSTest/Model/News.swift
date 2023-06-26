//
//  News.swift
//  CityExperienceIOSTest
//
//  Created by Tony Cheung on 26/6/2023.
//

import Foundation

struct NewsResponse: Codable {
    var articles:[News]?
}

struct News: Codable {
    var source: Source?
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: Date?
    var content: String?
}

struct Source: Codable {
    var name: String?
}
