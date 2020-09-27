//
//  Store.swift
//  TeslaConcept
//
//  Created by Кирилл Худяков on 27.09.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import Foundation
import Combine


class Store {
    let didTapTrackLocation: PassthroughSubject<Void, Never> = .init()
    let didTapCurrentLocation: PassthroughSubject<Void, Never> = .init()
    let didTapStartTrack: PassthroughSubject<Void, Never> = .init()
    let didTapStopTrack: PassthroughSubject<Void, Never> = .init()
}
