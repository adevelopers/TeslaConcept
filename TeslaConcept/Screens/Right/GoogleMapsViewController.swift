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


final class GoogleMapsViewController: UIViewController {
    
    var viewModel: MapViewModel
    
    // track
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
        
        viewModel.track
            .sink(receiveValue: handleTrack)
            .store(in: &cancellables)
    }
    
    private func handleTrack(_ dto: TrackDTO) {
        locationManager?.stopUpdatingLocation()
        route?.map = nil
        route = dto.polyline
        route?.map = mapView
        addMarker(position: dto.lastCoordinate)
        if let routePath = dto.polyline.path {
            mapView.animate(with: GMSCameraUpdate.fit(GMSCoordinateBounds(path: routePath)))
        }
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
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.delegate = self
    }
    
    private func didTapOnCurrentLocation() {
        print("current location")
        locationManager?.requestLocation()
    }
    
    private func didTapOnTrackLocation() {
        print("startUpdatingLocation")
        locationManager?.startUpdatingLocation()
    }
    
    private func didTapOnStartTrack() {
        print("Начать трек")
        locationManager?.startUpdatingLocation()
        mapStartNewTrack()
        viewModel.startTrack()
    }
    
    private func mapStartNewTrack() {
        route?.map = nil
        route = GMSPolyline()
        route?.strokeColor = UIColor.orange
        route?.strokeWidth = 6
        routePath = GMSMutablePath()
        route?.map = mapView
    }
    
    private func didTapOnStopTrack() {
        locationManager?.stopUpdatingLocation()
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
            viewModel.speed.send(location.speed)
            print("position: ", location)
            viewModel.trackCoordinates.send(location.coordinate)
            routePath?.add(location.coordinate)
            // Обновляем путь у линии маршрута путём повторного присвоения
            route?.path = routePath

            mapView.animate(toLocation: location.coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

