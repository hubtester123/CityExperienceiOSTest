//
//  DummyNewsViewModel.swift
//  CityExperienceIOSTest
//
//  Created by Tony Cheung on 27/6/2023.
//

import Foundation

class DummyNewsViewModel:NewsViewModel {

    let responseString = """
    {"status":"ok","totalResults":0,"articles":[{"title":"La duración de la batería del iPhone 13 se ve relativamente mermada tras actualizar a iOS 16.5.1","author":"iPhoneros","source":{"Id":null,"Name":"Iphoneros.com"},"publishedAt":"2023-06-24T22:25:10Z","url":"https://iphoneros.com/93441/duracion-bateria-tras-actualizar-a-ios-16-5-1","content": "Lately, I’ve been noticing how my sentences have a tendency to keep going when I write them onscreen. This goes for concentrated writing as well as correspondence. (Twain probably believed that correspondence, in an ideal world, also demands concentration. But he never used email.) Last week I caught myself packing four conjunctions into a three-line sentence in an email. That’s inexcusable. Since then, I have tried to eschew conjunctions whenever possible. Gone are the commas, the and’s, but’s, and so’s; in are staccato declaratives. Better to read like bad Hemingway than bad Faulkner."},{"title":"В iOS 17 появится функция для защиты глаз от близорукости","author":"Finance.UA","source":{"Id":null,"Name":"Finance.ua"},"publishedAt":"2023-06-24T21:48:00Z","url":"https://news.finance.ua/ru/v-ios-17-poyavitsya-funkciya-dlya-zashhity-glaz-ot-blizorukosti"},{"title":"[Android, iOS] Free - 12 Month Subscription to TomTom Go Navigation Service (Was $22.99) @ TomTom","author":"Scrooge McDeal","source":{"Id":null,"Name":"Ozbargain.com.au"},"publishedAt":"2023-06-24T21:30:03Z","url":"https://www.ozbargain.com.au/node/783712"},{"title":"แนะนำ 10 เกมมือถืออัปเดตใหม่น่าเล่น ประจำเดือนมิถุนายน ทั้งบน Android, iOS รับรองสนุกเกินห้ามใจ","author":"RealTummie","source":{"Id":null,"Name":"Droidsans.com"},"publishedAt":"2023-06-24T21:09:44Z","url":"https://droidsans.com/recommend-10-android-ios-new-games-update/"}]}
    """

    func getDummyNews() {

        if isLoading { return }

        isLoading = true

        NewsService.shared.getDummyNews(completion: { news, error in

            self.isLoading = false

            if error != nil {
                self.setError(error!)
                return
            }

            guard let news = news else { return }

            self.appendNews(news)
        })
    }

    func getNews() {

        if let jsonData = responseString.data(using: .utf8) {

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601

                let newsReponse = try decoder.decode(NewsResponse.self, from: jsonData)

                guard let news = newsReponse.articles else { return }

                self.appendNews(news)

            } catch let error {
            }
        }
    }
}
