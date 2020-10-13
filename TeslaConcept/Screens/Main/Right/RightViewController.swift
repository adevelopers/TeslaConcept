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
import RxSwift


final class RightViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private(set) var viewModel: MapViewModel
    
    private var store: Store = {
        return Store.shared
    }()
    
    // track
    private var route: GMSPolyline?
    private var routePath: GMSMutablePath?
    //
    
    private lazy var musicTracksButton: UIButton = {
        let button = PrimaryButton()
        button.backgroundColor = UIColor(named: "backgroundPanel")
        button.setTitle("Music tracks", for: .normal)
        button.addTarget(self, action: #selector(didTapMusicTracks), for: .touchUpInside)
        return button
    }()
    
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
    
    private lazy var locationManager: LocationManager = {
        return LocationManager.shared
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private var cancellables = Set<AnyCancellable>()
    
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
        
        musicTracksButton
            .add(to: view)
            .top(to: \.topAnchor, constant: 16)
            .left(to: \.leftAnchor, constant: 16)
            .height(48)
            
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
        
     
        LocationManager.shared
            .location
            .subscribe(onNext: handleLocation)
            .disposed(by: disposeBag)
        
    }
    
    @objc
    private func didTapMusicTracks(sender: UIButton) {
        viewModel.didTapMusicTracks.send()
    }
    
    private func handleTrack(_ dto: TrackDTO) {
        locationManager.stopUpdatingLocation()
        route?.map = nil
        route = dto.polyline
        route?.map = mapView
        addMarker(position: dto.lastCoordinate)
        if let routePath = dto.polyline.path {
            mapView.animate(with: GMSCameraUpdate.fit(GMSCoordinateBounds(path: routePath)))
        }
    }
    
    private func handleLocation(_ location: CLLocation?) {
        if let location = location {
            switch store.state.value {
            case .tracking:
                viewModel.speed.send(location.speed)
                viewModel.trackCoordinates.send(location.coordinate)
                routePath?.add(location.coordinate)
                // Обновляем путь у линии маршрута путём повторного присвоения
                route?.path = routePath
            case .cuttentLocation:
                addMarker(position: location.coordinate)
            default:
                ()
            }
            mapView.animate(toLocation: location.coordinate)
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
    
    private func didTapOnCurrentLocation() {
        locationManager.requestLocation()
    }
    
    private func didTapOnTrackLocation() {
        locationManager.startUpdatingLocation()
    }
    
    private func didTapOnStartTrack() {
        locationManager.startUpdatingLocation()
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
        locationManager.stopUpdatingLocation()
    }
}
