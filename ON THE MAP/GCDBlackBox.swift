//
//  GCDBlackBox.swift
//  ON THE MAP
//
//  Created by liang on 4/16/16.
//  Copyright © 2016 liang. All rights reserved.
//

import Foundation


func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}