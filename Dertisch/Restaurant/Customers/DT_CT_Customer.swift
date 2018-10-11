//
//  DT_Customer.swift
//  Dertisch
//
//  Created by Richard Willis on 30/07/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

import UIKit

public protocol DTCustomerForWaiter {
	func approach()
	func order()
}

public protocol DTCustomerProtocol: class, DTCustomerForWaiter {
	func assign(_ waiter: DTWaiterForCustomer, and sommelier: DTSommelier)
}

open class DTCustomer: UIViewController {
	// these can only be overridden if they are in as opposed to the extension below
	open func cleanUp() { flagNonImplementation() }
	open func assign(_ waiter: DTWaiterForCustomer, and sommelier: DTSommelier) { flagNonImplementation() }
	open func order() { flagNonImplementation() }
}

extension DTCustomer: DTCustomerProtocol {
	public final func approach() { order() }
}
