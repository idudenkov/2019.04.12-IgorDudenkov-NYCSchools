//
//  NYC_SchoolsTests.swift
//  NYC SchoolsTests
//
//  Created by Igor Dudenkov on 12/04/2019.
//  Copyright © 2019 Igor Dudenkov. All rights reserved.
//

import XCTest
@testable import NYC_Schools

class SchoolsListViewModelTests: XCTestCase {

    enum TestData {
        static let identifer = "1"
        static let name = "Clinton School"
        static let address = "10 East 15th Street"
        static let totalStudents = 300
    }


    let schools: [SchoolDto] = [SchoolDto(identifer: TestData.identifer,
                                          name: TestData.name,
                                          address: TestData.address,
                                          totalStudents: String(TestData.totalStudents),
                                          phoneNumber: "+44 05244322",
                                          website: "www.theclintonschool.net",
                                          latitude: "0", longitude: "0")]

    let apiService = NYCSchoolsApiServiceMock()
    let storageService = NYCSchoolsStorageServiceMock()
    var interactor: SchoolsInteractor!
    var viewModel: SchoolsListViewModel!

    override func setUp() {
        let repositoryContiner: SchoolsInteractor.RepositoryContiner
            = (NYCSchoolsRepository(apiService: apiService,
                                    storageService: storageService),
               NYCSchoolsSatRepository(apiService: NYCSchoolsSatApiServiceMock(),
                                       storageService: NYCSchoolsSatStorageServiceMock()))

        interactor = SchoolsInteractor(repositoryContiner: repositoryContiner)
        apiService.fetchSchoolsResult = .success(schools)
        storageService.schools = schools
        viewModel = SchoolsListViewModel(interactor: interactor)
    }

    func testViewModelViewDidLoadWithFetchedData() {
        let outputMock = SchoolsListViewModelOutputMock()
        viewModel.output = outputMock

        XCTAssertEqual(viewModel.output?.state, SchoolsListViewModel.State.initial)
        viewModel.viewDidLoad()

        let school = viewModel.output?.schools.first!
        XCTAssertEqual(viewModel.output?.schools.count, 1)
        XCTAssertEqual(school?.identifer, TestData.identifer)
        XCTAssertEqual(school?.name, TestData.name)
        XCTAssertEqual(school?.address, TestData.address)

        let totalStudentsString = "Total students: \(String(TestData.totalStudents))"
        XCTAssertEqual(school?.totalStudents, totalStudentsString)
    }

    func testViewModelViewDidLoadWithoutFetchedData() {
        storageService.schools = []
        let outputMock = SchoolsListViewModelOutputMock()
        viewModel.output = outputMock

        XCTAssertEqual(viewModel.output?.state, SchoolsListViewModel.State.initial)
        viewModel.viewDidLoad()
        XCTAssertEqual(viewModel.output?.state, SchoolsListViewModel.State.loading(false))

        let school = viewModel.output?.schools.first!
        XCTAssertEqual(viewModel.output?.schools.count, 1)
        XCTAssertEqual(school?.identifer, TestData.identifer)
        XCTAssertEqual(school?.name, TestData.name)
        XCTAssertEqual(school?.address, TestData.address)

        let totalStudentsString = "Total students: \(String(TestData.totalStudents))"
        XCTAssertEqual(school?.totalStudents, totalStudentsString)
    }

    func testViewModelShowSchoolStaScreen() {
        let outputMock = SchoolsListViewModelOutputMock()
        viewModel.output = outputMock
        viewModel.viewDidLoad()

        viewModel.viewDidSelect(school: outputMock.schools.first!)
        XCTAssertEqual(outputMock.shownSchool?.identifer, outputMock.schools.first?.identifer)
    }
}

final class SchoolsListViewModelOutputMock: SchoolsListViewModelOutput {
    var state: SchoolsListViewModel.State = .initial

    var schools: [SchoolDisplayModel] = []

    var shownSchool: School?
    func showSchoolStaScreen(school: School) {
        shownSchool = school
    }
}

extension SchoolsListViewModel.State: Equatable {

    public static func == (lhs: SchoolsListViewModel.State, rhs: SchoolsListViewModel.State) -> Bool {
        switch (lhs, rhs) {
        case (.initial, initial): return true
        case (let .loading(isLoadingL), let .loading(isLoadingR)) where isLoadingL == isLoadingR: return true
        case (let .error(errorL), let .error(errorR)) where errorL.localizedDescription == errorR.localizedDescription: return true
        default: return false
        }
    }
}
