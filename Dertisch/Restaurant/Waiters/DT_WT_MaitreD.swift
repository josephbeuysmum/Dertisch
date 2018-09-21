//
//  DT_SV_Routing.swift
//  Dertisch
//
//  Created by Richard Willis on 12/11/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

import UIKit

public enum DTPresentations {
	case curl, dissolve, flip, rise, show
}

extension DTMaitreD: DTMaitreDProtocol {
//	public var closet: DTKitchenCloset { return closet_ }

	public var hasPopover: Bool {
		return side_customer_relationship != nil
	}
	
	public func startShift() {}
	
	public func alert(actions: [UIAlertAction], title: String? = nil, message: String? = nil, style: UIAlertController.Style? = .alert) {
		guard let customer = customer_relationship?.customer else { return }
		let
		alert = UIAlertController(title: title, message: message, preferredStyle: style!),
		countActions = actions.count
		for i in 0..<countActions {
			alert.addAction(actions[i])
		}
		customer.present(alert, animated: true)
	}
	
	public func createNibFrom(name nibName: String, for owner: DTCustomer) -> UIView? {
		guard let viewArray = Bundle.main.loadNibNamed(nibName, owner: owner, options: nil) else { return nil }
		return viewArray[0] as? UIView
	}
	
	public func create(_ customerId: String, from storyboard: String? = nil) -> DTCustomer? {
		return create_bundle(from: customerId, and: storyboard)?.customer
	}
	
//	public func createAlertWith(
//		title: String,
//		message: String,
//		buttonLabel: String,
//		handler: @escaping((UIAlertAction) -> Void),
//		plusExtraButtonLabel extraButtonLabel: String? = nil) -> UIAlertController {
//		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
//		// copy
//		alert.addAction(UIAlertAction(title: buttonLabel, style: UIAlertActionStyle.default, handler: handler))
//		if extraButtonLabel != nil {
//			alert.addAction(UIAlertAction(title: extraButtonLabel!, style: UIAlertActionStyle.default, handler: nil))
//		}
//		return alert
//	}
	
	public func dismissPopover() {
		guard hasPopover else { return }
		side_customer_relationship!.customer?.dismiss(animated: true) {
			self.side_customer_relationship!.cleanUp()
			self.side_customer_relationship = nil
			self.orders_.make(order: DTOrderConsts.popoverRemoved)
		}
	}
	
	public func greet(firstCustomer: String, window: UIWindow, storyboard: String? = nil) {
		guard
			window_ == nil,
			self is DTMaitreDExtensionProtocol
			else { return }
		(self as! DTMaitreDExtensionProtocol).registerStaff(with: key_)
		window_ = window
		window_.makeKeyAndVisible()
		seat(firstCustomer, from: storyboard)
	}
	
	public func popover(
		_ customerId: String,
		inside rect: CGRect? = nil,
		from storyboard: String? = nil) {
		guard
			!hasPopover,
			let currentCustomer = customer_relationship?.customer,
			let viperBundle = create_bundle(from: customerId, and: storyboard),
			let popover = viperBundle.customer
			else { return }
		popover.modalPresentationStyle = .popover
		currentCustomer.present(popover, animated: true) {
			self.orders_.make(order: DTOrderConsts.popoverAdded)
		}
		popover.popoverPresentationController?.sourceView = currentCustomer.view
		if let safeRect = rect {
			popover.popoverPresentationController?.sourceRect = safeRect
		}
		side_customer_relationship = viperBundle
	}
	
	public func register(
		_ kitchenStaffType: DTKitchenProtocol.Type,
		with key: String,
		injecting dependencyTypes: [DTKitchenProtocol.Type]? = nil) {
		guard can_register(with: key) else { return }
		// todo why does this not print?
		print(kitchenStaffType)
		let kitchenStaffMembers = get_kitchen_staff(from: dependencyTypes)
//		if let strongDependencyTypes = dependencyTypes {
//			kitchenStaffMembers = [:]
//			for dependencyType in strongDependencyTypes {
//				let dependencyId = dependencyType.staticId
//				if let dependencyClass = kitchen_staff_singletons[dependencyId] {
//					kitchenStaffMembers![dependencyId] = dependencyClass
//				} else {
//					fatalError("Attempting to inject a model class that has not been registered itself yet")
//				}
//			}
//		}
		let kitchenStaff = kitchenStaffType.init(orders: orders_, kitchenStaffMembers: kitchenStaffMembers)
		kitchen_staff_singletons[kitchenStaffType.staticId] = kitchenStaff
		kitchenStaff.startShift()
	}
	
	// todo some waiters and view controllers do not need an headChef (intro page in Cirk for example) and this registation should handle that case too
	public func register(
		_ customerId: String,
		as customerType: DTCustomerProtocol.Type,
		with waiterType: DTWaiterProtocol.Type,
		and headChefType: DTHeadChefProtocol.Type,
		lockedBy key: String,
		andInjecting kitchenStaffTypes: [DTKitchenProtocol.Type]? = nil) {
		guard
			switch_relationships[customerId] == nil,
			can_register(with: key)
			else { return }
		switch_relationships[customerId] = DTStaffRelationship(
			customerType: customerType,
			headChefType: headChefType,
			waiterType: waiterType,
			kitchenStaffTypes: kitchenStaffTypes)
	}
	
