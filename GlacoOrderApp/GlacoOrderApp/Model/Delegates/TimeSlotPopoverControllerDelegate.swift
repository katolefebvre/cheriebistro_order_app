//
//  TimeSlotPopoverControllerDelegate.swift
//  GlacoOrderApp
//
//  Created by Parker Christie on 2020-03-25.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import Foundation

/// A delegate for the TimeSlotPopoverViewController
protocol TimeSlotPopoverControllerDelegate {
    
    func getTimeSlot() -> TimeSlot?
    func setTimeSlot(timeSlot : TimeSlot)
    
}
