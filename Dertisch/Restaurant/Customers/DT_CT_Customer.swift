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
	func present(hotDish dishId: String)
}

public protocol DTCustomerProtocol: class, DTCustomerForWaiter {
	func assign(_ waiter: DTWaiterForCustomer, maitreD: DTMaitreD, and sommelier: DTSommelier)
}

// todo the deninit func for a customer feels we
open class DTCustomer: UIViewController {
	// these can only be overridden if they are in as opposed to the extension below
	open func assign(_ waiter: DTWaiterForCustomer, maitreD: DTMaitreD, and sommelier: DTSommelier) { flagNonImplementation() }
	open func finishMeal() { flagNonImplementation() }
	
	// present(hotDish) and order() needs to be here as opposed to the DTCustomerProtocol extension where it should *ideally* be because overriding it in a sub-viewController becomes more complicated otherwise
	open func present(hotDish dishId: String) { flagNonImplementation() }
	open func order() { flagNonImplementation() }

	// todo a change is needed here, as both viewDidAppear() and approach() call order(), because we don't know which will come first and both need to happen before the view is properly initialised and can do things. BUT there are two problems with this: 1. if order() updates the GUI then there may be a split second at the start of the screen where text etc. will show placeholder content; and 2. it relies upon the developer to run her own conditional code in order() (or afterwards) to check for full initialisation (as is currently happening in GameCustomer with: guard timeLabel != nil else...)
	override open func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		order()
	}
}

extension DTCustomer: DTCustomerProtocol {
	public final func approach() { order() }
}
