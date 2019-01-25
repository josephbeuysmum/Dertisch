//
//  DT_ET_SwitchesRelationship.swift
//  Dertisch
//
//  Created by Richard Willis on 27/07/2018.
//

internal struct SwitchesRelationship: EndProtocol {
	var
	customerID: String,
	customer: Customer,
	waiter: Waiter?,
	headChef: HeadChef?,
	animated: Bool

	mutating func end() {
		customer.finishMeal()
		waiter?.end()
		headChef?.end()
//		customer = nil
		waiter = nil
		headChef = nil
	}
}
