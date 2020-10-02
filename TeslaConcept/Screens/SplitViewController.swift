//
//  SplitViewController.swift
//  TeslaConcept
//
//  Created by Kirill Khudiakov on 24.09.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit


class SplitViewController: UISplitViewController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeRight
    }
    
}


