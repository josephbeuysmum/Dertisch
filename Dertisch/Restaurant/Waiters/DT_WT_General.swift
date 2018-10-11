//
//  DT_WT_Simple.swift
//  Cirk
//
//  Created by Richard Willis on 09/10/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

//import Dertisch

class GeneralWaiter: DTWaiter {
	let
	maitreD: DTMaitreD,
	customer: DTCustomerForWaiter
	
	required init(maitreD: DTMaitreD, customer: DTCustomerForWaiter) {
		self.maitreD = maitreD
		self.customer = customer
	}
}

public protocol DTWaiterForCustomer {
	// todo should customers *really* access the maitre d directly through their waiters?
	var maitreD: DTMaitreD { get }
//	mutating func order<T>(_ entrées: T?)
}

//public protocol DTWaiterForTableCustomer {
//	func getCellDataFor<T>(_ indexPath: IndexPath) -> T?
//}

public protocol DTWaiterForHeadChef {//: DTServeCustomerProtocol {
	mutating func serve<T>(entrées: T?)
}

public protocol DTWaiter: DTWaiterForCustomer, DTWaiterForHeadChef, DTCleanUp {
	init(maitreD: DTMaitreD, customer: DTCustomerForWaiter)
}

public extension DTWaiter {
	public func cleanUp() { flagNonImplementation() }
//	public func order<T>(_ entrées: T?) { flagNonImplementation() }
	public func serve<T>(entrées: T?) { flagNonImplementation() }
}
