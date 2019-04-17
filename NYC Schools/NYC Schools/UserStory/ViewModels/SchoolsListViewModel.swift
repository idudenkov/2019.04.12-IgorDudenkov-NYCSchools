//
//  SchoolsListViewModel.swift
//  NYC Schools
//
//  Created by Igor Dudenkov on 17/04/2019.
//  Copyright © 2019 Igor Dudenkov. All rights reserved.
//

import Foundation
import UIKit

protocol SchoolsListViewModelOutput: class {
    var state: SchoolsListViewModel.State { get set }
    var schools: [SchoolDisplayModel] { get set }

    func showSchoolStaScreen(school: School)
}

final class SchoolsListViewModel {

    enum State {
        case loading(Bool)
        case error(Error)
        case initial
    }

    weak var output: SchoolsListViewModelOutput?

    private let interactor: SchoolsListInteractorProtocol
    private var schools = [String: School]()

    init(interactor: SchoolsListInteractorProtocol = SchoolsListInteractor()) {
        self.interactor = interactor
    }

    func viewDidLoad() {
        let schools = procces(schools: interactor.schools)

        if schools.isEmpty {
            updateSchools(isSilentMode: false)
        } else {
            output?.schools = schools
            updateSchools(isSilentMode: true)
        }
    }

    func viewDidSelect(school: SchoolDisplayModel) {
        guard let school = schools[school.identifer] else { return }
        output?.showSchoolStaScreen(school: school)
    }
}

private extension SchoolsListViewModel {

    func updateSchools(isSilentMode: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        if !isSilentMode {
            output?.state = .loading(true)
        }

        interactor.fetchSchools { [weak self] result in
            guard let self = self else { return }

            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if !isSilentMode {
                self.output?.state = .loading(false)
            }

            switch result {
            case .success(let schools): self.output?.schools = self.procces(schools: schools)
            case .failure(let error): self.output?.state = .error(error)
            }
        }
    }

    func procces(schools: [School]) -> [SchoolDisplayModel] {
        self.schools = schools.reduce([String: School]()) { (dict, school) -> [String: School] in
            var dict = dict
            dict[school.identifer] = school
            return dict
        }
        return schools.sorted(by: { $0.name < $1.name }).map { $0.toDisplayModel() }
    }
}

private extension School {

    func toDisplayModel() -> SchoolDisplayModel {
        // todo: can be localised
        let totalStudentsString = "Total students: \(String(totalStudents))"
        return SchoolDisplayModel(identifer: identifer, name: name, address: address, totalStudents: totalStudentsString)
    }
}
