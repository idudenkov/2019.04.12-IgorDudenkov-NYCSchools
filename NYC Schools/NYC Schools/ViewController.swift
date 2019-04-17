//
//  ViewController.swift
//  NYC Schools
//
//  Created by Igor Dudenkov on 12/04/2019.
//  Copyright © 2019 Igor Dudenkov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let repo = NYCSchoolsSatRepository()

    override func viewDidLoad() {
        super.viewDidLoad()
        repo.fetchSat(forSchool: "01M292") { result in
            self.repo.getSat(forSchool: "01M292")
        }
    }


}

