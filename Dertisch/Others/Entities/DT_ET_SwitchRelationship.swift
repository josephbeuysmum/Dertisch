//
//  DT_ET_ViperBundle.swift
//  Dertisch
//
//  Created by Richard Willis on 27/07/2018.
//

internal struct DTSwitchRelationship: DTDeallocatableProtocol {
	var
	customer: DTCustomer?,
	headChef: DTHeadChefProtocol?,
	waiter: DTWaiterProtocol?
	
	mutating func cleanUp() {
		customer?.removeFromParentViewController()
//		waiter_?.checkIn()
		// todo see note on checkIn in DTWaiterProtocol
		headChef?.cleanUp()
		waiter?.cleanUp()
		customer?.cleanUp()
		headChef = nil
		waiter = nil
		customer = nil
	}
}
