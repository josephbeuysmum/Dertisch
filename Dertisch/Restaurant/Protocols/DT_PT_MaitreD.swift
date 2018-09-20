//
//  DT_PT_SV_A.swift
//  Dertisch
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import UIKit

public protocol DTMaitreDProtocol: DTMaitreDRegistrarProtocol {
	var hasPopover: Bool { get }
	func alert(actions: [UIAlertAction], title: String?, message: String?, style: UIAlertController.Style?)
	func createNibFrom(name nibName: String, for owner: DTCustomer) -> UIView?
	func create(_ customerId: String, from storyboard: String?) -> DTCustomer?
//	func createAlertWith(
//		title: String,
//		message: String,
//		buttonLabel: String,
//		handler: @escaping ((UIAlertAction) -> Void),
//		plusExtraButtonLabel extraButtonLabel: String?) -> UIAlertController
	func dismissPopover()
	func popover(_ customerId: String, inside rect: CGRect?, from storyboard: String?)
	func seat(_ customerId: String, from storyboard: String?)
	func serve(_ customerId: String, animated: Bool?, via presentationType: DTPresentations?, from storyboard: String?)
	func greet(firstCustomer: String, window: UIWindow, storyboard: String?)
}

public protocol DTMaitreDExtensionProtocol {
	func registerStaff(with key: String)
}

public protocol DTMaitreDRegistrarProtocol {
	func register(
		_ modelClassType: DTKitchenProtocol.Type,
		with key: String,
		injecting dependencyTypes: [DTKitchenProtocol.Type]?)
	func register(
		_ customerId: String,
		as customerType: DTCustomerProtocol.Type,
		with waiterType: DTWaiterProtocol.Type,
		and headChefType: DTHeadChefProtocol.Type,
		lockedBy key: String,
		andInjecting kitchenStaffTypes: [DTKitchenProtocol.Type]?)
}
