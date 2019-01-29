//
//  DT_SV_Routing.swift
//  Dertisch
//
//  Created by Richard Willis on 12/11/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//
// todo "All rights reserved" needs changing to MIT licence somehow

import UIKit



public protocol MaitreDExtension {
	func registerStaff(with key: String)
}

public protocol MaitreDRegistrar {
	func register(
		_ modelClassType: KitchenResource.Type,
		with key: String,
		injecting dependencyTypes: [KitchenResource.Type]?)
	func introduce(
		_ customerId: String,
		as customerType: CustomerProtocol.Type,
		with key: String,
		waiter waiterType: Waiter.Type?,
		chef headChefType: HeadChef.Type?,
		kitchenStaff kitchenStaffTypes: [KitchenResource.Type]?)
}

public protocol MaitreDProtocol: MaitreDRegistrar {
//	var menuId: String? { get }
//	func alert(actions: [UIAlertAction], title: String?, message: String?, style: UIAlertController.Style?)
//	func closeRestaurant()
//	func createNibFrom(name nibName: String, for owner: Customer) -> UIView?
//	func greet(firstCustomer customerId: String, through window: UIWindow, from storyboard: String?)
//	func present(popoverMenu menuId: String, inside rect: CGRect?, from storyboard: String?)
//	// todo is there a better solution to getting popover results to the underlying VC than passing chosenDishId?
//	func removeMenu(_ chosenDishId: String?)
//	func seat(_ customerId: String, via transitionStyle: UIModalTransitionStyle?, from storyboard: String?)
//	func usherOutCurrentCustomer()
}



fileprivate typealias CustomerTicket = (customer: Customer, id: String)

public class MaitreD {
	private let
	key: String,
	sommelier: Sommelier
	
	private var
	resources: Dictionary<String, KitchenResource>,
	switchesRelationships: Dictionary<String, InternalSwitchRelationship>,
	window: UIWindow!,
	formerCustomers: [CustomerTicket],
//	rootSwitches: SwitchesRelationship?,
	currentSwitches: SwitchesRelationship?,
	menuSwitches: SwitchesRelationship?
	
	required public init() {
		lo()
		key = NSUUID().uuidString
		resources = [:]
		switchesRelationships = [:]
		formerCustomers = []
		let driedFoods = DriedFoods()
		resources[DriedFoods.staticId] = driedFoods
		sommelier = Sommelier(driedFoods: driedFoods)
	}
}



extension MaitreD: MaitreDProtocol {
	public func alert(
		actions: [UIAlertAction],
		title: String? = nil,
		message: String? = nil,
		style: UIAlertController.Style? = .alert) {
		guard let customer = currentSwitches?.customer else { return }
		let
		alert = UIAlertController(title: title, message: message, preferredStyle: style!),
		countActions = actions.count
		for i in 0..<countActions {
			alert.addAction(actions[i])
		}
		customer.present(alert, animated: true)
	}
	
	public func closeRestaurant() {
		currentSwitches?.endShift()
		menuSwitches?.endShift()
		//		exit(1)
	}
	
	public func createNibFrom(name nibName: String, for owner: Customer) -> UIView? {
		guard let viewArray = Bundle.main.loadNibNamed(nibName, owner: owner, options: nil) else { return nil }
		return viewArray[0] as? UIView
	}
	
	public func greet(firstCustomer customerId: String, through window: UIWindow, from storyboard: String? = nil) {
		lo()
		// todo should this be a fatal error?
		guard self.window == nil else { return }
		Time.startInterval()
		registerStaff(with: key)
		
		guard let rootSwitches = createBundle(from: customerId, and: storyboard) else { return }
		currentSwitches = rootSwitches
		currentSwitches!.waiter?.beginShift()
		currentSwitches!.headChef?.beginShift()
		self.window = window
		self.window.makeKeyAndVisible()
		self.window.rootViewController = rootSwitches.customer
		formerCustomers.append((customer: rootSwitches.customer!, id: customerId))
		sommelier.set(currentSwitches!.customer)
	}
	
