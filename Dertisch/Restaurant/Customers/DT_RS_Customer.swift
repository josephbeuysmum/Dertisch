//
//  DT_Customer.swift
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
	open func layTable() { lo() }
	open func approach() { lo() }
	open func assign(_ waiter: WaiterForCustomer, maitreD: MaitreD, and sommelier: Sommelier) { lo() }
	open func presentCheck() { lo() }
	open func peruseMenu() { lo() }
	open func showToTable() { lo() }
	open func present(dish dishId: String) { lo() }
	open func regionChosen() { lo() }
	open func returnMenuToWaiter(_ chosenDishId: String?) { lo() }

	override final public func viewDidAppear(_ animated: Bool) {
		lo()
		super.viewDidAppear(animated)
		layTable()
	}
	
	override final public func viewDidLoad() {
		super.viewDidLoad()
		lo()
		if let labels = Rota().all(UILabel.self, from: Mirror(reflecting: self)) {
			for label in labels {
				label.text = nil
			}
		}
//		checkReadinessToOrder()
		showToTable()
		regionChosen()
	}
	
//	private final func checkReadinessToOrder() {
//		lo()
//		guard isViewLoaded, Rota().waiterForCustomer(self)?.onShift ?? false else { return }
//		showToTable()
//		regionChosen()
//	}
}

extension Customer: CustomerProtocol {}
