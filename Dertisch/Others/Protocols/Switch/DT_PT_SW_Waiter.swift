//
//  DT_PT_VP_Waiter.swift
//  Dertisch
//
//  Created by Richard Willis on 22/06/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

import Foundation

public extension DTWaiterProtocol {
	public var instanceDescriptor: String { return String(describing: self) }
	
//	public var closet: DTWaiterCloset? {
//		return DTFirstInstance().get(DTWaiterCloset.self, from: mirror_)
//	}
	
//	private var key_: DTKey? {
//		return DTFirstInstance().get(DTKey.self, from: mirror_)
//	}
	
	// todo these vars need to be made single instance safe
	private var mirror_: Mirror { return Mirror(reflecting: self) }
	private var maitre_d: DTMaitreD? { return DTFirstInstance().get(DTMaitreD.self, from: mirror_) }
	private var orders_: DTOrders? { return DTFirstInstance().get(DTOrders.self, from: mirror_) }
	private var customer_: DTCustomer? { return DTFirstInstance().get(DTCustomer.self, from: mirror_) }
	

	
	func startShift() {
		guard
//			let key = key_,
			let orders = orders_
			else { return }
		_ = orders.listenForOneOff(order: DTOrderConsts.viewLoaded, order: self) { _, data in
			guard
				let strongSelf = self as DTWaiterProtocol?,
				strongSelf.check(data)
				else { return }
			strongSelf.customerCooked()
			orders.make(order: DTOrderConsts.waiterActivated, with: strongSelf)
		}
		_ = orders.listenForOneOff(order: DTOrderConsts.viewAppeared, order: self) { _, data in
			guard
				let strongSelf = self as DTWaiterProtocol?,
				strongSelf.check(data)
				else { return }
			strongSelf.customerServed()
		}
	}
	
	
	// todo we may well have persistent viper objects in future versions of DT, in which case an internal non-protocol (ie: extension only) function is an excellent way (the best way I currently know of) for DT classes (ie: Routing) to talk to other DT classes (ie: EntityCollections) without allowing apps utilising DT (ie: Cirk) to access said function
//	internal func checkIn() {
//		closet?.orders(key_)?.make(order: DTOrderConsts.waiterUpdated, with: self)
//	}
	
	func serve(_ customerId: String, animated: Bool) {
		guard
//			let key = key_,
			let orders = orders_,
			let maitreD = maitre_d
			else { return }
		if maitreD.hasPopover {
			orders.listenForOneOff(order: DTOrderConsts.popoverRemoved, order: self) { _,_ in
				maitreD.serve(customerId, animated: animated)
			}
			maitreD.dismissPopover()
		} else {
			maitreD.serve(customerId, animated: animated)
		}
	}

	private func check(_ data: Any?) -> Bool {
		guard
			let passedCustomer = data as? DTCustomer,
			let ownCustomer = customer_
			else { return false }
		return passedCustomer == ownCustomer
	}
	
	mutating func cleanUp() {}
	mutating func serve<T>(with data: T?) {}
	mutating func update<T>(with data: T?) {}
	func customerServed() {}
	func customerCooked() {}
}

public protocol DTWaiterProtocol: DTSwitchClassProtocol, DTPopulatableCustomerProtocol, DTPresentableCustomerProtocol, DTUpdatableProtocol {
	init(orders: DTOrders, maitreD: DTMaitreD)//, customer: DTCustomer)
//	var closet: DTWaiterCloset? { get }
	func customerCooked()
	func customerServed()
}

































