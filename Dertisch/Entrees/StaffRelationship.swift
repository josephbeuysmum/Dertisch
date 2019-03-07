//
//  StaffRelationship.swift
//  Dertisch
//
//  Created by Richard Willis on 27/07/2018.
//

internal struct StaffRelationship {
	let
	customerID: String,
	key: String,
	animated: Bool,
	customer: InternalCustomer?,
	waiter: Waiter?,
	headChef: HeadChef?
}
