//
//  RestaurantTable.swift
//  Cirk
//
//  Created by Richard Willis on 01/02/2019.
//  Copyright © 2019 Rich Text Format Ltd. All rights reserved.
//

import UIKit

open class RestaurantTable: UIViewController {
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		ownKey = ""
	}
	
	var customer: CustomerForRestaurantTable? {
		get { return nil }
		set { ownCustomer = newValue }
	}
	
	var key: String? {
		get { return nil }
		set { ownKey = newValue }
	}
	
	private var
	ownCustomer: CustomerForRestaurantTable?,
	ownKey: String!
	
	override open func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		guard ownKey != nil else { return }
		ownCustomer?.isSeated(ownKey)
	}
	
	override open func viewDidLoad() {
		super.viewDidLoad()
		guard ownKey != nil else { return }
		ownCustomer?.tableAssigned(ownKey)
	}
	
	override open func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		ownCustomer = nil
	}
}
