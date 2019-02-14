//
//  MaitreD.swift
//  Dertisch
//
//  Created by Richard Willis on 12/11/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//
// todo "All rights reserved" needs changing to MIT licence somehow

import UIKit



// tood move this elsewhere
//public typealias HeadChefTypes = (sousChef: HeadChefForSousChef.Type?, waiter: HeadChefForWaiter.Type?)

public protocol MaitreDRegistrar {
	func register(
		_ resourceType: KitchenResource.Type,
		with key: String,
		injecting dependencyTypes: [KitchenResource.Type]?)
	func introduce(
		_ customerId: String,
		with key: String,
		customerForRestaurantTable: CustomerForRestaurantTable.Type,
		customerForMaitreD: CustomerForMaitreD.Type,
		customerForSommelier: CustomerForSommelier.Type,
		customerForWaiter: CustomerForWaiter.Type?,
		waiterForCustomer: WaiterForCustomer.Type?,
		waiterForMaitreD: WaiterForMaitreD.Type?,
		waiterForHeadChef: WaiterForHeadChef.Type?,
//		waiter waiterType: Waiter.Type?,
		headChefForWaiter: HeadChefForWaiter.Type?,
		headChefForSousChef: HeadChefForSousChef.Type?,
		kitchenResources: [KitchenResource.Type]?)
}

public protocol MaitreDExtension {
	func registerStaff(with key: String)
}



fileprivate typealias RestaurantTableTicket = (restaurantTable: RestaurantTable, id: String, animated: Bool)

public class MaitreD {
	private let
	key: String,
	sommelier: Sommelier
	
	private var
	resources: Dictionary<String, KitchenResource>,
	colleagueRelationships: [String: ColleagueRelationships],
	window: UIWindow!,
	backgroundRestaurantTables: [RestaurantTableTicket],
	currentRelationships: StaffRelationship?,
	menuRelationships: StaffRelationship?
	
	required public init() {
		key = NSUUID().uuidString
		resources = [:]
		colleagueRelationships = [:]
		backgroundRestaurantTables = []
		let larder = Larder()
		resources[Larder.staticId] = larder
		sommelier = Sommelier(larder)
	}
}



extension MaitreD {
	public func alert(
		actions: [UIAlertAction],
		title: String? = nil,
		message: String? = nil,
		style: UIAlertController.Style? = .alert) {
		guard let customer = currentRelationships?.customer else { return }
		let
		alert = UIAlertController(title: title, message: message, preferredStyle: style!),
		countActions = actions.count
		for i in 0..<countActions {
			alert.addAction(actions[i])
		}
		customer.restaurantTable.present(alert, animated: true)
	}
	
//	public func createNibFrom(name nibName: String, for owner: Customer) -> UIView? {
//		guard let viewArray = Bundle.main.loadNibNamed(nibName, owner: owner, options: nil) else { return nil }
//		return viewArray[0] as? UIView
//	}
	
	public func greet(firstCustomer customerId: String, through window: UIWindow, from storyboard: String? = nil) {
		guard self.window == nil else { return }
		Time.startInterval()
		registerStaff(with: key)
		lo()
		guard
			let rootRelationships = createColleagues(customerId: customerId, animated: false, storyboard: storyboard),
			let rootRestaurantTable = rootRelationships.customer?.restaurantTable
			else {
				return }
		lo()
		currentRelationships = rootRelationships
		self.window = window
		self.window.makeKeyAndVisible()
		self.window.rootViewController = rootRestaurantTable
		currentRelationships!.waiter?.beginShift()
		currentRelationships!.headChef?.beginShift()
		lo()
	}
	
	public func present(popoverMenu menuId: String, inside rect: CGRect? = nil, from storyboard: String? = nil) {
		guard
			menuRelationships == nil,
			let currentCustomer = currentRelationships?.customer,
			let nextMenuRelationships = createColleagues(customerId: menuId, animated: true, storyboard: storyboard),
			let menuTableAndChair = nextMenuRelationships.customer?.restaurantTable
			else { return }
		menuRelationships = nextMenuRelationships
		
		currentCustomer.forMaitreD()?.peruseMenu()
		// tood GC is this assignation necessary?
		currentRelationships?.waiter?.beginBreak()
		currentRelationships?.headChef?.beginBreak()
		
		guard let nextRestaurantTable = menuRelationships!.customer?.restaurantTable else { return }
		let currentRestaurantTable = currentCustomer.restaurantTable

		nextRestaurantTable.modalPresentationStyle = .popover
		currentRestaurantTable.present(menuTableAndChair, animated: true)
		nextRestaurantTable.popoverPresentationController?.sourceView = currentRestaurantTable.view
		if let safeRect = rect {
			nextRestaurantTable.popoverPresentationController?.sourceRect = safeRect
		}
		
		menuRelationships!.waiter?.beginShift()
		menuRelationships!.headChef?.beginShift()
	}
	
