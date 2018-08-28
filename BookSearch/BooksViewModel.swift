//
//  BooksViewModel.swift
//  BookSearch
//
//  Created by Sreekanth Iragam Reddy on 7/18/18.
//  Copyright © 2018 Sreekanth Iragam Reddy. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

class BooksViewModel {
    var bookList: BooksList?
    func getAllBooks(searchText: String, completion: @escaping CompletionHandler) {
        BooksManager.shared.getBooks(searchText: searchText).retry(upTo: 5).timeout(after: 10, raising: .timeOutError, on: QueueScheduler.main).startWithResult { [weak self] (result) in
              print("%%%%%%%%")
            switch result {
            case .success:
                guard let list = result.value else {
                    completion(nil, false)
                    return
                }
                self?.bookList = list
                completion(list, true)
            case .failure:
                     completion(nil, false)

            }
        }
    }
}

struct BooksList: Codable {
    var books: [Books]?
    enum CodingKeys: String, CodingKey {
        case books = "items"
    }

    init(from decoder: Decoder) throws {
         let values = try decoder.container(keyedBy: CodingKeys.self)
         books = try values.decodeIfPresent([Books].self, forKey: .books)
    }

    struct Books: Codable {
        var volumeInfo : VolumeInfo?

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            volumeInfo = try values.decodeIfPresent(VolumeInfo.self, forKey: .volumeInfo)
        }

        enum CodingKeys: String, CodingKey {
            case volumeInfo
        }

        struct VolumeInfo: Codable {
            var title: String?
            var authors: [String]?
            var description : String?
            enum CodingKeys: String, CodingKey {
                case title
                case authors
                case description
            }
            init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                title = try values.decodeIfPresent(String.self, forKey: .title)
                authors = try values.decodeIfPresent([String].self, forKey: .authors)
                description = try values.decodeIfPresent(String.self, forKey: .description)
            }
        }
    }
}


