//
//  DT_ET_ViperBundle.swift
//  Dertisch
//
//  Created by Richard Willis on 27/07/2018.
//

internal struct DTSwitchRelationship: DTDeallocatableProtocol {
	var
	dish: DTDish?,
	headChef: DTHeadChefProtocol?,
	waiter: DTWaiterProtocol?
	
	mutating func cleanUp() {
		dish?.removeFromParentViewController()
//		waiter_?.checkIn()
		// todo see note on checkIn in DTWaiterProtocol
		headChef?.cleanUp()
		waiter?.cleanUp()
		dish?.cleanUp()
		headChef = nil
		waiter = nil
		dish = nil
	}
}
