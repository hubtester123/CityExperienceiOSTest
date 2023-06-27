//
//  NewsManager.swift
//  CityExperienceIOSTest
//
//  Created by Tony Cheung on 25/6/2023.
//

import Foundation
import Alamofire

enum NewsServiceError: Error {
    case failToFormURL
    case noData
    case cannotParseData
}

struct NewsService {

    static let shared = NewsService()

    private let urlScheme = "https"
    private let host = "newsapi.org"
    private var todayDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let currentDate = Date()
        let calendar = Calendar.current

        var dateComponents = DateComponents()
        dateComponents.month = -1

        if let previousMonthDate = calendar.date(byAdding: dateComponents, to: currentDate) {
            let dateString = dateFormatter.string(from: previousMonthDate)
           return dateString
        }

        return "2022-01-01"
    }
    private let sortBy = "pubishedAt"
    private let apiKey = ""

    func getNews(searchWord:String,
                 page:Int,
                 pageSize:Int,
                 completion: @escaping ([News]?, Error?) -> ()) {

        var urlComponents = URLComponents()
        urlComponents.scheme = urlScheme
        urlComponents.host = host
        urlComponents.path = "/v2/everything"

        urlComponents.queryItems = [
            URLQueryItem(name: "qinTitle", value: searchWord),
            URLQueryItem(name: "from", value: todayDateString),
            URLQueryItem(name: "sortBy", value: sortBy),
            URLQueryItem(name: "apiKey", value: apiKey),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "pageSize", value: String(pageSize))
        ]


        guard let urlString = urlComponents.string else {
            completion(nil, NewsServiceError.failToFormURL)
            return
        }

        print(urlString)

        AF.request(urlString)
            .validate(statusCode: 200..<300)
            .response { response in

                if let error = response.error {
                    completion(nil, error)
                    return
                }

                guard let data = response.data else {
                    completion(nil, NewsServiceError.noData)
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601

                    let newsReponse = try decoder.decode(NewsResponse.self, from: data)

                    guard let news = newsReponse.articles else {
                        completion(nil, NewsServiceError.cannotParseData)
                        return
                    }

                    completion(news, nil)

                } catch let error {
                    completion(nil, error)
                }
            }
    }

    func getDummyNews(completion: @escaping ([News]?, Error?) -> ()) {

        AF.request("https://saurav.tech/NewsAPI/everything/cnn.json")
            .validate(statusCode: 200..<300)
            .response { response in

                if let error = response.error {
                    completion(nil, error)
                    return
                }

                guard let data = response.data else {
                    completion(nil, NewsServiceError.noData)
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601

                    let newsReponse = try decoder.decode(NewsResponse.self, from: data)

                    guard let news = newsReponse.articles else {
                        completion(nil, NewsServiceError.cannotParseData)
                        return
                    }

                    completion(news, nil)

                } catch let error {
                    completion(nil, error)
                }
            }
    }
}
