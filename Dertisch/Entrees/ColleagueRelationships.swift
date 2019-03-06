//
//  ColleagueRelationships.swift
//  Dertisch
//
//  Created by Richard Willis on 13/03/2018.
//

// todo a bunch more files can be made internal, no?
internal struct ColleagueRelationships {
	let customerForRestaurantTableType: CustomerForRestaurantTable.Type,
	customerForMaitreDType: CustomerForMaitreD.Type,
	customerForSommelierType: CustomerForSommelier.Type,
	customerForWaiterType: CustomerForWaiter.Type?,
	waiterableType: Waiterable.Type?,
	waiterForCustomerType: WaiterForCustomer.Type?,
	waiterForHeadChefType: WaiterForHeadChef.Type?,
	headChefForWaiterType: HeadChefForWaiter.Type?,
	headChefForSousChefType: HeadChefForSousChef.Type?,
	kitchenResourceTypes: [KitchenResource.Type]?
	
	var hasWaiter: Bool {
		return waiterableType != nil && waiterableType! is WaiterableInternal.Type && waiterForCustomerType != nil
	}
	
	var hasHeadChef: Bool {
		return headChefForWaiterType != nil
	}
	
	var internalWaiterableType: WaiterableInternal.Type? {
		return waiterableType as? WaiterableInternal.Type
	}
}
