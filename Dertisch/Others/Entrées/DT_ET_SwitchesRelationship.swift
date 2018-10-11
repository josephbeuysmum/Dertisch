//
//  DT_ET_switchBundle.swift
//  Dertisch
//
//  Created by Richard Willis on 27/07/2018.
//

internal struct DTSwitchesRelationship: DTCleanUp {
	var
	customer: DTCustomer?,
	waiter: DTWaiter?,
	headChef: DTHeadChef?

	mutating func cleanUp() {
		customer?.removeFromParent()
		headChef?.cleanUp()
		waiter?.cleanUp()
		customer?.cleanUp()
		headChef = nil
		waiter = nil
		customer = nil
	}
}
