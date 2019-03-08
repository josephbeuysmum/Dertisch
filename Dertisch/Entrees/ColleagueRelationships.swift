//
//  ColleagueRelationships.swift
//  Dertisch
//
//  Created by Richard Willis on 13/03/2018.
//

// todo a bunch more files can be made internal, no?
internal struct ColleagueRelationships {
	let customerableType: Customerable.Type
	let customerForSeatType: CustomerForSeat.Type
	let customerForMaitreDType: CustomerForMaitreD.Type
	let customerForSommelierType: CustomerForSommelier.Type
	let customerForWaiterType: CustomerForWaiter.Type?
	let waiterableType: Waiterable.Type?
	let waiterForCustomerType: WaiterForCustomer.Type?
	let waiterForHeadChefType: WaiterForHeadChef.Type?
	let headChefForWaiterType: HeadChefForWaiter.Type?
	let headChefForSousChefType: HeadChefForSousChef.Type?
	let kitchenResourceTypes: [KitchenResource.Type]?
	
	var hasWaiter: Bool {
		return waiterableType != nil && waiterForCustomerType != nil
	}
	
	var hasHeadChef: Bool {
		return headChefForWaiterType != nil
	}
	
//	var internalCustomerableType: CustomerInternal.Type? {
//		return customerableType as? CustomerInternal.Type
//	}

//	var internalWaiterableType: WaiterableInternal.Type? {
//		return waiterableType as? WaiterableInternal.Type
//	}
}
