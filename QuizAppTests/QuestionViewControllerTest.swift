//
//  QuestionViewControllerTest.swift
//  QuizAppTests
//
//  Created by Septian-GLI on 04/08/21.
//

import Foundation
import XCTest
@testable import QuizApp

class QuestionViewControllerTest: XCTestCase {
    
    func test_viewDidLoad_renderQuestionHeaderText() {
        XCTAssertEqual(makeSUT(question: "Q1").headerLabel.text, "Q1")
    }
    
    func test_viewDidLoad_renderOptions() {
        XCTAssertEqual(makeSUT(options: []).tableView.numberOfRows(inSection: 0), 0)
        XCTAssertEqual(makeSUT(options: ["A1"]).tableView.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(makeSUT(options: ["A1", "A2"]).tableView.numberOfRows(inSection: 0), 2)
    }

    func test_viewDidLoad_renderOptionsText() {
        XCTAssertEqual(makeSUT(options: ["A1"]).tableView.title(at: 0), "A1")
        XCTAssertEqual(makeSUT(options: ["A1", "A2"]).tableView.title(at: 1), "A2")
    }
    
    func test_optionSelected_withTwoOptions_notifiesDelegateWithLastSelection() {
        var receiveAnswer = ""
        
        let sut = makeSUT(options: ["A1", "A2"]) { receiveAnswer = $0 }
        
        sut.tableView.select(row: 0)
        
        XCTAssertEqual(receiveAnswer, "A1")
        
        sut.tableView.select(row: 1)
        
        XCTAssertEqual(receiveAnswer, "A2")
    }
    
    func test_optionSelected_withMultipleSelectionEnabled_notifiesDelegateWithLastSelection() {
        var receiveAnswer = ""
        
        let sut = makeSUT(options: ["A1", "A2"]) { receiveAnswer = $0 }
        
        sut.tableView.select(row: 0)
        
        XCTAssertEqual(receiveAnswer, "A1")
    }
    
    // MARK: Helpers
    
    func makeSUT(question: String = "",
                 options: [String] = [],
                 selection: @escaping (String) -> Void = { _ in }) -> QuestionViewController {
        let sut = QuestionViewController(question: question, options: options, selection: selection)
        _ = sut.view
        return sut
    }
}

private extension UITableView {
    
    func cell(at row: Int) -> UITableViewCell? {
        return dataSource?.tableView(self, cellForRowAt: IndexPath(row: row, section: 0))
    }
    
    func title(at row: Int) -> String? {
        return cell(at: row)?.textLabel?.text
    }
    
    func select(row: Int) {
        delegate?.tableView?(self, didSelectRowAt: IndexPath(row: row, section: 0))
    }
}
