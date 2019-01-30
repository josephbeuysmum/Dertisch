//
//  Customer.swift
//  Dertisch
//
//  Created by Richard Willis on 30/07/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

import UIKit

public protocol CustomerForWaiter: class {
	func approach()
	func present(dish dishId: String)
}

public protocol CustomerForSommelier {
	func regionChosen()
}

public protocol CustomerProtocol: CustomerForWaiter, CustomerForSommelier, SwitchesRelationshipProtocol {
	func assign(_ waiter: WaiterForCustomer, maitreD: MaitreD, and sommelier: Sommelier)
}

open class Customer: UIViewController {
	open func layTable() {}
	open func approach() {}
	open func assign(_ waiter: WaiterForCustomer, maitreD: MaitreD, and sommelier: Sommelier) {}
	open func presentCheck() {}
	open func peruseMenu() {}
	open func showToTable() {}
	open func present(dish dishId: String) {}
	open func regionChosen() {}
	open func returnMenuToWaiter(_ chosenDishId: String?) {}

	override final public func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		layTable()
	}
	
	override final public func viewDidLoad() {
		super.viewDidLoad()
		if let labels = Rota().all(UILabel.self, from: Mirror(reflecting: self)) {
			for label in labels {
				label.text = nil
			}
		}
		showToTable()
		regionChosen()
	}
}

extension Customer: CustomerProtocol {}
