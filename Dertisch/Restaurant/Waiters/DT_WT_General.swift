//
//  DT_WT_Simple.swift
//  Cirk
//
//  Created by Richard Willis on 09/10/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

//import Dertisch

class GeneralWaiter: DTWaiter {
	var carte: DTCarteForCustomer? { return nil }
	
	let customer: DTCustomerForWaiter
	
	fileprivate var headChef: DTHeadChefForWaiter?
	
	//	required init(maitreD: DTMaitreD, customer: DTCustomerForWaiter) {
	required init(customer: DTCustomerForWaiter, headChef: DTHeadChefForWaiter? = nil) {
		self.customer = customer
		self.headChef = headChef
	}
	
	public func endShift() {
		headChef = nil
	}
	public func startShift() {}
}

extension GeneralWaiter: DTWaiterForHeadChef {
	public func serve<T>(entrees: T?) {}
}

extension GeneralWaiter: DTWaiterForWaiter {
	func fillCarte<T>(with entrees: T?) {}
	func serve(_ dish: DTDish) {}
}
