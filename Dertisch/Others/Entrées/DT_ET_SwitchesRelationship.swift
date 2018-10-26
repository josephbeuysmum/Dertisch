//
//  DT_ET_switchBundle.swift
//  Dertisch
//
//  Created by Richard Willis on 27/07/2018.
//

internal struct DTSwitchesRelationship: DTEndShiftProtocol {
	var
	customer: DTCustomer?,
	waiter: DTWaiter?,
	headChef: DTHeadChef?

	mutating func endShift() {
		customer?.removeFromParent()
		headChef?.cleanUp()
		waiter?.cleanUp()
		customer?.cleanUp()
		headChef = nil
		waiter = nil
		customer = nil
	}
}
