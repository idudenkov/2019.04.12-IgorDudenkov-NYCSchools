//
//  SchoolsListViewController.swift
//  NYC Schools
//
//  Created by Igor Dudenkov on 17/04/2019.
//  Copyright © 2019 Igor Dudenkov. All rights reserved.
//

import UIKit

final class SchoolsListViewController: UITableViewController {

    var state: SchoolsListViewModel.State = .initial {
        didSet {
            switch state {
            case .loading(let isLoading) where isLoading == true:
                showActivity()
            case .loading(let isLoading) where isLoading == false:
                hideActivity()
            case .error(let error): presentAlert(error: error)
            default: return
            }
        }
    }

    var schools: [SchoolDisplayModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    private let viewModel: SchoolsListViewModel
    private var spinnerView: UIActivityIndicatorView?

    static func instantiate() -> SchoolsListViewController {
        let viewModel = SchoolsListViewModel()
        let viewController = SchoolsListViewController(viewModel: viewModel)

        return viewController
    }

    init(viewModel: SchoolsListViewModel) {
        self.viewModel = viewModel
        super.init(style: .grouped)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        bindViewModel()
        viewModel.viewDidLoad()
    }

    @available(iOS 11.0, *)
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()

        let safeAreaInsets = view.safeAreaInsets
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: safeAreaInsets.bottom, right: 0.0)
    }
}


extension SchoolsListViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.viewDidSelect(school: schools[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schools.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SchoolTableViewCell.reusable.reuseIdentifier, for: indexPath) as! SchoolTableViewCell
        cell.update(with: schools[indexPath.row])

        return cell
    }
}

extension SchoolsListViewController: SchoolsListViewModelOutput {}

private extension SchoolsListViewController {

    func setupView() {
        title = "NYC Schools"
        view.backgroundColor = .white
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200.0
        tableView.register(SchoolTableViewCell.reusable.nib, forCellReuseIdentifier: SchoolTableViewCell.reusable.reuseIdentifier)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.bounds.width, height: 1.0))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.bounds.width, height: 1.0))


        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        spinnerView = spinner
    }

    func bindViewModel() {
        viewModel.output = self
    }

    func showActivity() {
        spinnerView?.startAnimating()
    }

    func hideActivity() {
        spinnerView?.stopAnimating()
    }

    func presentAlert(error: Error) {
        let alert = UIAlertController(title: "Something wrong", message: "Error: \(error)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
}
