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
	func add(mainDish id: String, from storyboard: String?)
	func alert(actions: [UIAlertAction], title: String?, message: String?, style: UIAlertControllerStyle?)
	func createNibFrom(name nibName: String, for owner: DTDish) -> UIView?
	func create(_ dishId: String, from storyboard: String?) -> DTDish?
//	func createAlertWith(
//		title: String,
//		message: String,
//		buttonLabel: String,
//		handler: @escaping ((UIAlertAction) -> Void),
//		plusExtraButtonLabel extraButtonLabel: String?) -> UIAlertController
	func dismissPopover()
	func popover(_ dishId: String, inside rect: CGRect?, from storyboard: String?)
	func serve(_ dishId: String, animated: Bool?, via presentationType: Presentations?, from storyboard: String?)
	func greet(mainDish: String, window: UIWindow, storyboard: String?)
}

public protocol DTMaitreDExtensionProtocol {
	func registerDependencies(with key: String)
}

public protocol DTMaitreDRegistrarProtocol {
	func register(
		_ modelClassType: DTKitchenProtocol.Type,
		with key: String,
		injecting dependencyTypes: [DTKitchenProtocol.Type]?)
	func register(
		_ dishId: String,
		as dishType: DTDishProtocol.Type,
		with headChefType: DTHeadChefProtocol.Type,
		and waiterType: DTWaiterProtocol.Type,
		lockedBy key: String,
		andInjecting kitchenStaffTypes: [DTKitchenProtocol.Type]?)
}
