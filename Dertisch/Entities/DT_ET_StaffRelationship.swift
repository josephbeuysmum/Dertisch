//
//  DT_ET_VipRelationship.swift
//  Dertisch
//
//  Created by Richard Willis on 13/03/2018.
//

// todo a bunch more files can be made internal, no?
internal struct DTStaffRelationship {
	let
	dishType: DTDishProtocol.Type,
	headChefType: DTHeadChefProtocol.Type,
	waiterType: DTWaiterProtocol.Type,
	kitchenStaffTypes: [DTKitchenProtocol.Type]?
}

