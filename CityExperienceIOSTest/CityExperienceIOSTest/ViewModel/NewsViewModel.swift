//
//  NewsViewModel.swift
//  CityExperienceIOSTest
//
//  Created by Tony Cheung on 25/6/2023.
//

import Foundation

enum NewsViewModelError:Error {
    case noSearchWord
}

class NewsViewModel {

    /// Flag that indicate the api is calling.
    /// It would turn true if it is calling an api.
    /// The purpose is to block another api call to prevent multiple calling.
    var isLoading = false

    /// Flag that indicate if more data can be called.
    /// It would turn false if the data get from api is less than pagesize.
    /// The purpose is to prevent unlimted api calling.
    private(set) var canLoadMore = true

    /// Indicate how many result will get from the api.
    /// Will be passed as parameter at api call.
    private let pageSize = 20

    /// Indicate which page will get from the api.
    /// Will be passed as parameter at api call.
    private(set) var page = 1

    /// Indicate what kind of word wanna search in the api.
    /// Will be passed as parameter at api call.
    private(set) var searchWord:String?

    /// Store the news returned by the api.
    /// If this has amendment, it would trigger did get news as callback.
    private(set) var news:[News] = [] {
        didSet {
            self.didGetNews()
        }
    }

    /// Store the error returned by the api.
    /// If it recieve any error from api, it would trigger fail network call back.
    private(set) var error:Error? {
        didSet {
            if error != nil {
                didFailTheNetworkCall()
            }
        }
    }

    /// Store the validation error
    private(set) var validationError:Error?

    /// Store the call back after getting news.
    var didGetNews: (() -> ()) = {}

    /// Store the call back after failing the network call.
    var didFailTheNetworkCall: (() -> ()) = {}

    /// This would be triggered if the user pull to refresh.
    /// It would reset the news
    /// and get the first page of current search word
    /// If there is another api calling , it would stop calling to prevent duplicate records.
    /// If the api get records, it would set the page number 1.
    /// If the count is less than the page size, that means it won't have next page and set can load more to false to prevent api calling.
    func refreshNews() {

        resetError()

        guard let searchWord = searchWord else {
            self.validationError = NewsViewModelError.noSearchWord
            didFailTheNetworkCall()
            return
        }

        canLoadMore = true
        news = []
        
        isLoading = true

        NewsService.shared.getNews(searchWord: searchWord,
                                   page: 1,
                                   pageSize: pageSize,
                                   completion: { news, error in

            self.isLoading = false

            if error != nil {
                self.setError(error!)
                return
            }

            guard let news = news else { return }

            self.page = 1

            print("News count is: " + String(news.count))

            if news.count < self.pageSize {
                self.canLoadMore = false
            }

            self.appendNews(news)
        })
    }

    /// This would be triggered if the user update the search word
    /// It would reset the news
    /// and get the first page of the new search word
    /// If the searchword count is zero, it would just clear the news array
    /// If there is another api calling , it would stop calling to prevent duplicate records.
    /// If the api get records, it would set the page number 1.
    /// If the count is less than the page size, that means it won't have next page and set can load more to false to prevent api calling.
    func updateSearchWord(searchWord:String) {

        resetError()

        if searchWord.count == 0 {
            news = []
            self.validationError = NewsViewModelError.noSearchWord
            return
        }

        canLoadMore = true
        news = []
        self.searchWord = searchWord

        isLoading = true

        NewsService.shared.getNews(searchWord: searchWord,
                                   page: 1,
                                   pageSize: pageSize,
                                   completion: { news, error in

            self.isLoading = false

            if error != nil {
                self.setError(error!)
                return
            }

            guard let news = news else { return }

            self.page = 1

            print("News count is: " + String(news.count))

            if news.count < self.pageSize {
                self.canLoadMore = false
            }

            self.appendNews(news)
        })
    }

    /// This would be triggered if the user scroll down to 80% of the content
    /// It would load more news
    /// If there is another api calling , it would stop calling to prevent duplicate records.
    /// If the api get records, it would increase the page number.
    /// If the count is less than the page size, that means it won't have next page and set can load more to false to prevent api calling.
    func loadMoreNews() {

        resetError()

        guard let searchWord = searchWord else {
            self.validationError = NewsViewModelError.noSearchWord
            return
        }

        if searchWord.count == 0 {
            self.validationError = NewsViewModelError.noSearchWord
            return
        }

        if isLoading || !canLoadMore { return }

        isLoading = true

        print("Load more")

        NewsService.shared.getNews(searchWord: searchWord,
                                   page: page + 1,
                                   pageSize: pageSize,
                                   completion: { news, error in

            self.isLoading = false

            if error != nil {
                self.setError(error!)
                return
            }

            guard let news = news else { return }

            self.page = self.page + 1

            print("News count is: " + String(news.count))

            if news.count < self.pageSize {
                self.canLoadMore = false
            }

            self.appendNews(news)
        })
    }

    func setError(_ error: Error) {

        self.error = error
    }

    func appendNews(_ news:[News]) {

        self.news.append(contentsOf: news)
    }

    func resetError() {
        error = nil
        validationError = nil
    }
}
