//
//  Customer.swift
//  Dertisch
//
//  Created by Richard Willis on 30/07/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

import Foundation

//fileprivate class CustomerFacets {
//	let
//	forRestaurantTable: CustomerForRestaurantTable,
//	forMaitreD: CustomerForMaitreD,
//	forSommelier: CustomerForSommelier,
//	forWaiter: CustomerForWaiter?
//
//	init(
//		_ forRestaurantTable: CustomerForRestaurantTable,
//		_ forMaitreD: CustomerForMaitreD,
//		_ forSommelier: CustomerForSommelier,
//		_ forWaiter: CustomerForWaiter?) {
//		self.forRestaurantTable = forRestaurantTable
//		self.forMaitreD = forMaitreD
//		self.forSommelier = forSommelier
//		self.forWaiter = forWaiter
//	}
//}

fileprivate var rota: [String: Customer] = [:]



//public protocol CustomerForCustomer: class, SimpleColleagueProtocol {
//	func layTable()
//	func showToTable()
//}

public protocol CustomerFacet {
	init(_ customer: Customer, _ key: String)
}

public protocol CustomerForMaitreD: SimpleColleagueProtocol, CustomerFacet {
	func layTable(_ key: String)
	func showToTable(_ key: String)
	func peruseMenu(_ key: String)
	func returnMenuToWaiter(_ order: CustomerOrder?, _ key: String)
	func menuReturnedToWaiter(_ order: CustomerOrder?, _ key: String)
}

public protocol CustomerForSommelier: SimpleColleagueProtocol, CustomerFacet {
	func regionChosen(_ key: String)
}

public protocol CustomerForRestaurantTable: SimpleColleagueProtocol, CustomerFacet {
	func tableAssigned(_ key: String)
	func isSeated(_ key: String)
}

public protocol CustomerForWaiter: SimpleColleagueProtocol, CustomerFacet {
	func approach()
	func present(dish dishId: String)
	func presentCheck()
}



//extension CustomerForCustomer {
//	public func layTable() {}
//	public func showToTable() {}
//}

public extension CustomerForMaitreD {
	public func layTable(_ key: String) { lo() }
	public func showToTable(_ key: String) { lo() }
	public func peruseMenu(_ key: String) {}
	public func returnMenuToWaiter(_ order: CustomerOrder? = nil, _ key: String) {}
	public func menuReturnedToWaiter(_ order: CustomerOrder? = nil, _ key: String) {}
}

public extension CustomerForRestaurantTable {
	public func tableAssigned(_ key: String) {
		guard let customer = rota[key] else { return }
		customer.forMaitreD(key)?.showToTable(key)
		customer.forSommelier(key)?.regionChosen(key)
	}
	
	public func isSeated(_ key: String) {
		rota[key]?.forMaitreD(key)?.layTable(key)
	}
}

public extension CustomerForSommelier {
	public func regionChosen(_ key: String) {}
}

public extension CustomerForWaiter {
	public func approach() {}
	public func present(dish dishId: String) {}
	public func presentCheck() {}
}



public protocol CustomerProtocol {
	func forRestaurantTable(_ key: String) -> CustomerForRestaurantTable?
	func forMaitreD(_ key: String) -> CustomerForMaitreD?
	func forSommelier(_ key: String) -> CustomerForSommelier?
	func forWaiter(_ key: String) -> CustomerForWaiter?
	func waiter(_ key: String) -> WaiterForCustomer?
}

internal protocol CustomerInternalProtocol: ComplexColleagueProtocol {
	var restaurantTable: RestaurantTable { get }
	init(
		_ key: String,
		_ table: RestaurantTable,
		_ forRestaurantTableType: CustomerForRestaurantTable.Type,
		_ forMaitreDType: CustomerForMaitreD.Type,
		_ forSommelierType: CustomerForSommelier.Type,
		_ forWaiterType: CustomerForWaiter.Type?)
	func inject(_ waiter: WaiterForCustomer?)
}

public class Customer {
	private let
	privateKey: String,
	table: RestaurantTable
	
	fileprivate var
	_forRestaurantTable: CustomerForRestaurantTable?,
	_forMaitreD: CustomerForMaitreD?,
	_forSommelier: CustomerForSommelier?,
	_forWaiter: CustomerForWaiter?,
	_waiter: WaiterForCustomer?
	
	internal required init(
		_ key: String,
		_ table: RestaurantTable,
		_ forRestaurantTableType: CustomerForRestaurantTable.Type,
		_ forMaitreDType: CustomerForMaitreD.Type,
		_ forSommelierType: CustomerForSommelier.Type,
		_ forWaiterType: CustomerForWaiter.Type?) {
		privateKey = key
		self.table = table
		_forRestaurantTable = forRestaurantTableType.init(self, privateKey)
		_forMaitreD = forMaitreDType.init(self, privateKey)
		_forSommelier = forSommelierType.init(self, privateKey)
		_forWaiter = forWaiterType != nil ? forWaiterType!.init(self, privateKey) : nil
		rota[privateKey] = self
		lo("BONJOUR  ", self)
	}
	
	deinit {
		lo("AU REVOIR", self)
		
	}
}

extension Customer: CustomerProtocol {
	public func forRestaurantTable(_ key: String) -> CustomerForRestaurantTable? {
		return key == privateKey ? _forRestaurantTable : nil
	}
	
	public func forMaitreD(_ key: String) -> CustomerForMaitreD? {
		return key == privateKey ? _forMaitreD : nil
	}
	
	public func forSommelier(_ key: String) -> CustomerForSommelier? {
		return key == privateKey ? _forSommelier : nil
	}
	
	public func forWaiter(_ key: String) -> CustomerForWaiter? {
		return key == privateKey ? _forWaiter : nil
	}
	
	public func waiter(_ key: String) -> WaiterForCustomer? {
		return key == privateKey ? _waiter : nil
	}
}

extension Customer: CustomerInternalProtocol {
	internal var internalKey: String {
		return privateKey
	}
	
	internal var restaurantTable: RestaurantTable {
		return table
	}
	
	internal func inject(_ waiter: WaiterForCustomer?) {
		self._waiter = waiter
	}
	
	internal func beginShift() {
		lo()
	}
	
	internal func endShift() {
		lo()
	}
}
