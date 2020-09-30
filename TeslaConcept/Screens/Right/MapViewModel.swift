//
//  MapViewModel.swift
//  TeslaConcept
//
//  Created by Kirill Khudiakov on 30.09.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import Combine
import CoreLocation
import RealmSwift
import GoogleMaps


struct TrackDTO {
    let polyline: GMSPolyline
    let lastCoordinate: CLLocationCoordinate2D
}


class MapViewModel {
    let coordinate = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
    let podolsk = CLLocationCoordinate2D(latitude: 55.426022, longitude: 37.531850)
    
    let didTapTrackLocation: PassthroughSubject<Void, Never>
    let didTapCurrentLocation: PassthroughSubject<Void, Never>
    let didTapStartTrack: PassthroughSubject<Void, Never>
    let didTapStopTrack: PassthroughSubject<Void, Never>
    let didTapPreviousTrack: PassthroughSubject<Void, Never>
    
    let speed: CurrentValueSubject<Double, Never>
    
    let trackCoordinates: PassthroughSubject<CLLocationCoordinate2D, Never> = .init()
    let track: PassthroughSubject<TrackDTO, Never> = .init()
    
    private var cancellables = Set<AnyCancellable>()
    
    private var realm: Realm = { try! Realm() }()
    
    init(didTapTrack: PassthroughSubject<Void, Never>,
         didTapCurrent: PassthroughSubject<Void, Never>,
         didTapStartTrack: PassthroughSubject<Void, Never>,
         didTapStopTrack: PassthroughSubject<Void, Never>,
         didTapPreviousTrack: PassthroughSubject<Void, Never>,
         speed: CurrentValueSubject<Double, Never>
    ) {
        self.didTapTrackLocation = didTapTrack
        self.didTapCurrentLocation = didTapCurrent
        self.didTapStartTrack = didTapStartTrack
        self.didTapStopTrack = didTapStopTrack
        self.didTapPreviousTrack = didTapPreviousTrack
        self.speed = speed
        setupSubscriptions()
        
        let tracks = realm.objects(Track.self)
        print("tracks count:", tracks.count)
        tracks.forEach {
            print("track ", $0.id)
            print("track points: ", $0.points.count)
            print("track coordinates: \n", $0.points
                    .map { "\t\($0.latitude), \($0.longitude)" }
                    .joined(separator: "\n")
            )
            print("\n\n")
        }
    }
    
    
    
    private func setupSubscriptions() {
        // подписываемся на получение новых координат
        trackCoordinates
            .sink(receiveValue: handleNewCoordinates)
            .store(in: &cancellables)
        
        didTapStopTrack
            .sink(receiveValue: stopTrack)
            .store(in: &cancellables)
        
        didTapPreviousTrack
            .sink(receiveValue: loadTrack)
            .store(in: &cancellables)
    }
    
    private var currentTrack: Track?
    
    
    func startTrack() {
        currentTrack = Track()
        
        if let track = currentTrack {
            addTrack(track)
        }
    }
    
    private func addTrack(_ track: Track) {
        try! realm.write {
            realm.add(track)
        }
    }
    
    
    private func stopTrack() {
        print("Закончить трек")
        currentTrack = nil
    }
    
    private func handleNewCoordinates(_ coordinate: CLLocationCoordinate2D) {
        // и будем добавлять координаты в текущий track
        print("Новые координаты")
        
        if let track = currentTrack {
            let newPoint = Location()
            try! realm.write {
                newPoint.setCoordinate(coordinate)
                track.points.append(newPoint)
                realm.add(track, update: .all)
            }
        }
    }
    
    func loadTrack() {
        if let dto = realm.objects(Track.self)
            .first
            .map(trackToPolyline) {
            track.send(dto)
        }
    }
    
    private func trackToPolyline(_ track: Track) -> TrackDTO {
        let route = GMSPolyline()
        route.strokeColor = UIColor.orange
        route.strokeWidth = 6
        let routePath = GMSMutablePath()
        track.points.forEach {
            routePath.add($0.coordinate)
        }
        route.path = routePath
        return TrackDTO(polyline: route, lastCoordinate: track.points.last!.coordinate)
    }
}
