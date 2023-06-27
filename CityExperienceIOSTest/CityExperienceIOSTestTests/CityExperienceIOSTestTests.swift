//
//  CityExperienceIOSTestTests.swift
//  CityExperienceIOSTestTests
//
//  Created by Tony Cheung on 27/6/2023.
//

import XCTest

final class CityExperienceIOSTestTests: XCTestCase {

    func testNewsViewModelValidation() {

        let newsViewModel = NewsViewModel()

        newsViewModel.refreshNews()

        if let error = newsViewModel.validationError as? NewsViewModelError {
            XCTAssertTrue(error == NewsViewModelError.noSearchWord, "Refreshing News without searchword throws error")
        } else {
            XCTAssertTrue(false, "Refreshing News without searchword does not throw error")
        }

        newsViewModel.updateSearchWord(searchWord: "")

        if let error = newsViewModel.validationError as? NewsViewModelError {
            XCTAssertTrue(error == NewsViewModelError.noSearchWord, "Updating News without searchword throws error")
        } else {
            XCTAssertTrue(false, "Updating News without searchword does not throw error")
        }

        newsViewModel.loadMoreNews()

        if let error = newsViewModel.validationError as? NewsViewModelError {
            XCTAssertTrue(error == NewsViewModelError.noSearchWord, "Loading News without searchword throws error")
        } else {
            XCTAssertTrue(false, "Loading News without searchword does not throw error")
        }
    }

    func testUpdateSearchWord() {

        let newsViewModel = NewsViewModel()
        let expectation = XCTestExpectation(description: "Searching for news expectation")

        var arrayIsCleared = false
        newsViewModel.didGetNews = {

            print("Inside the closure")
            // The first time callback is to clear the array
            if !arrayIsCleared {
                arrayIsCleared = true
                print("Cleared")
                return
            }

            print("Checking")
            XCTAssertTrue(newsViewModel.isLoading == false, "isLoading is false after loading the data")
            XCTAssertTrue(newsViewModel.page == 1, "Page is one after loading the data")

            if newsViewModel.news.count < 20 {
                XCTAssertTrue(newsViewModel.canLoadMore == false, "can load more is false if the count is less than page limit")
            } else {
                XCTAssertTrue(newsViewModel.canLoadMore == true, "can load more is true if the count is equal 20")
            }
            print(newsViewModel.news.count)

            XCTAssertTrue(newsViewModel.news.count > 0, "search word can load data")
            print("End Checking")
            expectation.fulfill()
        }
        newsViewModel.updateSearchWord(searchWord: "i")

        wait(for: [expectation], timeout: 10.0)
    }

    func testLoadMoreAndRefresh() {

        let newsViewModel = NewsViewModel()
        let searchingException = XCTestExpectation(description: "Searching for news expectation")
        let loadMoreException = XCTestExpectation(description: "Load more news expectation")
        let refreshException = XCTestExpectation(description: "Refresh news expectation")


        var arrayIsCleared = false

        newsViewModel.didGetNews = {

            print("Inside the closure")
            // The first time callback is to clear the array
            if !arrayIsCleared {
                arrayIsCleared = true
                print("Cleared")
                return
            }

            print("Checking")
            XCTAssertTrue(newsViewModel.isLoading == false, "isLoading is false after loading the data")
            XCTAssertTrue(newsViewModel.page == 1, "Page is one after loading the data")

            if newsViewModel.news.count < 20 {
                XCTAssertTrue(newsViewModel.canLoadMore == false, "can load more is false if the count is less than page limit")
            } else {
                XCTAssertTrue(newsViewModel.canLoadMore == true, "can load more is true if the count is equal 20")
            }
            print(newsViewModel.news.count)

            XCTAssertTrue(newsViewModel.news.count > 0, "search word can load data")
            print("End Checking")

            searchingException.fulfill()
        }

        newsViewModel.updateSearchWord(searchWord: "iO")

        wait(for: [searchingException], timeout: 5.0)

        XCTAssertTrue(newsViewModel.canLoadMore, "cannot do load more test")

        newsViewModel.didGetNews = {

            print("Inside the closure")

            print("Checking")
            XCTAssertTrue(newsViewModel.isLoading == false, "isLoading is false after loading the data")
            XCTAssertTrue(newsViewModel.page == 2, "Page is two after loading the data")
            XCTAssertTrue(newsViewModel.news.count > 20, "search word can load data")
            print("End Checking")

            loadMoreException.fulfill()
        }

        newsViewModel.loadMoreNews()

        wait(for: [loadMoreException], timeout: 5.0)

        arrayIsCleared = false
        newsViewModel.didGetNews = {
            print("Inside the closure")
            // The first time callback is to clear the array
            if !arrayIsCleared {
                arrayIsCleared = true
                print("Cleared")
                return
            }

            print("Checking")
            XCTAssertTrue(newsViewModel.isLoading == false, "isLoading is false after refreshing the data")
            XCTAssertTrue(newsViewModel.page == 1, "Page is one after refreshing the data")

            if newsViewModel.news.count < 20 {
                XCTAssertTrue(newsViewModel.canLoadMore == false, "can load more is false if the count is less than page limit")
            } else {
                XCTAssertTrue(newsViewModel.canLoadMore == true, "can load more is true if the count is equal 20")
            }
            print(newsViewModel.news.count)
            XCTAssertTrue(newsViewModel.news.count == 20, "Refresh count is 20")

            XCTAssertTrue(newsViewModel.news.count > 0, "Refresh can load data")
            print("End Checking")

            refreshException.fulfill()
        }

        newsViewModel.refreshNews()

        wait(for: [refreshException], timeout: 5.0)
    }

}
