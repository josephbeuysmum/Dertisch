//
//  DT_WT_Simple.swift
//  Cirk
//
//  Created by Richard Willis on 09/10/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

//import Dertisch

class GeneralWaiter: DTWaiter {
	var carte: DTCarte? { return nil }
	
	let
	customer: DTCustomerForWaiter,
	maitreD: DTMaitreD
	
	fileprivate var headChef: DTHeadChefForWaiter?
	
//	required init(maitreD: DTMaitreD, customer: DTCustomerForWaiter) {
	required init(customer: DTCustomerForWaiter, maitreD: DTMaitreD, headChef: DTHeadChefForWaiter? = nil) {
		self.customer = customer
		self.maitreD = maitreD
		self.headChef = headChef
	}
	
	public func giveOrder<T>(of order: T?) {}
	public func serve<T>(entrees: T?) {}
	public func startShift() {}
}

public protocol DTCarte {
	init<T>(_ value: T)
}

public protocol DTWaiterForCustomer: DTGiveOrderProtocol {
	var carte: DTCarte? { get }
	// todo should customers *really* access the maitre d directly through their waiters?
	var maitreD: DTMaitreD { get }
}

//public protocol DTWaiterForTableCustomer {
//	func getCellDataFor<T>(_ indexPath: IndexPath) -> T?
//}

public protocol DTWaiterForHeadChef {//: DTServeCustomerProtocol {
	mutating func serve<T>(entrees: T?)
}

public protocol DTWaiter: DTWaiterForCustomer, DTWaiterForHeadChef, DTCleanUp, DTStartShiftProtocol {
	init(customer: DTCustomerForWaiter, maitreD: DTMaitreD, headChef: DTHeadChefForWaiter?)
}

public extension DTWaiter {
	public func cleanUp() { flagNonImplementation() }
	public func give(_ order: DTOrder) { flagNonImplementation() }
	public func serve<T>(entrees: T?) { flagNonImplementation() }
	public func startShift() { flagNonImplementation() }
}
