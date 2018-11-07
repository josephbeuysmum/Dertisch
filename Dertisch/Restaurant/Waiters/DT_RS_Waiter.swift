//
//  DT_RS_Waiter.swift
//  Cirk
//
//  Created by Richard Willis on 05/11/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public protocol DTCarteForCustomer {}

public protocol DTCarteForWaiter {
	func stockCarte(with dish: DTDish)
}

public protocol DTCarte: DTCarteForCustomer, DTCarteForWaiter {
	init<T>(_ entrees: T)
}

extension DTCarteForWaiter {
	func stockCarte(with dish: DTDish) { flagNonImplementation() }
}

public protocol DTWaiterForCustomer: DTGiveOrderProtocol {
	var carte: DTCarteForCustomer? { get }
}

//public protocol DTWaiterForTableCustomer {
//	func getCellDataFor<T>(_ indexPath: IndexPath) -> T?
//}

public protocol DTWaiterForHeadChef {//: DTServeCustomerProtocol {
	mutating func hand(_ sideDish: DTDish)
	mutating func serve<T>(entrees: T?)
}

public protocol DTWaiterForWaiter {
	mutating func fillCarte<T>(with entrees: T?)
	mutating func serve(_ dish: DTDish)
}

public protocol DTWaiter: DTWaiterForCustomer, DTWaiterForHeadChef, DTWaiterForWaiter, DTStartShiftProtocol, DTEndShiftProtocol {
	init(customer: DTCustomerForWaiter, headChef: DTHeadChefForWaiter?)
}

public extension DTWaiter {
	public func endShift() { flagNonImplementation() }
	public func startShift() { flagNonImplementation() }
}

public extension DTWaiterForCustomer {
	public func give(_ order: DTOrder) {
//		lo()
		guard var headChef = DTFirstInstance().get(DTHeadChefForWaiter.self, from: Mirror(reflecting: self)) else { return }
		headChef.give(order)
	}
}

public extension DTWaiterForWaiter {
	func serve(_ dish: DTDish) {
		let mirror = Mirror(reflecting: self)
		guard let carte = DTFirstInstance().get(DTCarte.self, from: mirror) else { return }
		carte.stockCarte(with: dish)
		guard
			dish.isHot,
			let customer = DTFirstInstance().get(DTCustomerForWaiter.self, from: mirror)
			else { return }
		customer.present(hotDish: dish.id)
	}
}

public extension DTWaiterForHeadChef {
	public func hand(_ sideDish: DTDish) {
//		lo(sideDish)
		guard var waiter = self as? DTWaiterForWaiter else { return }
		waiter.serve(sideDish)
	}
	
	public func serve<T>(entrees: T?) {
		guard
			let customer = DTFirstInstance().get(DTCustomerForWaiter.self, from: Mirror(reflecting: self)),
			var waiter = self as? DTWaiterForWaiter
			else { return }
		waiter.fillCarte(with: entrees)
		customer.approach()
	}
}
