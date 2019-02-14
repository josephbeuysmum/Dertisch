//
//  ColleagueRelationships.swift
//  Dertisch
//
//  Created by Richard Willis on 13/03/2018.
//

// todo a bunch more files can be made internal, no?
internal struct ColleagueRelationships {
	let
//	customerType: Customer.Type,
	customerForRestaurantTableType: CustomerForRestaurantTable.Type,
	customerForMaitreDType: CustomerForMaitreD.Type,
	customerForSommelierType: CustomerForSommelier.Type,
	customerForWaiterType: CustomerForWaiter.Type?,
	waiterForCustomerType: WaiterForCustomer.Type?,
	waiterForMaitreDType: WaiterForMaitreD.Type?,
	waiterForHeadChefType: WaiterForHeadChef.Type?,
	headChefForWaiterType: HeadChefForWaiter.Type?,
	headChefForSousChefType: HeadChefForSousChef.Type?,
	kitchenResourceTypes: [KitchenResource.Type]?
	
	var hasWaiter: Bool {
		return waiterForCustomerType != nil && waiterForMaitreDType != nil && waiterForHeadChefType != nil
	}
	
	var hasHeadChef: Bool {
		return headChefForWaiterType != nil
	}
}




//	init(
//		_ customerType: Customer.Type,
//		_ waiterType: Waiter.Type?,
//		_ headChefForWaiterType: T.Type?,
//		_ headChefForSousChefType: U.Type?,
//		_ kitchenResourceTypes: [KitchenResource.Type]?)  {
//		ct = customerType
//		wt = waiterType
//		hcfwt = headChefForWaiterType
//		hcfsct = headChefForSousChefType
//		krt = kitchenResourceTypes
//	}
	
//	func customerType() -> Customer.Type {
//		return ct
//	}
//
//	func waiterType() -> Waiter.Type? {
//		return wt
//	}
//
//	func headChefForWaiter<T>() -> T.Type? where T: HeadChefForWaiter {
//		return hcfwt as? T.Type
//	}
//
//	func headChefForSousChef<T>() -> T.Type? where T: HeadChefForSousChef {
//		return hcfsct as? T.Type
//	}
//
//	func kitchenResourceTypes() -> [KitchenResource.Type]? {
//		return krt
//	}
