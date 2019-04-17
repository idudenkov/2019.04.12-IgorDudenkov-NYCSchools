//
//  SchoolTableViewCell.swift
//  NYC Schools
//
//  Created by Igor Dudenkov on 17/04/2019.
//  Copyright © 2019 Igor Dudenkov. All rights reserved.
//

import UIKit

typealias SchoolDisplayModel = SchoolTableViewCell.Model

typealias Reusable = (nib: UINib, reuseIdentifier: String)

final class SchoolTableViewCell: UITableViewCell {

    struct Model {
        let identifer: String
        let name: String
        let address: String
        let totalStudents: String
    }

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var totalStudentsLabel: UILabel!
    @IBOutlet private weak var adressLabel: UILabel!

    static let reusable: Reusable = (UINib(nibName: "SchoolTableViewCell", bundle: nil), "SchoolTableViewCell")

    func update(with model: Model) {
        titleLabel.text = model.name
        totalStudentsLabel.text = model.totalStudents
        adressLabel.text = model.address
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        totalStudentsLabel.text = nil
        adressLabel.text = nil
    }
}
