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
		headChef?.endShift()
		waiter?.endShift()
		customer?.endShift()
		headChef = nil
		waiter = nil
		customer = nil
	}
}
