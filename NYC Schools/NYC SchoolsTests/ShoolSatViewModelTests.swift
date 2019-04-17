//
//  ShoolSatViewModelTests.swift
//  NYC SchoolsTests
//
//  Created by Igor Dudenkov on 17/04/2019.
//  Copyright © 2019 Igor Dudenkov. All rights reserved.
//

import XCTest
@testable import NYC_Schools

class ShoolSatViewModelTests: XCTestCase {

    enum TestData {
        static let identifer = "1"
        static let name = "Clinton School"
        static let mathScore = 200
        static let readingScore = 400
        static let writingScore = 500
    }

    let school: School = School(identifer: TestData.identifer,
                                name: TestData.name,
                                address: "",
                                totalStudents: 300,
                                phoneNumber: "",
                                website: "",
                                location: .init(latitude: 0, longitude: 0))

    let sat = SatDto(identifer: TestData.identifer,
                     schoolName: TestData.name,
                     mathScore: String(TestData.mathScore),
                     readingScore: String(TestData.readingScore),
                     writingScore: String(TestData.writingScore))

    let apiService = NYCSchoolsSatApiServiceMock()
    let storageService = NYCSchoolsSatStorageServiceMock()
    var interactor: SchoolsInteractor!
    var viewModel: ShoolSatViewModel!

    override func setUp() {
        let repositoryContiner: SchoolsInteractor.RepositoryContiner
            = (NYCSchoolsRepository(apiService: NYCSchoolsApiServiceMock(),
                                    storageService: NYCSchoolsStorageServiceMock()),
               NYCSchoolsSatRepository(apiService: apiService,
                                       storageService: storageService))

        interactor = SchoolsInteractor(repositoryContiner: repositoryContiner)
        apiService.fetchSatResult = .success([sat])
        storageService.sat = sat
        viewModel = ShoolSatViewModel(school: school, interactor: interactor)
    }

    func testViewModelViewDidLoadWithFetchedData() {
        let outputMock = SchoolsSatViewModelOutputMock()
        viewModel.output = outputMock

        XCTAssertEqual(viewModel.output?.state, SchoolsListViewModel.State.initial)
        viewModel.viewDidLoad()

        let displayModel = outputMock.displayModel
        XCTAssertEqual(displayModel.schoolName, TestData.name)

        let mathScore = "Math Score \(TestData.mathScore)"
        XCTAssertEqual(displayModel.mathScore, mathScore)

        let readingScore = "Reading Score \(TestData.readingScore)"
        XCTAssertEqual(displayModel.readingScore, readingScore)

        let writingScore = "Writing Score \(TestData.writingScore)"
        XCTAssertEqual(displayModel.writingScore, writingScore)
    }

    func testViewModelViewDidLoadWithoutFetchedData() {
        storageService.sat = nil
        let outputMock = SchoolsSatViewModelOutputMock()
        viewModel.output = outputMock

        XCTAssertEqual(viewModel.output?.state, SchoolsListViewModel.State.initial)
        viewModel.viewDidLoad()
        XCTAssertEqual(viewModel.output?.state, SchoolsListViewModel.State.loading(false))

        let displayModel = outputMock.displayModel
        XCTAssertEqual(displayModel.schoolName, TestData.name)

        let mathScore = "Math Score \(TestData.mathScore)"
        XCTAssertEqual(displayModel.mathScore, mathScore)

        let readingScore = "Reading Score \(TestData.readingScore)"
        XCTAssertEqual(displayModel.readingScore, readingScore)

        let writingScore = "Writing Score \(TestData.writingScore)"
        XCTAssertEqual(displayModel.writingScore, writingScore)
    }
}

final class SchoolsSatViewModelOutputMock: SchoolsSatViewModelOutput {
    var state: SchoolsListViewModel.State = .initial
    var displayModel: ShoolSatViewModel.DisplayModel = .dummy
}

extension ShoolSatViewModel.State: Equatable {

    public static func == (lhs: ShoolSatViewModel.State, rhs: ShoolSatViewModel.State) -> Bool {
        switch (lhs, rhs) {
        case (.initial, initial): return true
        case (let .loading(isLoadingL), let .loading(isLoadingR)) where isLoadingL == isLoadingR: return true
        case (let .error(errorL), let .error(errorR)) where errorL.localizedDescription == errorR.localizedDescription: return true
        default: return false
        }
    }
}
