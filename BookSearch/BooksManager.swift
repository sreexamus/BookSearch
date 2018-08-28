//
//  BooksManager.swift
//  BookSearch
//
//  Created by Sreekanth Iragam Reddy on 7/18/18.
//  Copyright © 2018 Sreekanth Iragam Reddy. All rights reserved.
//

import Foundation
import Alamofire
import ReactiveSwift
import Result

typealias CompletionHandler = (BooksList?, Bool) -> Void
enum BooksError: Error {
    case dataNotFound
    case serverError
    case timeOutError
}
class BooksManager {
    static let shared = BooksManager()
    var booksUrl = "https://www.googleapis.com/books/v1/volumes?q="
    
    func getBooks(searchText: String) -> SignalProducer<BooksList?,BooksError> {
       let finalUrl = "\(booksUrl)\(searchText)&key=\(constantKey)"

        return SignalProducer<BooksList?,BooksError>({(observer, _) in
            guard let url = URL(string: finalUrl) else {
                observer.send(error: .dataNotFound)
                return
            }
            Alamofire.request(url).responseJSON {(response) in
                switch response.result {
                case .success:
                    guard let jsonData = response.result.value as? [String: Any], let jsonDataBooks = try? JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted),
                        let booklist = try? JSONDecoder().decode(BooksList.self, from: jsonDataBooks) else {
                            return
                    }
                    print("real books are")
                    observer.send(value: booklist)
                    observer.sendCompleted()
                case .failure:
                    observer.send(error: .serverError)
                }
            }
        })
    }
}
