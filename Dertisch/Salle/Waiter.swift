//
//  Waiter.swift
//  Dertisch
//
//  Created by Richard Willis on 05/11/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import Foundation

fileprivate var rota: [String: DtWaiter] = [:]



public protocol Waiterable {
	func customer(_ key: String) -> CustomerForWaiter?
	func headChef(_ key: String) -> HeadChefForWaiter?
}

internal protocol WaiterInternal: Waiterable{
	init(
		_ key: String,
		_ forCustomer: WaiterForCustomer.Type,
		_ forHeadChef: WaiterForHeadChef.Type?)
	func inject(_ customer: CustomerForWaiter?, _ headChef: HeadChefForWaiter?)
	func forCustomer(_ key: String) -> WaiterForCustomer?
	func forHeadChef(_ key: String) -> WaiterForHeadChef?
}



public protocol WaiterFacet {
	init(_ key: String, _ waiter: DtWaiter)
}

public protocol WaiterForCustomer: class, WaiterFacet, GiveCustomerOrderable {
	var carte: CarteForCustomer? { get }
	func emptyCarte()
}

public extension WaiterForCustomer {
	func emptyCarte() {}

	public func give(_ order: CustomerOrder, _ key: String) {
		rota[key]?.head_chef?.give(order, key)
	}
}

public protocol WaiterForHeadChef: class, WaiterFacet {
	func serve(entrees: FulfilledOrder, _ key: String)
	func serve(main: FulfilledOrder, _ key: String)
}

public extension WaiterForHeadChef {
	public func serve(main: FulfilledOrder, _ key: String) {
		guard let waiter = rota[key] else { return }
		if waiter.for_customer?.carte == nil {
			waiter.for_waiter?.addToCarte(main)
		} else {
			waiter.for_waiter?.fillCarte(with: main)
		}
		DispatchQueue.main.async {
			waiter.customer_?.present(dish: main.ticket)
		}
	}
	
	public func serve(entrees: FulfilledOrder, _ key: String) {
		rota[key]?.for_waiter?.fillCarte(with: entrees)
		rota[key]?.customer_?.present(dish: entrees.ticket)
	}
}



public protocol WaiterForWaiter: class, WaiterFacet {
	func addToCarte(_ main: FulfilledOrder)
	func fillCarte(with entrees: FulfilledOrder)
}

public extension WaiterForWaiter {
	func addToCarte(_ main: FulfilledOrder) {}
	func fillCarte(with entrees: FulfilledOrder) {}
}



//internal class Waiter {
////	private let key: String
//	private let head: WaiterableInternal?
//
//	// tood should this (and equiv in Customer) inject a WaiterableInternal?
//	required init(/*_ key: String, */_ waiter: Waiterable) {
////		self.key = key
//		// tood force an error if the passed Waiterable cannot be cast to WaiterableInternal (and subsequently make let head mandatory) (also in Customer)
//		self.head = waiter as? WaiterableInternal
//	}
//}
//
//extension Waiter: WaiterFacet {}
//
//extension Waiter: WaiterInternal {
//	final func forCustomer(_ key: String) -> WaiterForCustomer? {
//		return head?.forCustomer(key)
//	}
//
//	final func forHeadChef(_ key: String) -> WaiterForHeadChef? {
//		return head?.forHeadChef(key)
//	}
//}
//
//extension Waiter: WaiterInjectable {
//	public final func inject(_ customer: CustomerForWaiter?, _ headChef: HeadChefForWaiter?) {
//		head?.inject(customer, headChef)
//	}
//}
//
//extension Waiter: WorkShiftable {
//	final func beginShift() {
//		lo()
//	}
//
//	final func endShift() {
//		lo()
//	}
//}
//
//extension Waiter: CigaretteBreakable {
//	final func beginBreak() {
//		lo()
//	}
//
//	final func endBreak() {
//		lo()
//	}
//}





