//
//  DtCustomer.swift
//  Dertisch
//
//  Created by Richard Willis on 07/03/2019.
//

internal protocol CustomerableInternal {
	func forWaiter(_ key: String) -> CustomerForWaiter?
}

internal protocol CustomerInjectable {
	func inject(_ waiter: WaiterForCustomer?)
}

internal protocol CustomerInternal: Customerable, CustomerableInternal, CustomerInjectable {
	init(
		_ key: String,
		_ restaurantTable: RestaurantTable,
		_ forRestaurantTableType: CustomerForRestaurantTable.Type,
		_ forMaitreDType: CustomerForMaitreD.Type,
		_ forSommelierType: CustomerForSommelier.Type,
		_ forWaiterType: CustomerForWaiter.Type?)
}





internal class InternalCustomer {
	private var key: String?
	private var head: CustomerInternal?
	
	required init() {}
	
	convenience init(_ key: String, _ customer: Customerable) {
		self.init()
		self.key = key
		head = customer as? CustomerInternal
	}
}

extension InternalCustomer: Customer {
	var restaurantTable: RestaurantTable {
		return "" as! RestaurantTable
	}
	
	final func beginShift() { lo() }
	final func endShift() { lo() }
	final func beginBreak() { lo() }
	final func endBreak() { lo() }
	
	// tood tood tood tood we're just returning nils here, we need proper returns
	func forMaitreD(_ key: String) -> CustomerForMaitreD? {
		lo("currently hardcoded nil return")
		return nil
	}
	
	func forSommelier(_ key: String) -> CustomerForSommelier? {
		lo("currently hardcoded nil return")
		return nil
	}
	
	func forRestaurantTable(_ key: String) -> CustomerForRestaurantTable? {
		lo("currently hardcoded nil return")
		return nil
	}
}

extension InternalCustomer: CustomerableInternal {
	final func forWaiter(_ key: String) -> CustomerForWaiter? {
		return head?.forWaiter(key)
	}
}

extension InternalCustomer: CustomerInjectable {
	public final func inject(_ waiter: WaiterForCustomer?) {
		head?.inject(waiter)
	}
}





internal protocol CustomerInternalProtocol {
	func forMaitreD(_ key: String) -> CustomerForMaitreD?
	func forSommelier(_ key: String) -> CustomerForSommelier?
	func forRestaurantTable(_ key: String) -> CustomerForRestaurantTable?
}

