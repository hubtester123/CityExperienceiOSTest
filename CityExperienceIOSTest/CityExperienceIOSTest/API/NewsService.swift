//
//  NewsManager.swift
//  CityExperienceIOSTest
//
//  Created by Tony Cheung on 25/6/2023.
//

import Foundation
import Alamofire

struct NewsService {

    static let shared = NewsService()

    func getNews(completion: @escaping ([News]?, Error?) -> ()) {

        AF.request("https://newsapi.org/v2/everything?qinTitle=ios&from=2023-05-25&sortBy=publishedAt&apiKey=8815d577462a4195a64f6f50af3ada08")
            .validate(statusCode: 200..<300)
            .response { response in

                if let error = response.error {
                    completion(nil, error)
                    return
                }

                guard let data = response.data else { return }

                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601

                    let newsReponse = try decoder.decode(NewsResponse.self, from: data)

                    guard let news = newsReponse.articles else { return }

                    completion(news, nil)

                } catch let error {
                    completion(nil, error)
                }
            }
    }
}