//public protocol DtWaiterForCustomer: WaiterForCustomer {
//	var carte: CarteForCustomer? { get }
//	func emptyCarte()
//}
//
//public extension DtWaiterForCustomer {
//	func emptyCarte() {}
//
//	public func give(_ order: CustomerOrder, _ key: String) {
//		rota[key]?.head_chef?.give(order, key)
//	}
//}



//public protocol DtWaiterForHeadChef: WaiterForHeadChef {
//	func serve(entrees: FulfilledOrder, _ key: String)
//	func serve(main: FulfilledOrder, _ key: String)
//}
//
//public extension DtWaiterForHeadChef {
//	public func serve(main: FulfilledOrder, _ key: String) {
//		guard let waiter = rota[key] else { return }
//		if waiter.for_customer?.carte == nil {
//			waiter.for_waiter?.addToCarte(main)
//		} else {
//			waiter.for_waiter?.fillCarte(with: main)
//		}
//		DispatchQueue.main.async {
//			waiter.customer_?.present(dish: main.ticket)
//		}
//	}
//
//	public func serve(entrees: FulfilledOrder, _ key: String) {
//		rota[key]?.for_waiter?.fillCarte(with: entrees)
//		rota[key]?.customer_?.present(dish: entrees.ticket)
//	}
//}



//public protocol DtWaiterForWaiter: WaiterForWaiter {
//	func addToCarte(_ main: FulfilledOrder)
//	func fillCarte(with entrees: FulfilledOrder)
//}
//
//public extension DtWaiterForWaiter {
//	func addToCarte(_ main: FulfilledOrder) {}
//	func fillCarte(with entrees: FulfilledOrder) {}
//}





//public protocol DtWaiterProtocol: WorkShiftable, CigaretteBreakable {
//	func forCustomer(_ key: String) -> DtWaiterForCustomer?
//	func forHeadChef(_ key: String) -> DtWaiterForHeadChef?
//}

public class DtWaiter {
	private let private_key: String
	
	// tood change to lets?
	fileprivate var for_customer: WaiterForCustomer?
	fileprivate var for_head_chef: WaiterForHeadChef?
	fileprivate var for_waiter: WaiterForWaiter?
	fileprivate var customer_: CustomerForWaiter?
	fileprivate var head_chef: HeadChefForWaiter?
	
	internal required init(
		_ key: String,
		_ forCustomer: WaiterForCustomer.Type,
		_ forHeadChef: WaiterForHeadChef.Type?) {
		private_key = key
		self.for_customer = forCustomer.init(key, self)
		self.for_head_chef = forHeadChef != nil ? forHeadChef!.init(key, self) : nil
		self.for_waiter = GeneralWaiterForWaiter(key, self)
		rota[private_key] = self
		lo("BONJOUR  ", self)
	}
	
	deinit { lo("AU REVOIR", self) }
}

//extension DtWaiter {
//	public final func forCustomer(_ key: String) -> WaiterForCustomer? {
//		return key == private_key ? for_customer : nil
//	}
//	
//	public final func forHeadChef(_ key: String) -> WaiterForHeadChef? {
//		return key == private_key ? for_head_chef : nil
//	}
//}

extension DtWaiter: WorkShiftable {
	public func beginShift() { lo() }
	public func endShift() { lo() }
}

extension DtWaiter: CigaretteBreakable {
	public func beginBreak() { lo() }
	public func endBreak() { lo() }
}

extension DtWaiter: Waiterable {
	public final func customer(_ key: String) -> CustomerForWaiter? {
		return key == private_key ? customer_ : nil
	}
	
	public final func headChef(_ key: String) -> HeadChefForWaiter? {
		return key == private_key ? head_chef : nil
	}
}

extension DtWaiter: WaiterInternal {
	func inject(_ customer: CustomerForWaiter?, _ headChef: HeadChefForWaiter?) {
		customer_ = customer
		head_chef = headChef
	}
	
	func forCustomer(_ key: String) -> WaiterForCustomer? {
		return key == private_key ? for_customer : nil
	}
	
	func forHeadChef(_ key: String) -> WaiterForHeadChef? {
		return key == private_key ? for_head_chef : nil
	}
}
