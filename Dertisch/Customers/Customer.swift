//
//  Customer.swift
//  Dertisch
//
//  Created by Richard Willis on 30/07/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

import Foundation

fileprivate class CustomerFacets {
	let
	forRestaurantTable: CustomerForRestaurantTable,
	forMaitreD: CustomerForMaitreD,
	forMaitreDType: CustomerForMaitreD.Type,
	forSommelier: CustomerForSommelier,
	forWaiter: CustomerForWaiter?
	
	init(
		_ forRestaurantTable: CustomerForRestaurantTable,
		_ forMaitreD: CustomerForMaitreD,
		_ forMaitreDType: CustomerForMaitreD.Type,
		_ forSommelier: CustomerForSommelier,
		_ forWaiter: CustomerForWaiter?) {
		self.forRestaurantTable = forRestaurantTable
		self.forMaitreDType = forMaitreDType
		self.forMaitreD = forMaitreD
		self.forSommelier = forSommelier
		self.forWaiter = forWaiter
	}
}

fileprivate var rota: [String: CustomerFacets] = [:]



//public protocol CustomerForCustomer: class, SimpleColleagueProtocol {
//	func layTable()
//	func showToTable()
//}

public protocol CustomerFacet {
	init(_ customer: Customer, _ key: String)
}

public protocol CustomerForMaitreD: class, CustomerFacet, SimpleColleagueProtocol {
	func layTable(_ key: String)
	func showToTable(_ key: String)
	func peruseMenu(_ key: String)
	func returnMenuToWaiter(_ key: String, _ order: CustomerOrder?)
	func menuReturnedToWaiter(_ key: String, _ order: CustomerOrder?)
}

public protocol CustomerForSommelier: class, CustomerFacet, SimpleColleagueProtocol {
	func regionChosen(_ key: String)
}

public protocol CustomerForRestaurantTable: class, CustomerFacet, SimpleColleagueProtocol {
	func tableAssigned(_ key: String)
	func isSeated(_ key: String)
}

public protocol CustomerForWaiter: class, CustomerFacet, SimpleColleagueProtocol {
	func approach(_ key: String)
	func present(_ key: String, dish dishId: String)
	func presentCheck(_ key: String)
}



//extension CustomerForCustomer {
//	public func layTable() {}
//	public func showToTable() {}
//}

public extension CustomerForMaitreD {
	public func layTable(_ key: String) { lo() }
	public func showToTable(_ key: String) { lo() }
	public func peruseMenu(_ key: String) {}
	public func returnMenuToWaiter(_ key: String, _ order: CustomerOrder? = nil) {}
	public func menuReturnedToWaiter(_ key: String, _ order: CustomerOrder? = nil) {}
}

public extension CustomerForRestaurantTable {
	public func tableAssigned(_ key: String) {
		guard let facets = rota[key] else { return }
		facets.forMaitreD.showToTable(key)
		facets.forSommelier.regionChosen(key)
	}
	
	public func isSeated(_ key: String) {
		rota[key]?.forMaitreD.layTable(key)
	}
}

public extension CustomerForSommelier {
	public func regionChosen(_ key: String) {}
}

public extension CustomerForWaiter {
	public func approach(_ key: String) {}
	public func present(_ key: String, dish dishId: String) {}
	public func presentCheck(_ key: String) {}
}



public protocol CustomerProtocol {
	func forRestaurantTable(by key: String) -> CustomerForRestaurantTable?
	func forMaitreD(by key: String) -> CustomerForMaitreD?
	func forSommelier(by key: String) -> CustomerForSommelier?
	func forWaiter(by key: String) -> CustomerForWaiter?
}

internal protocol CustomerInternalProtocol: ComplexColleagueProtocol {
	var internalKey: String { get }
	var restaurantTable: RestaurantTable { get }
	init(_ key: String, _ restaurantTable: RestaurantTable)
	func inject(
		_ forRestaurantTableType: CustomerForRestaurantTable.Type,
		_ forMaitreDType: CustomerForMaitreD.Type,
		_ forSommelierType: CustomerForSommelier.Type,
		_ forWaiterType: CustomerForWaiter.Type?,
		_ waiter: WaiterForCustomer?)
}

public class Customer {
	private let
	privateKey: String,
	table: RestaurantTable
	
	fileprivate var
	waiter: WaiterForCustomer?
	
	internal required init(_ key: String, _ table: RestaurantTable) {
		privateKey = key
		self.table = table
		lo("BONJOUR  ", self)
	}
	
	deinit {
		lo("AU REVOIR", self)
		
	}
}

extension Customer: CustomerProtocol {
	public func forRestaurantTable(by key: String) -> CustomerForRestaurantTable? {
		return rota[key]?.forRestaurantTable
	}
	
	public func forMaitreD(by key: String) -> CustomerForMaitreD? {
		return rota[key]?.forMaitreD
	}
	
	public func forSommelier(by key: String) -> CustomerForSommelier? {
		return rota[key]?.forSommelier
	}
	
	public func forWaiter(by key: String) -> CustomerForWaiter? {
		return rota[key]?.forWaiter
	}
}

extension Customer: CustomerInternalProtocol {
	internal var internalKey: String {
		return privateKey
	}
	
	internal var restaurantTable: RestaurantTable {
		return table
	}
	
	internal func inject(
		_ forRestaurantTableType: CustomerForRestaurantTable.Type,
		_ forMaitreDType: CustomerForMaitreD.Type,
		_ forSommelierType: CustomerForSommelier.Type,
		_ forWaiterType: CustomerForWaiter.Type?,
		_ waiter: WaiterForCustomer?) {
		self.waiter = waiter
//		let inj = Customer(self)
		let forWaiter = forWaiterType != nil ? forWaiterType!.init(self, privateKey) : nil
		rota[privateKey] = CustomerFacets(
			forRestaurantTableType.init(self, privateKey),
			forMaitreDType.init(self, privateKey),
			forMaitreDType,
			forSommelierType.init(self, privateKey),
			forWaiter)
	}
	
	internal func beginShift() {
		lo()
	}
	
	internal func endShift() {
		lo()
	}
}
