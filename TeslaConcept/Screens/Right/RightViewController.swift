//
//  ViewController.swift
//  TeslaConcept
//
//  Created by Kirill Khudiakov on 22.09.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit
import MapKit
import VanillaConstraints


extension MKMapView.CameraZoomRange {
    static let standard = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 100,
                                                    maxCenterCoordinateDistance: 500_000)
}

class RightViewController: UIViewController {

    
    private lazy var mapView: MKMapView = {
       let map = MKMapView()
       return map
    }()
    
    let viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDarkTheme()
        
        mapView
            .add(to: view)
            .pinToEdges()
        
        
        let center = viewModel.moscowCity
        mapView.setCenter(viewModel.moscowCity, animated: true)
        mapView.setCameraZoomRange(.standard, animated: true)
        
        mapView.addAnnotations([
            makeAnnotationMarker(latitude: viewModel.point2.latitude, longiture: viewModel.point2.longitude, title: "One"),
            makeAnnotationMarker(latitude: center.latitude, longiture: center.longitude, title: "Two")
        ])
        
    }

    
    private func makeAnnotationMarker(latitude: Double, longiture: Double, title: String? = nil) -> MKPointAnnotation {
        let point = CLLocationCoordinate2D(latitude: CLLocationDegrees(integerLiteral: latitude),
                                           longitude: CLLocationDegrees(integerLiteral: longiture))
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = point
        pointAnnotation.title = title
        
        return pointAnnotation
    }

}

