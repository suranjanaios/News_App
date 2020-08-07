//
//  condeNastTestTests.swift
//  condeNastTestTests
//
//  Created by suranjana on 31/07/20.
//  Copyright © 2020 suranjana. All rights reserved.
//

import XCTest
@testable import condeNastTest

class condeNastTestTests: XCTestCase {
var viewControllerUnderTest: UITableViewController?
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.viewControllerUnderTest = storyboard.instantiateViewController(withIdentifier: "listing") as? UITableViewController
        
        self.viewControllerUnderTest?.loadView()
        self.viewControllerUnderTest?.viewDidLoad()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
// MARK: API call  testing with json mock 
    func testWebService(){
        let bundle = Bundle.main
        guard let path = bundle.path(forResource: "Mock", ofType: "json") else { return  }
        let content:String = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
        let jsonData = Data(content.utf8)
       
        webServiceManager.shared.makeServiceCall(jsonData: jsonData) { news in
            
            let authorStr = news?[0].author
           // let authorStr1 = news[1].author // enable to generate fail case
            XCTAssertEqual("Cole Petersen", authorStr)
            //XCTAssertEqual("Peter", authorStr1)// enable to generate fail case
           
        }
       
    }

    func testHasATableView() {
        XCTAssertNotNil(viewControllerUnderTest?.tableView)
    }
   
    func testTableViewHasDelegate() {
        XCTAssertNotNil(viewControllerUnderTest?.tableView.delegate)
    }
    
    func testTableViewConfromsToTableViewDelegateProtocol() {
        XCTAssertTrue(((viewControllerUnderTest?.conforms(to: UITableViewDelegate.self)) != nil))
        XCTAssertTrue(((viewControllerUnderTest?.responds(to: #selector(viewControllerUnderTest?.tableView(_:didSelectRowAt:)))) != nil))
    }
    
    func testTableViewHasDataSource() {
        XCTAssertNotNil(viewControllerUnderTest?.tableView.dataSource)
    }
    func testTableViewConformsToTableViewDataSourceProtocol() {
        XCTAssertTrue(((viewControllerUnderTest?.conforms(to: UITableViewDataSource.self)) != nil))
        XCTAssertTrue(((viewControllerUnderTest?.responds(to: #selector(viewControllerUnderTest?.numberOfSections(in:)))) != nil))
        XCTAssertTrue(((viewControllerUnderTest?.responds(to: #selector(viewControllerUnderTest?.tableView(_:numberOfRowsInSection:)))) != nil))
        XCTAssertTrue(((viewControllerUnderTest?.responds(to: #selector(viewControllerUnderTest?.tableView(_:cellForRowAt:)))) != nil))
    }

    func testTableViewCellHasReuseIdentifier() {
        let cell = viewControllerUnderTest?.tableView(viewControllerUnderTest!.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? TableViewCell
        let actualReuseIdentifer = cell?.reuseIdentifier
        let expectedReuseIdentifier = "identifier"
        XCTAssertEqual(actualReuseIdentifer, expectedReuseIdentifier)
    }
}
