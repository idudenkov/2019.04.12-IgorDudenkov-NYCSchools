//
//  ShoolSatViewModel.swift
//  NYC Schools
//
//  Created by Igor Dudenkov on 17/04/2019.
//  Copyright © 2019 Igor Dudenkov. All rights reserved.
//

import UIKit

protocol SchoolsSatViewModelOutput: class {
    var state: SchoolsListViewModel.State { get set }
    var displayModel: ShoolSatViewModel.DisplayModel { get set }
}

final class ShoolSatViewModel {

    enum State {
        case loading(Bool)
        case error(Error)
        case initial
    }

    struct DisplayModel {
        let schoolName: String
        let mathScore: String
        let readingScore: String
        let writingScore: String
    }

    weak var output: SchoolsSatViewModelOutput?

    private let interactor: SchoolsListInteractorProtocol
    private let school: School

    init(school: School, interactor: SchoolsListInteractorProtocol = SchoolsListInteractor()) {
        self.interactor = interactor
        self.school = school
    }

    func viewDidLoad() {
        if let sat = interactor.getSat(forSchool: school.identifer) {
            output?.displayModel = sat.toDisplauModel()
            updateSat(isSilentMode: true)
        } else {
            updateSat(isSilentMode: false)
        }
    }
}

private extension ShoolSatViewModel {

    func updateSat(isSilentMode: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        if !isSilentMode {
            output?.state = .loading(true)
        }

        interactor.fetchSat(forSchool: school.identifer) { [weak self] result in
            guard let self = self else { return }

            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if !isSilentMode {
                self.output?.state = .loading(false)
            }

            switch result {
            case .success(let sat) where sat.isEmpty == false: self.output?.displayModel = sat.first!.toDisplauModel()
            case .failure(let error): self.output?.state = .error(error)
            default: return
            }
        }
    }
}

private extension Sat {

    func toDisplauModel() -> ShoolSatViewModel.DisplayModel {
        return ShoolSatViewModel.DisplayModel(schoolName: schoolName,
                                              mathScore: "Math Score \(mathScore)",
                                              readingScore: "Reading Score \(readingScore)",
                                              writingScore: "Writing Score \(writingScore)")
    }
}
