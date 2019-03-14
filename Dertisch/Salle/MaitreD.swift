//
//  MaitreD.swift
//  Dertisch
//
//  Created by Richard Willis on 12/11/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//
// todo "All rights reserved" needs changing to MIT licence somehow

import UIKit



public protocol MaitreDRegistrar {
	func register(
		_ resourceType: KitchenResource.Type,
		with key: String,
		injecting dependencyTypes: [KitchenResource.Type]?)
	// tood these need packaging into WaiterTypeContainer structs or similar
	func introduce(
		_ customerId: String,
		with key: String,
		customer: CustomerPersonality,
		waiter: WaiterPersonality?,
		headChef: HeadChefPersonality?,
		kitchenResources: [KitchenResource.Type]?,
		customerable: Customerable.Type?,
		waiterable: Waiterable.Type?)
}

public protocol MaitreDExtension {
	func registerStaff(with key: String)
}



fileprivate typealias SeatTicket = (seat: Seat, id: String, animated: Bool)

public class MaitreD {
	private let
	key: String,
	sommelier: Sommelier
	
	private var
	resources: Dictionary<String, KitchenResource>,
	colleagueRelationships: [String: ColleagueRelationships],
	window: UIWindow!,
	backgroundSeats: [SeatTicket],
	currentRelationships: StaffRelationship?,
	menuRelationships: StaffRelationship?
	
	// todo is there a better way to keep a ref to the maitre d than a property in AppDelegate?
	required public init() {
		key = NSUUID().uuidString
		resources = [:]
		colleagueRelationships = [:]
		backgroundSeats = []
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
		customer.seat.present(alert, animated: true)
	}
	
//	public func createNibFrom(name nibName: String, for owner: Customer) -> UIView? {
//		guard let viewArray = Bundle.main.loadNibNamed(nibName, owner: owner, options: nil) else { return nil }
//		return viewArray[0] as? UIView
//	}
	
	public func greet(firstCustomer customerId: String, through window: UIWindow, from storyboard: String? = nil) {
		guard self.window == nil else { return }
		Time.startInterval()
		guard let maitreDExtension = self as? MaitreDExtension else { return }
		maitreDExtension.registerStaff(with: key)
		guard
			let rootRelationships = createColleagues(customerId: customerId, animated: false, storyboard: storyboard),
			let rootSeat = rootRelationships.customer?.seat
			else {
				return }
		currentRelationships = rootRelationships
		self.window = window
		self.window.makeKeyAndVisible()
		self.window.rootViewController = rootSeat
		currentRelationships!.waiter?.beginShift()
		currentRelationships!.headChef?.beginShift()
	}
	
	public func present(popoverMenu menuId: String, inside rect: CGRect? = nil, from storyboard: String? = nil) {
		guard
			menuRelationships == nil,
			let currentCustomer = currentRelationships?.customer,
			let key = currentRelationships?.key,
			let nextMenuRelationships = createColleagues(customerId: menuId, animated: true, storyboard: storyboard),
			let menuTableAndChair = nextMenuRelationships.customer?.seat
			else { return }
		menuRelationships = nextMenuRelationships
		currentCustomer.forMaitreD(key)?.peruseMenu()
		// tood GC is this assignation necessary?
		currentRelationships?.waiter?.beginBreak()
		currentRelationships?.headChef?.beginBreak()
		
		guard let nextSeat = menuRelationships!.customer?.seat else { return }
		let currentSeat = currentCustomer.seat

		nextSeat.modalPresentationStyle = .popover
		currentSeat.present(menuTableAndChair, animated: true)
		nextSeat.popoverPresentationController?.sourceView = currentSeat.view
		if let safeRect = rect {
			nextSeat.popoverPresentationController?.sourceRect = safeRect
		}
		
		menuRelationships!.waiter?.beginShift()
		menuRelationships!.headChef?.beginShift()
	}
	
	public func removeMenu(_ order: CustomerOrder? = nil) {
		guard menuRelationships != nil else { return }
		menuRelationships!.customer?.seat.dismiss(animated: true) { [unowned self] in
			guard let key = self.currentRelationships?.key else { return }
			self.currentRelationships?.customer?.forMaitreD(key)?.menuReturnedToWaiter(order)
		}
		endShift(for: menuRelationships)
		menuRelationships = nil
		guard
			currentRelationships != nil,
			let key = self.currentRelationships?.key
			else { return }
		currentRelationships!.headChef?.endBreak()
		currentRelationships!.waiter?.endBreak()
		currentRelationships!.customer?.forMaitreD(key)?.returnMenuToWaiter(order)
		currentRelationships!.customer?.forSommelier(key)?.regionChosen()
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
		let currentSeat = currentCustomer.seat
		let nextSeat = nextCustomer.seat
		let ticket = SeatTicket(seat: currentSeat, id: currentRelationships!.customerID, animated: animated)
		backgroundSeats.append(ticket)
		endShift(for: currentRelationships)
		// tood GC is this nillification necessary?
		currentRelationships = nil
		currentRelationships = nextCurrentRelationships
		
		if animated {
			currentRelationships!.customer?.seat.modalTransitionStyle = transitionStyle!
		}
		
		currentSeat.present(nextSeat, animated: animated)
		currentRelationships!.waiter?.beginShift()
		currentRelationships!.headChef?.beginShift()
	}
	
