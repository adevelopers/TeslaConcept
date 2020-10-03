//
//  MusicTracksViewModel.swift
//  TeslaConcept
//
//  Created by Kirill Khudiakov on 02.10.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit
import Combine


class MusicTracksViewModel {

    var tracks: CurrentValueSubject<[UIImage], Never> = .init([])
    
    
    func loadData() {
        
        tracks.send([
            UIImage(imageLiteralResourceName: "1"),
            UIImage(imageLiteralResourceName: "2"),
            UIImage(imageLiteralResourceName: "3"),
            UIImage(imageLiteralResourceName: "4"),
            UIImage(imageLiteralResourceName: "5"),
            UIImage(imageLiteralResourceName: "6")
        ])
    }
}
