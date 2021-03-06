//
//  ShoolSatViewController.swift
//  NYC Schools
//
//  Created by Igor Dudenkov on 17/04/2019.
//  Copyright © 2019 Igor Dudenkov. All rights reserved.
//

import UIKit
import MapKit

final class ShoolSatViewController: UIViewController {

    var state: SchoolsListViewModel.State = .initial{
        didSet {
            switch state {
            case .loading(let isLoading) where isLoading == true: spinerView.startAnimating()
            case .loading(let isLoading) where isLoading == false: spinerView.stopAnimating()
            case .error(let error): presentAlert(error: error)
            default: return
            }
        }
    }

    var displayModel: ShoolSatViewModel.DisplayModel = .dummy {
        didSet {
            updateView(displayModel: displayModel)
        }
    }

    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var spinerView: UIActivityIndicatorView!
    @IBOutlet private weak var shoolNameLable: UILabel!
    @IBOutlet private weak var mathScoreLable: UILabel!
    @IBOutlet private weak var readingScoreLabel: UILabel!
    @IBOutlet private weak var writingScoreLabel: UILabel!

    private var viewModel: ShoolSatViewModel!

    // MARK: View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        bindViewModel()
        viewModel.viewDidLoad()
    }

    static func instantiate(viewModel: ShoolSatViewModel) -> ShoolSatViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShoolSatViewController") as! ShoolSatViewController
        viewController.viewModel = viewModel
        return viewController
    }
}

extension ShoolSatViewController: SchoolsSatViewModelOutput {}

private extension ShoolSatViewController {

    func updateView(displayModel: ShoolSatViewModel.DisplayModel) {
        shoolNameLable.text = displayModel.schoolName
        mathScoreLable.text = displayModel.mathScore
        readingScoreLabel.text = displayModel.readingScore
        writingScoreLabel.text = displayModel.writingScore

        if let latitude = displayModel.location?.latitude, let longitude = displayModel.location?.longitude {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            mapView.addAnnotation(annotation)
        }
    }

    func setupView() {
        let initialLocation = CLLocationCoordinate2D(latitude: 40.730610, longitude: -73.935242)
        let coordinateRegion = MKCoordinateRegion(center: initialLocation, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        mapView.setRegion(coordinateRegion, animated: true)
    }

    func bindViewModel() {
        viewModel.output = self
    }
}

extension ShoolSatViewModel.DisplayModel {

    static let dummy = ShoolSatViewModel.DisplayModel(schoolName: "", mathScore: "", readingScore: "", writingScore: "", location: nil)
}
