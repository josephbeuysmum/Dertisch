//
//  DT_SV_Routing.swift
//  Dertisch
//
//  Created by Richard Willis on 12/11/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

import UIKit

public enum Presentations {
	case curl, dissolve, flip, rise, show
}

extension DTMaitreD: DTMaitreDProtocol {
//	public var closet: DTKitchenCloset { return closet_ }

	public var hasPopover: Bool {
		return side_dish_relationship != nil
	}
	
	public func startShift() {}
	
	public func add(mainDish id: String, from storyboard: String? = nil) {
		guard let viperBundle = create_bundle(dish: id, from: storyboard) else { return }
		window_.rootViewController = viperBundle.dish
		dish_relationship = viperBundle
	}
	
	public func alert(actions: [UIAlertAction], title: String? = nil, message: String? = nil, style: UIAlertControllerStyle? = .alert) {
		guard let dish = dish_relationship?.dish else { return }
		let
		alert = UIAlertController(title: title, message: message, preferredStyle: style!),
		countActions = actions.count
		for i in 0..<countActions {
			alert.addAction(actions[i])
		}
		dish.present(alert, animated: true)
	}
	
	public func createNibFrom(name nibName: String, for owner: DTDish) -> UIView? {
		guard let viewArray = Bundle.main.loadNibNamed(nibName, owner: owner, options: nil) else { return nil }
		return viewArray[0] as? UIView
	}
	
	public func create(_ dishId: String, from storyboard: String? = nil) -> DTDish? {
		return create_bundle(dish: dishId, from: storyboard)?.dish
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
		side_dish_relationship!.dish?.dismiss(animated: true) {
			self.side_dish_relationship!.cleanUp()
			self.side_dish_relationship = nil
			self.orders_.make(order: DTOrderConsts.popoverRemoved)
		}
	}
	
	public func popover(
		_ dishId: String,
		inside rect: CGRect? = nil,
		from storyboard: String? = nil) {
		guard
			!hasPopover,
			let currentDish = dish_relationship?.dish,
			let viperBundle = create_bundle(dish: dishId, from: storyboard),
			let popover = viperBundle.dish
			else { return }
		popover.modalPresentationStyle = .popover
		currentDish.present(popover, animated: true) {
			self.orders_.make(order: DTOrderConsts.popoverAdded)
		}
		popover.popoverPresentationController?.sourceView = currentDish.view
		if let safeRect = rect {
			popover.popoverPresentationController?.sourceRect = safeRect
		}
		side_dish_relationship = viperBundle
	}
	
	public func serve(
		_ dishId: String,
		animated: Bool? = true,
		via presentation: Presentations? = nil,
		from storyboard: String? = nil) {
		let presentationType = presentation ?? Presentations.show
		guard
			let currentDish = dish_relationship?.dish,
			let viperBundle = create_bundle(dish: dishId, from: storyboard),
			let dish = viperBundle.dish
			else { return }
		switch presentationType {
		case .curl:			dish.modalTransitionStyle = .partialCurl
		case .dissolve:		dish.modalTransitionStyle = .crossDissolve
		case .flip:			dish.modalTransitionStyle = .flipHorizontal
		case .rise:			dish.modalTransitionStyle = .coverVertical
		default:			()
		}
		currentDish.present(dish, animated: animated!) {
			currentDish.removeFromParentViewController()
			self.orders_.make(order: DTOrderConsts.viewRemoved)
		}
		dish_relationship?.cleanUp()
		dish_relationship = viperBundle
	}
	
	public func register(
		_ kitchenStaffType: DTKitchenProtocol.Type,
		with key: String,
		injecting dependencyTypes: [DTKitchenProtocol.Type]? = nil) {
		guard can_register(with: key) else { return }
		var kitchenStaffMembers: [DTKitchenProtocol]?
		if let strongDependencyTypes = dependencyTypes {
			kitchenStaffMembers = []
			for dependencyType in strongDependencyTypes {
				if let dependencyClass = kitchen_staff_singletons[String(describing: dependencyType)] {
					kitchenStaffMembers!.append(dependencyClass)
				} else {
					fatalError("Attempting to inject a model class that has not been registered itself yet")
				}
			}
		}
		let kitchenStaff = kitchenStaffType.init(orders: orders_, kitchenStaffMembers: kitchenStaffMembers)
		kitchen_staff_singletons[String(describing: kitchenStaffType)] = kitchenStaff
		kitchenStaff.startShift()
	}
	
