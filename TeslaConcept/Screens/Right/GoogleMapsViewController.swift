//
//  GoogleMapsViewController.swift
//  TeslaConcept
//
//  Created by Kirill Khudiakov on 25.09.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit
import VanillaConstraints
import GoogleMaps
import CoreLocation
import Combine


class MapViewModel {
    let coordinate = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
    let podolsk = CLLocationCoordinate2D(latitude: 55.426022, longitude: 37.531850)
    
    let didTapTrackLocation: PassthroughSubject<Void, Never>
    let didTapCurrentLocation: PassthroughSubject<Void, Never>
    let didTapStartTrack: PassthroughSubject<Void, Never>
    let didTapStopTrack: PassthroughSubject<Void, Never>
    
    init(didTapTrack: PassthroughSubject<Void, Never>,
         didTapCurrent: PassthroughSubject<Void, Never>,
         didTapStartTrack: PassthroughSubject<Void, Never>,
         didTapStopTrack: PassthroughSubject<Void, Never>
    ) {
        self.didTapTrackLocation = didTapTrack
        self.didTapCurrentLocation = didTapCurrent
        self.didTapStartTrack = didTapStartTrack
        self.didTapStopTrack = didTapStopTrack
    }
    
}


final class GoogleMapsViewController: UIViewController {
    
    var viewModel: MapViewModel
    
    var route: GMSPolyline?
    var routePath: GMSMutablePath?
    
    private lazy var mapView: GMSMapView = {
        let view = GMSMapView()
        return view
    }()
    
    private lazy var camera: GMSCameraPosition = {
        return GMSCameraPosition(latitude: viewModel.podolsk.latitude,
                                 longitude: viewModel.podolsk.longitude,
                                 zoom: 16)
    }()
    
    private lazy var label: UILabel = {
        UILabel()
    }()
    
    
    private var locationManager: CLLocationManager?
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var cancellables = Set<AnyCancellable>()
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDarkTheme()
        label.text = "View"
        setupUI()
        configureMapStyle()
        setupLocationManager()
        setupSubscriptions()
        
        setupRoute()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        label
            .add(to: view)
            .center()
        
        mapView.add(to: view)
            .pinToEdges(withInsets: .init(top: 8, left: 8, bottom: 8, right: 8))
        
        mapView.settings.compassButton = true
        mapView.setMinZoom(1, maxZoom: 50)
        mapView.camera = camera
        mapView.delegate = self
    }
    
    private func setupSubscriptions() {
        viewModel.didTapTrackLocation
            .sink(receiveValue: didTapOnTrackLocation)
            .store(in: &cancellables)
        
        viewModel.didTapCurrentLocation
            .sink(receiveValue: didTapOnCurrentLocation)
            .store(in: &cancellables)
        
        viewModel.didTapStartTrack
            .sink(receiveValue: didTapOnStartTrack)
            .store(in: &cancellables)
        
        viewModel.didTapStopTrack
            .sink(receiveValue: didTapOnStopTrack)
            .store(in: &cancellables)
    }
    
    private func setupRoute() {
        route?.map = nil
        route = GMSPolyline()
        route?.strokeColor = UIColor.orange
        route?.strokeWidth = 6
        routePath = GMSMutablePath()
        route?.map = mapView
    }
    
    private func configureMapStyle() {
        if
            let jsonStyleUrl = Bundle.main.url(forResource: "mapStyleConfig", withExtension: "json"),
            let mapStyle = try? GMSMapStyle(contentsOfFileURL: jsonStyleUrl) {
            mapView.mapStyle = mapStyle
        }
    }
    
    private func addMarker(position: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: position)
        marker.map = mapView
    }
    
    // MARK: Location
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
    }
    
    private func didTapOnCurrentLocation() {
        print("current location")
        locationManager?.requestLocation()
    }
    
    private func didTapOnTrackLocation() {
        print("track location")
        

        locationManager?.startUpdatingLocation()
    }
    
    private func didTapOnStartTrack() {
        print("Начать трек")
    }
    
    private func didTapOnStopTrack() {
        print("Закончить трек")
    }
    
}

extension GoogleMapsViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("📍 ", coordinate)
    }
    
}

extension GoogleMapsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            print("position: ", location)
            routePath?.add(location.coordinate)
            // Обновляем путь у линии маршрута путём повторного присвоения
            route?.path = routePath

//            let marker = GMSMarker(position: location.coordinate)
//            marker.map = mapView
            mapView.animate(toLocation: location.coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