	public func removeMenu(_ order: CustomerOrder? = nil) {
		guard menuRelationships != nil else { return }
		menuRelationships!.customer?.restaurantTable.dismiss(animated: true) { [unowned self] in
			self.currentRelationships?.customer?.forMaitreD()?.menuReturnedToWaiter(order)
		}
		endShift(for: menuRelationships)
		menuRelationships = nil
		guard currentRelationships != nil else { return }
		currentRelationships!.headChef?.endBreak()
		currentRelationships!.waiter?.endBreak()
		currentRelationships!.customer?.forMaitreD()?.returnMenuToWaiter(order)
		currentRelationships!.customer?.forSommelier()?.regionChosen()
	}
	
	public func seat(
		_ customerId: String,
		via transitionStyle: UIModalTransitionStyle? = nil,
		from storyboard: String? = nil) {
		let animated = transitionStyle != nil
		guard
			let currentCustomer = currentRelationships?.customer,
			let nextCurrentRelationships = createColleagues(
				customerId: customerId,
				animated: animated,
				storyboard: storyboard),
			let nextCustomer = nextCurrentRelationships.customer
			else { return }
		let currentRestaurantTable = currentCustomer.restaurantTable
		let nextRestaurantTable = nextCustomer.restaurantTable
		let ticket = RestaurantTableTicket(restaurantTable: currentRestaurantTable, id: currentRelationships!.customerID, animated: animated)
		backgroundRestaurantTables.append(ticket)
		endShift(for: currentRelationships)
		// tood GC is this nillification necessary?
		currentRelationships = nil
		currentRelationships = nextCurrentRelationships
		
		if animated {
			currentRelationships!.customer?.restaurantTable.modalTransitionStyle = transitionStyle!
		}
		
		currentRestaurantTable.present(nextRestaurantTable, animated: animated)
		currentRelationships!.waiter?.beginShift()
		currentRelationships!.headChef?.beginShift()
	}
	
	public func usherOutCurrentCustomer() {
		guard
			currentRelationships != nil,
			let formerRestaurantTable = self.backgroundRestaurantTables.popLast(),
			let formerRelationships = self.createColleagues(from: formerRestaurantTable)
			else { return }
		currentRelationships!.customer?.restaurantTable.dismiss(animated: currentRelationships!.animated) { [unowned self] in
			self.endShift(for: self.currentRelationships)
			self.currentRelationships = formerRelationships
			self.currentRelationships!.waiter?.beginShift()
			self.currentRelationships!.headChef?.beginShift()
		}
	}
	
	
	
	
	
	internal func customer(for staffMember: StaffRelatable) -> Customer? {
		switch true {
		case staffMember === currentRelationships?.waiter:		return currentRelationships!.customer
		case staffMember === menuRelationships?.waiter:			return menuRelationships!.customer
		default: 												return nil
		}
	}
	
	internal func headChef(for staffMember: StaffRelatable) -> HeadChef? {
		switch true {
		case staffMember === currentRelationships?.waiter:		return currentRelationships!.headChef
		case staffMember === menuRelationships?.waiter:			return menuRelationships!.headChef
		default: 												return nil
		}
	}
	
	// todo? change to conditional conformance (I wish I had made this more explicit, now I'm not sure what "change to conditional conformance" means in this context)
	internal func waiter(for staffMember: StaffRelatable) -> Waiter? {
		switch true {
		case staffMember === currentRelationships?.headChef,
			 staffMember === currentRelationships?.customer,
			 staffMember === currentRelationships?.waiter:		return currentRelationships!.waiter
		case staffMember === menuRelationships?.headChef,
			 staffMember === menuRelationships?.customer,
			 staffMember === menuRelationships?.waiter:			return menuRelationships!.waiter
		default: 												return nil
		}
	}
	
	
	
	
	
	private func createColleagues(customerId: String, animated: Bool, storyboard: String? = nil) -> StaffRelationship? {
		guard
			colleagueRelationships[customerId] != nil else {
			return nil }
		let restaurantTableId = "\(customerId)\(CommonPhrases.RestaurantTable)"
		guard let restaurantTable = UIStoryboard(
			name: storyboard ?? "Main",
			bundle: nil).instantiateViewController(withIdentifier: restaurantTableId) as? RestaurantTable else {
				return nil }
		let ticket = RestaurantTableTicket(restaurantTable: restaurantTable, id: customerId, animated: animated)
		return createColleagues(from: ticket)
	}
	