	public func introduce(
		_ customerId: String,
		as customerType: CustomerProtocol.Type,
		with key: String,
		waiter waiterType: Waiter.Type? = nil,
		chef headChefType: HeadChef.Type? = nil,
		kitchenStaff kitchenStaffTypes: [KitchenResource.Type]? = nil) {
		guard
			switchesRelationships[customerId] == nil,
			key == self.key
			else { return }
		switchesRelationships[customerId] = InternalSwitchRelationship(
			customerType: customerType,
			waiterType: waiterType,
			headChefType: headChefType,
			kitchenStaffTypes: kitchenStaffTypes)
	}
	
	public func present(popoverMenu menuId: String, inside rect: CGRect? = nil, from storyboard: String? = nil) {
		lo()
		guard
			menuSwitches == nil,
			let currentCustomer = currentSwitches?.customer,
			let menuBundle = createBundle(from: menuId, and: storyboard),
			let menuCustomer = menuBundle.customer
			else { return }
		menuSwitches = menuBundle
		currentSwitches?.headChef?.beginBreak()
		currentSwitches?.waiter?.beginBreak()
		currentCustomer.peruseMenu()
		menuSwitches!.waiter?.beginShift()
		menuSwitches!.headChef?.beginShift()
		menuSwitches!.customer?.modalPresentationStyle = .popover
		currentCustomer.present(menuCustomer, animated: true)
		menuSwitches!.customer?.popoverPresentationController?.sourceView = currentCustomer.view
		if let safeRect = rect {
			menuSwitches!.customer?.popoverPresentationController?.sourceRect = safeRect
		}
	}
	
	/*
	public func register(
	_ kitchenStaffType: KitchenMember.Type,
	with key: String,
	injecting dependencyTypes: [KitchenMember.Type]? = nil) {
	guard key == self.key else { return }
	let kitchenClasses = getResources(from: dependencyTypes)
	let kitchenStaffMember = kitchenStaffType.init(kitchenClasses)
	self.kitchenStaff[kitchenStaffType.staticId] = kitchenStaffMember
	kitchenStaffMember.beginShift()
	}
*/
	
	// todo when registering Images: ingredients we should automatically do UrlSession too
	public func register(
		_ resourceType: KitchenResource.Type,
		with key: String,
		injecting dependencyTypes: [KitchenResource.Type]? = nil) {
		guard key == self.key else { return }
		let
		resourceDependencies = getResources(from: dependencyTypes),
		resource = resourceType.init(resourceDependencies)
		self.resources[resourceType.staticId] = resource
		resource.beginShift()
	}
	
	public func removeMenu(_ chosenDishId: String? = nil) {
		lo()
		guard var strongMenuSwitches = menuSwitches else { return }
		strongMenuSwitches.customer?.dismiss(animated: true) //{}
		strongMenuSwitches.endShift()
		menuSwitches = nil
		currentSwitches?.headChef?.endBreak()
		currentSwitches?.waiter?.endBreak()
		currentSwitches?.customer?.returnMenuToWaiter(chosenDishId)
	}
	
	public func seat(
		_ customerId: String,
		via transitionStyle: UIModalTransitionStyle? = nil,
		from storyboard: String? = nil) {
		lo()
		guard
			let currentCustomer = currentSwitches?.customer,
			var switchBundle = createBundle(from: customerId, and: storyboard),
			let switchCustomer = switchBundle.customer
			else { return }
		let animated = transitionStyle != nil
		if animated {
			switchBundle.customer?.modalTransitionStyle = transitionStyle!
		}
		var formerSwitches = currentSwitches
		currentSwitches = switchBundle
		currentCustomer.present(switchCustomer, animated: animated)
		formerSwitches?.endShift()
		switchBundle.animated = animated
		currentSwitches!.waiter?.beginShift()
		currentSwitches!.headChef?.beginShift()
		sommelier.set(currentCustomer)
	}
	
	public func usherOutCurrentCustomer() {
		lo()
		guard currentSwitches != nil else { return }
		currentSwitches!.customer?.dismiss(animated: currentSwitches!.animated) { [unowned self] in
			self.currentSwitches!.endShift()
			guard let formerCustomer = self.formerCustomers.popLast() else { return }
			self.currentSwitches = self.createBundle(from: formerCustomer)
			self.currentSwitches!.waiter?.beginShift()
			self.currentSwitches!.headChef?.beginShift()
		}
	}
	
	
	
	
	
