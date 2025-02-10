//
//  HomeViewController.swift
//  iOS_Wegg
//
//  Created by KKM on 1/29/25.
//

import UIKit

class HomeViewController: UIViewController, UIScrollViewDelegate, ToDoListViewDelegate {
    private let homeView = HomeView()
    private let toDoListView = ToDoListView()

    // MARK: - Properties
    var todoItems: [ToDoItem] = [] {
        didSet {
            toDoListView.todoItems = todoItems
        }
    }

    override func loadView() {
        self.view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primary
        homeView.scrollView.delegate = self

        homeView.headerView.viewController = self
        homeView.headerView.updateHeaderMode(isHomeMode: true)

        toDoListView.delegate = self

        // Dummy Data
        todoItems = [
            ToDoItem(name: "강남 KKM빌딩 건설"),
            ToDoItem(name: "부가티 시론 구매"),
            ToDoItem(name: "람보르기니 아벤타도르 SVJ 구매"),
            ToDoItem(name: "람보르기니 구매")
        ]
        toDoListView.todoItems = todoItems
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        homeView.handleScrollViewDidScroll(scrollView)
    }

    // MARK: - ToDoListViewDelegate
    func didAddToDoItem(text: String) {
        let newToDoItem = ToDoItem(name: text)
        todoItems.append(newToDoItem)
    }

    func didUpdateToDoItem(at index: Int, with text: String) {
        todoItems[index].name = text
    }
}