	public func usherOutCurrentCustomer() {
		guard
			currentRelationships != nil,
			let formerSeat = self.backgroundSeats.popLast(),
			let formerRelationships = self.createColleagues(from: formerSeat)
			else { return }
		currentRelationships!.customer?.seat.dismiss(animated: currentRelationships!.animated) { [unowned self] in
			self.endShift(for: self.currentRelationships)
			self.currentRelationships = formerRelationships
			self.currentRelationships!.waiter?.beginShift()
			self.currentRelationships!.headChef?.beginShift()
		}
	}
	
	
	
	
	
	private func createColleagues(customerId: String, animated: Bool, storyboard: String? = nil) -> StaffRelationship? {
		guard
			colleagueRelationships[customerId] != nil else {
			return nil }
		let seatId = "\(customerId)\(CommonPhrases.Seat)"
		guard let seat = UIStoryboard(
			name: storyboard ?? "Main",
			bundle: nil).instantiateViewController(withIdentifier: seatId) as? Seat else {
				return nil }
		let ticket = SeatTicket(seat: seat, id: customerId, animated: animated)
		return createColleagues(from: ticket)
	}
	
	private func createColleagues(from ticket: SeatTicket) -> StaffRelationship? {
		guard
			let colleagueRelationship = colleagueRelationships[ticket.id]
//			let internalCustomerableType = colleagueRelationship.internalCustomerableType
			else { return nil }
		let key = "\(ticket.id)-\(NSUUID().uuidString)"
		let seat = ticket.seat
		let customer = Customer(
			key,
			seat,
			colleagueRelationship.customerForSeatType,
			colleagueRelationship.customerForMaitreDType,
			colleagueRelationship.customerForSommelierType,
			colleagueRelationship.customerForWaiterType)
		let headChef = colleagueRelationship.hasHeadChef ?
			HeadChef(
				key,
				colleagueRelationship.headChefForWaiterType,
				colleagueRelationship.headChefForSousChefType,
				getResources(from: colleagueRelationship.kitchenResourceTypes)) :
			nil
		let waiter: Waiter?
		if colleagueRelationship.hasWaiter {
			waiter = Waiter(
				key,
				colleagueRelationship.waiterForCustomerType!,
				colleagueRelationship.waiterForHeadChefType)
		} else {
			waiter = nil
		}
		
		customer.inject(waiter?.forCustomer(key))
		waiter?.inject(customer.forWaiter(key), headChef?.forWaiter(key))
		headChef?.inject(waiter?.forHeadChef(key))
		seat.customer = customer.forSeat(key)
		seat.key = key
		return StaffRelationship(
			customerID: ticket.id,
			key: key,
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
		let key = formerRelationship!.key
		formerRelationship!.customer?.forWaiter(key)?.serveBill()
		formerRelationship!.waiter?.endShift()
		formerRelationship!.headChef?.endShift()
	}
}

extension MaitreD: MaitreDRegistrar {
	public func introduce(
		_ customerId: String,
		with key: String,
		customer: CustomerPersonality,
		waiter: WaiterPersonality?,
		headChef: HeadChefPersonality?,
		kitchenResources: [KitchenResource.Type]?,
		customerable: Customerable.Type?,
		waiterable: Waiterable.Type?) {
		guard
			key == self.key,
			colleagueRelationships[customerId] == nil
			else { return }
		let strongCustomerable = customerable == nil ? Customer.self : customerable!
		let strongWaiterable = waiterable == nil ? Waiter.self : waiterable!
		colleagueRelationships[customerId] = ColleagueRelationships(
			customerableType: strongCustomerable,
			customerForSeatType: customer.forSeat,
			customerForMaitreDType: customer.forMaitreD,
			customerForSommelierType: customer.forSommelier,
			customerForWaiterType: customer.forWaiter,
			waiterableType: strongWaiterable,
			waiterForCustomerType: waiter?.forCustomer,
			waiterForHeadChefType: waiter?.forHeadChef,
			headChefForWaiterType: headChef?.forWaiter,
			headChefForSousChefType: headChef?.forSousChef,
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
