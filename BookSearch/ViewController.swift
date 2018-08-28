//
//  ViewController.swift
//  BookSearch
//
//  Created by Sreekanth Iragam Reddy on 7/18/18.
//  Copyright © 2018 Sreekanth Iragam Reddy. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class ViewController: UIViewController {
    @IBOutlet weak var noResultsView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var bookViewModel: BooksViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        bookViewModel = BooksViewModel()
        searchBar.reactive.continuousTextValues.observeValues {[weak self](str) in
            print("continuous react values")
            print(str)
            if let str = str {
               self?.searchBooks(searchText: str)
            }
        }

        searchBar.reactive.searchButtonClicked.observeValues { [weak self] _ in
            self?.searchBar.resignFirstResponder()
        }

        searchBar.reactive.textDidEndEditing.observeValues { [weak self] _ in
            self?.searchBar.resignFirstResponder()
        }


        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func searchBooks(searchText: String) {
        bookViewModel?.getAllBooks(searchText: searchText) { [weak self](booksList, isSuccess) in
            if isSuccess {

                if let booksCount = booksList?.books?.count, booksCount > 0 {
                    self?.view.bringSubview(toFront: (self?.tableView)!)
                    self?.view.layoutIfNeeded()
                   // self?.tableView.isHidden = false
                } else {
                    self?.view.bringSubview(toFront: (self?.noResultsView)!)

                    self?.view.layoutIfNeeded()
                    //self?.tableView.isHidden = true
                    //self?.noResultsView.isHidden = false
                }
                self?.tableView.reloadData()
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return bookViewModel?.bookList?.books?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = bookViewModel?.bookList?.books?[indexPath.row].volumeInfo?.title
        print("descccc")
        print(bookViewModel?.bookList?.books?[indexPath.row].volumeInfo?.description)
        cell.detailTextLabel?.text = bookViewModel?.bookList?.books?[indexPath.row].volumeInfo?.description
        return cell
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }

}
