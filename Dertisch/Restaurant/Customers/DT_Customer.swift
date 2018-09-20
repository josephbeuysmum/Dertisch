//
//  DT_Customer.swift
//  Dertisch
//
//  Created by Richard Willis on 30/07/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

import UIKit

extension DTCustomer: DTCustomerProtocol {
//	public var key: String? {
//		guard key_ == nil else { return nil }
//		key_ = NSUUID().uuidString
//		return key_!
//	}
}

open class DTCustomer: UIViewController {
//	fileprivate var
//	key_: String?,
//	orders_: DTOrders?
	
	open func cleanUp() {}
	
//	override open func didReceiveMemoryWarning() {
//		super.didReceiveMemoryWarning()
//		orders_?.make(order: DTOrderConsts.viewWarnedAboutMemory, with: self)
//	}
	
	open func set(_ orders: DTOrders, and waiter: DTWaiterProtocol) {}
	
	//	public func orders(_ key: String?) -> DTOrders? {
	//		guard key != nil else { return nil }
	//		return key == key_ ? orders_ : nil
	//	}
	
//	override open func viewDidAppear(_ animated: Bool) {
//		super.viewDidAppear(animated)
//		orders_?.make(order: DTOrderConsts.viewAppeared, with: self)
//	}
//	
//	override open func viewDidLoad() {
//		super.viewDidLoad()
//		orders_?.make(order: DTOrderConsts.viewLoaded, with: self)
//	}
}