	internal func customer(for staffMember: SwitchesRelationshipProtocol) -> Customer? {
		switch true {
		case staffMember === currentSwitches?.waiter:	return currentSwitches!.customer
		case staffMember === menuSwitches?.waiter:		return menuSwitches!.customer
		default: 										return nil
		}
	}
	
	internal func headChef(for staffMember: SwitchesRelationshipProtocol) -> HeadChef? {
		switch true {
		case staffMember === currentSwitches?.waiter:	return currentSwitches!.headChef
		case staffMember === menuSwitches?.waiter:		return menuSwitches!.headChef
		default: 										return nil
		}
	}
	
	// todo? change to conditional conformance (I wish I had made this more explicit, now I'm not sure what "change to conditional conformance" means in this context)
	internal func waiter(for staffMember: SwitchesRelationshipProtocol) -> Waiter? {
		switch true {
		case staffMember === currentSwitches?.headChef,
			 staffMember === currentSwitches?.customer,
			 staffMember === currentSwitches?.waiter:	return currentSwitches!.waiter
		case staffMember === menuSwitches?.headChef,
			 staffMember === menuSwitches?.customer,
			 staffMember === menuSwitches?.waiter:		return menuSwitches!.waiter
		default: 										return nil
		}
	}
	
	
	
	
	
	private func createBundle(from ticket: CustomerTicket) -> SwitchesRelationship? {
		lo()
		guard let switchesRelationship = switchesRelationships[ticket.id] else { return nil }
		let
		kitchenStaff = getResources(from: switchesRelationship.kitchenStaffTypes),
		headChef = switchesRelationship.headChefType != nil ?
			switchesRelationship.headChefType!.init(kitchenStaff) :
			nil,
		waiter = switchesRelationship.waiterType != nil ?
			switchesRelationship.waiterType!.init(maitreD: self, customer: ticket.customer, headChef: headChef) :
			GeneralWaiter(maitreD: self, customer: ticket.customer, headChef: headChef)
		headChef?.waiter = waiter
		ticket.customer.assign(waiter, maitreD: self, and: sommelier)
		return SwitchesRelationship(
			customerID: ticket.id,
			customer: ticket.customer,
			waiter: waiter,
			headChef: headChef,
			animated: false)
	}
	
	private func createBundle(from customerId: String, and storyboard: String? = nil) -> SwitchesRelationship? {
		guard
			switchesRelationships[customerId] != nil,
			let customer = UIStoryboard(
				name: storyboard ?? "Main",
				bundle: nil).instantiateViewController(withIdentifier: customerId) as? Customer
			else { return nil }
		return createBundle(from: (customer: customer, id: customerId))
	}
	
	private func getResources(from dependencyTypes: [KitchenResource.Type]?) -> [String: KitchenResource]? {
		guard dependencyTypes?.count ?? -1 > 0 else { return nil }
		var resources: [String: KitchenResource] = [:]
		for dependencyType in dependencyTypes! {
			let dependencyId = dependencyType.staticId
			if let dependencyClass = self.resources[dependencyId] {
				resources[dependencyId] = dependencyClass
			}
		}
		return resources
	}
	
	private func searchFor(
		_ colleagueA: SwitchesRelationshipProtocol,
		and colleagueB: SwitchesRelationshipProtocol,
		in switchesRelationship: SwitchesRelationship?) -> Bool {
		guard let switches = switchesRelationship else { return false }
//		lo(colleagueA === switches.customer, colleagueA === switches.waiter, colleagueA === switches.headChef, colleagueB === switches.customer, colleagueB === switches.waiter, colleagueB === switches.headChef)
		return  (colleagueA === switches.customer || colleagueA === switches.waiter || colleagueA === switches.headChef) &&
				(colleagueB === switches.customer || colleagueB === switches.waiter || colleagueB === switches.headChef)
	}
}