	public func seat(_ customerId: String, from storyboard: String? = nil) {
		guard let viperBundle = create_bundle(from: customerId, and: storyboard) else { return }
		window_.rootViewController = viperBundle.customer
		customer_relationship = viperBundle
	}
	
	public func seatNew(
		_ customerId: String,
		beAnimated animated: Bool? = true,
		via presentationType: DTPresentations? = nil,
		from storyboard: String? = nil) {
		let presentationType = presentationType ?? DTPresentations.show
		guard
			let currentCustomer = customer_relationship?.customer,
			let viperBundle = create_bundle(from: customerId, and: storyboard),
			let customer = viperBundle.customer
			else { return }
		switch presentationType {
		case .curl:			customer.modalTransitionStyle = .partialCurl
		case .dissolve:		customer.modalTransitionStyle = .crossDissolve
		case .flip:			customer.modalTransitionStyle = .flipHorizontal
		case .rise:			customer.modalTransitionStyle = .coverVertical
		default:			()
		}
		currentCustomer.present(customer, animated: animated!) {
			currentCustomer.removeFromParent()
			self.orders_.make(order: DTOrderConsts.viewRemoved)
		}
		customer_relationship?.cleanUp()
		customer_relationship = viperBundle
	}
	

	
	fileprivate func can_register(with key: String) -> Bool {
		return is_activated == false && key == key_
	}
	
	fileprivate func create_bundle(from customerId: String, and storyboard: String? = nil) -> DTSwitchRelationship? {
		lo(customerId)
		guard
			let vipRelationship = switch_relationships[customerId],
			let customer = UIStoryboard(name: get_(storyboard), bundle: nil).instantiateViewController(withIdentifier: customerId) as? DTCustomer
			else { return nil }
		var
		waiter = vipRelationship.waiterType.init(orders: orders_, maitreD: self),
		headChef = vipRelationship.headChefType.init(
			orders: orders_,
			waiter: waiter,
			kitchenStaff: get_kitchen_staff(from: vipRelationship.kitchenStaffTypes))
		headChef.startShift()
		waiter.startShift()
		customer.pass(orders_, to: waiter)
		return DTSwitchRelationship(customer: customer, headChef: headChef, waiter: waiter)
	}
	
	fileprivate func get_(_ storyboard: String?) -> String {
		return storyboard ?? "Main"
	}
	
//		headChef: inout DTHeadChefProtocol,
//		with waiter: DTWaiterProtocol,
	fileprivate func get_kitchen_staff(from dependencyTypes: [DTKitchenProtocol.Type]?) -> [String: DTKitchenProtocol]? {
		lo(dependencyTypes?.count)
		guard dependencyTypes?.count ?? -1 > 0 else { return nil }
		var kitchenStaff: [String: DTKitchenProtocol] = [:]
		for dependencyType in dependencyTypes! {
			let dependencyId = dependencyType.staticId
			if let dependencyClass = kitchen_staff_singletons[dependencyId] {
				kitchenStaff[dependencyId] = dependencyClass
				lo(dependencyId, dependencyClass)
			}
		}
		return kitchenStaff
	}
		
		
		
		
//		var kitchenStaff: [DTKitchenProtocol] = []
//		_ = dependencyTypes.map {
//			dependencyType in
//			if let dependencyClass = kitchen_staff_singletons[String(describing: dependencyType)] {
//				kitchenStaff.append(dependencyClass)
////				if dependencyClass is DTImages {
////					headChef.closet?.set(imageSousChef: dependencyClass as! DTImages)
////				} else {
////					headChef.closet?.bespoke.add(dependencyClass)
////				}
//			} else {
//				fatalError("Attempting to inject a model class that has not been registered itself yet")
//			}
//		}
//		headChef.closet?.set(ordersService: orders)
//		headChef.closet?.set(waiter: waiter)
//		headChef.activate()
//		return kitchenStaff
//	}
	
	// todo do these IA PR and VC need to be passed via set or can they be created here (so that we don't need setter functions on the entity collections)
//	fileprivate func initialise_(waiter: inout DTWaiterProtocol, with customer: DTCustomer) -> Bool {
//		guard let orders = closet_.orders(key_) else { return false }
//		waiter.closet?.set(ordersService: orders)
//		waiter.closet?.set(routing: self)
//		waiter.closet?.set(customer: customer)
//		waiter.activate()
//		return true
//	}
	
//	fileprivate func initialise_(customer: inout DTCustomer) -> Bool {
//		guard let orders = closet_.orders(key_) else { return false }
//		customer.set(ordersService: orders)
//		return true
//	}
}

public class DTMaitreD {
	fileprivate let
	orders_: DTOrders,
	key_: String
	
	fileprivate var
	is_activated: Bool,
	kitchen_staff_singletons: Dictionary<String, DTKitchenProtocol>,
	switch_relationships: Dictionary<String, DTStaffRelationship>,
//	key_: DTKey!,
//	closet_: DTKitchenCloset!,
	window_: UIWindow!,
	customer_relationship: DTSwitchRelationship?,
	side_customer_relationship: DTSwitchRelationship?

	required public init() {
		orders_ = DTOrders()
		key_ = NSUUID().uuidString // DTKey(self)
		is_activated = false
		kitchen_staff_singletons = [:]
		switch_relationships = [:]
//		closet_ = DTKitchenCloset(self, key: key_)
//		closet_.set(orders: DTOrders())
	}
}