	// todo some waiters and view controllers do not need an headChef (intro page in Cirk for example) and this registation should handle that case too
	public func register(
		_ dishId: String,
		as dishType: DTDishProtocol.Type,
		with headChefType: DTHeadChefProtocol.Type,
		and waiterType: DTWaiterProtocol.Type,
		lockedBy key: String,
		andInjecting kitchenStaffTypes: [DTKitchenProtocol.Type]? = nil) {
		guard
			switch_relationships[dishId] == nil,
			can_register(with: key)
			else { return }
		switch_relationships[dishId] = DTStaffRelationship(
			dishType: dishType,
			headChefType: headChefType,
			waiterType: waiterType,
			kitchenStaffTypes: kitchenStaffTypes)
	}
	
	public func start(mainDish: String, window: UIWindow, storyboard: String? = nil) {
		guard
			window_ == nil,
			self is DTMaitreDExtensionProtocol
			else { return }
		(self as! DTMaitreDExtensionProtocol).registerDependencies(with: key_)
		window_ = window
		window_.makeKeyAndVisible()
		add(mainDish: mainDish, from: storyboard)
	}
	
	
	
	fileprivate func can_register(with key: String) -> Bool {
		return is_activated == false && key == key_
	}
	
	fileprivate func create_bundle(dish id: String, from storyboard: String? = nil) -> DTSwitchRelationship? {
		guard
			let vipRelationship = switch_relationships[id],
			let dish = UIStoryboard(name: get_(storyboard), bundle: nil).instantiateViewController(withIdentifier: id) as? DTDish
			else { return nil }
		let waiter = vipRelationship.waiterType.init(orders: orders_, maitreD: self)
		dish.set(orders_, and: waiter)
		let headChef = vipRelationship.headChefType.init(
			orders: orders_,
			waiter: waiter,
			kitchenStaff: get_head_chefkitchenStaff(from: vipRelationship.kitchenStaffTypes))
		waiter.startShift()
		headChef.startShift()
		return DTSwitchRelationship(dish: dish, headChef: headChef, waiter: waiter)
	}
	
	fileprivate func get_(_ storyboard: String?) -> String {
		return storyboard ?? "Main"
	}
	
	fileprivate func get_head_chefkitchenStaff(
//		headChef: inout DTHeadChefProtocol,
//		with waiter: DTWaiterProtocol,
		from dependencyTypes: [DTKitchenProtocol.Type]?) -> [DTKitchenProtocol]? {
		guard let dependencyTypes = dependencyTypes else { return nil }
		var kitchenStaff: [DTKitchenProtocol] = []
		_ = dependencyTypes.map {
			dependencyType in
			if let dependencyClass = kitchen_staff_singletons[String(describing: dependencyType)] {
				kitchenStaff.append(dependencyClass)
//				if dependencyClass is DTImages {
//					headChef.closet?.set(imageSousChef: dependencyClass as! DTImages)
//				} else {
//					headChef.closet?.bespoke.add(dependencyClass)
//				}
			} else {
				fatalError("Attempting to inject a model class that has not been registered itself yet")
			}
		}
//		headChef.closet?.set(ordersService: orders)
//		headChef.closet?.set(waiter: waiter)
//		headChef.activate()
		return kitchenStaff.count > 0 ? kitchenStaff : nil
	}
	
	// todo do these IA PR and VC need to be passed via set or can they be created here (so that we don't need setter functions on the entity collections)
//	fileprivate func initialise_(waiter: inout DTWaiterProtocol, with dish: DTDish) -> Bool {
//		guard let orders = closet_.orders(key_) else { return false }
//		waiter.closet?.set(ordersService: orders)
//		waiter.closet?.set(routing: self)
//		waiter.closet?.set(dish: dish)
//		waiter.activate()
//		return true
//	}
	
//	fileprivate func initialise_(dish: inout DTDish) -> Bool {
//		guard let orders = closet_.orders(key_) else { return false }
//		dish.set(ordersService: orders)
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
	dish_relationship: DTSwitchRelationship?,
	side_dish_relationship: DTSwitchRelationship?

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