	private func createColleagues(from ticket: RestaurantTableTicket) -> StaffRelationship? {
		guard let colleagueRelationship = colleagueRelationships[ticket.id] else { return nil }
		let colleagueName = ticket.id
		let customer = Customer(colleagueName, ticket.restaurantTable)
		let headChef = colleagueRelationship.hasHeadChef ?
			HeadChef(colleagueName, getResources(from: colleagueRelationship.kitchenResourceTypes)) : nil
		let waiter = colleagueRelationship.hasWaiter ? Waiter(colleagueName) :  nil
		
		// tood reinstate general waiter
		lo("no general waiter currently")
		//		let waiter = colleagueRelationship.waiterType != nil ?
		//			colleagueRelationship.waiterType!.init(maitreD: self) :
		//			GeneralWaiter(maitreD: self)
		
		customer.inject(
			colleagueRelationship.customerForRestaurantTableType,
			colleagueRelationship.customerForMaitreDType,
			colleagueRelationship.customerForSommelierType,
			colleagueRelationship.customerForWaiterType,
			waiter?.forCustomer())
		waiter?.inject(
			colleagueRelationship.waiterForCustomerType!,
			colleagueRelationship.waiterForMaitreDType!,
			colleagueRelationship.waiterForHeadChefType!,
			customer.forWaiter(),
			headChef?.forWaiter())
		headChef?.inject(
			colleagueRelationship.headChefForWaiterType,
			colleagueRelationship.headChefForSousChefType,
			waiter?.forHeadChef())
		return StaffRelationship(
			customerID: ticket.id,
			animated: ticket.animated,
			customer: customer,
			waiter: waiter,
			headChef: headChef)
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
	
	private func endShift(for formerRelationship: StaffRelationship?) {
		guard formerRelationship != nil else { return }
		formerRelationship!.customer?.forWaiter()?.presentCheck()
		formerRelationship!.waiter?.endShift()
		formerRelationship!.headChef?.endShift()
	}
	
	private func searchFor(
		_ colleagueA: StaffRelatable,
		and colleagueB: StaffRelatable,
		in colleagueRelationship: StaffRelationship?) -> Bool {
		guard let colleagues = colleagueRelationship else { return false }
//		lo(colleagueA === colleagues.customer, colleagueA === colleagues.waiter, colleagueA === colleagues.headChef, colleagueB === colleagues.customer, colleagueB === colleagues.waiter, colleagueB === colleagues.headChef)
		return  (colleagueA === colleagues.customer || colleagueA === colleagues.waiter || colleagueA === colleagues.headChef) &&
				(colleagueB === colleagues.customer || colleagueB === colleagues.waiter || colleagueB === colleagues.headChef)
	}
}

extension MaitreD: MaitreDRegistrar {
	public func introduce(
		_ customerId: String,
		with key: String,
		customerForRestaurantTable: CustomerForRestaurantTable.Type,
		customerForMaitreD: CustomerForMaitreD.Type,
		customerForSommelier: CustomerForSommelier.Type,
		customerForWaiter: CustomerForWaiter.Type?,
		waiterForCustomer: WaiterForCustomer.Type?,
		waiterForMaitreD: WaiterForMaitreD.Type?,
		waiterForHeadChef: WaiterForHeadChef.Type?,
//		waiter waiterType: Waiter.Type?,
		headChefForWaiter: HeadChefForWaiter.Type?,
		headChefForSousChef: HeadChefForSousChef.Type?,
		kitchenResources: [KitchenResource.Type]?) {
		guard
			key == self.key,
			colleagueRelationships[customerId] == nil
			else { return }
		colleagueRelationships[customerId] = ColleagueRelationships(
			customerForRestaurantTableType: customerForRestaurantTable,
			customerForMaitreDType: customerForMaitreD,
			customerForSommelierType: customerForSommelier,
			customerForWaiterType: customerForWaiter,
			waiterForCustomerType: waiterForCustomer,
			waiterForMaitreDType: waiterForMaitreD,
			waiterForHeadChefType: waiterForHeadChef,
			headChefForWaiterType: headChefForWaiter,
			headChefForSousChefType: headChefForSousChef,
			kitchenResourceTypes: kitchenResources)
	}
	
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
}
