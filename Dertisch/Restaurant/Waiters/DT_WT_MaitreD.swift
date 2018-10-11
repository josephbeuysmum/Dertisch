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

public protocol DTMaitreDProtocol: DTMaitreDRegistrar {
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
	func seatNew(_ customerId: String, beAnimated animated: Bool?, via presentationType: DTPresentations?, from storyboard: String?)
	func greet(firstCustomer: String, window: UIWindow, storyboard: String?)
}

public protocol DTMaitreDExtension {
	func registerStaff(with key: String)
}

public protocol DTMaitreDRegistrar {
	func register(
		_ modelClassType: DTKitchenMember.Type,
		with key: String,
		injecting dependencyTypes: [DTKitchenMember.Type]?)
	func introduce(
		_ customerId: String,
		as customerType: DTCustomerProtocol.Type,
		to waiterType: DTWaiter.Type,
		with key: String,
		assignedChef headChefType: DTHeadChef.Type?,
		andKitchenStaff kitchenStaffTypes: [DTKitchenMember.Type]?)
}

extension DTMaitreD: DTMaitreDProtocol {
	public var hasPopover: Bool {
		return sideCustomerRelationship != nil
	}
	
	public func alert(
		actions: [UIAlertAction],
		title: String? = nil,
		message: String? = nil,
		style: UIAlertController.Style? = .alert) {
		guard let customer = customerRelationship?.customer else { return }
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
		return createBundle(from: customerId, and: storyboard)?.customer
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
		sideCustomerRelationship!.customer?.dismiss(animated: true) {
			self.sideCustomerRelationship!.cleanUp()
			self.sideCustomerRelationship = nil
//			self.orders_.make(order: DTOrderConsts.popoverRemoved)
		}
	}
	
	public func greet(firstCustomer: String, window: UIWindow, storyboard: String? = nil) {
		guard self.window == nil else { return }
		registerStaff(with: key)
		self.window = window
		self.window.makeKeyAndVisible()
		seat(firstCustomer, from: storyboard)
	}
	
	public func popover(
		_ customerId: String,
		inside rect: CGRect? = nil,
		from storyboard: String? = nil) {
		guard
			!hasPopover,
			let currentCustomer = customerRelationship?.customer,
			let switchBundle = createBundle(from: customerId, and: storyboard),
			let popover = switchBundle.customer
			else { return }
		popover.modalPresentationStyle = .popover
		currentCustomer.present(popover, animated: true) {
//			self.orders_.make(order: DTOrderConsts.popoverAdded)
		}
		popover.popoverPresentationController?.sourceView = currentCustomer.view
		if let safeRect = rect {
			popover.popoverPresentationController?.sourceRect = safeRect
		}
		sideCustomerRelationship = switchBundle
	}
	
	public func register(
		_ kitchenStaffType: DTKitchenMember.Type,
		with key: String,
		injecting dependencyTypes: [DTKitchenMember.Type]? = nil) {
		guard key == self.key else { return }
		let kitchenClasses = getKitchenStaff(from: dependencyTypes)
		let kitchenStaff = kitchenStaffType.init(kitchenMembers: kitchenClasses)
		kitchenStaffSingletons[kitchenStaffType.staticId] = kitchenStaff
	}
	
	public func introduce(
		_ customerId: String,
		as customerType: DTCustomerProtocol.Type,
		to waiterType: DTWaiter.Type,
		with key: String,
		assignedChef headChefType: DTHeadChef.Type? = nil,
		andKitchenStaff kitchenStaffTypes: [DTKitchenMember.Type]? = nil) {
		guard
			switchRelationships[customerId] == nil,
			key == self.key
			else { return }
		switchRelationships[customerId] = DTInternalSwitchRelationship(
			customerType: customerType,
			waiterType: waiterType,
			headChefType: headChefType,
			kitchenStaffTypes: kitchenStaffTypes)
	}
	
	public func seat(_ customerId: String, from storyboard: String? = nil) {
		guard let switchBundle = createBundle(from: customerId, and: storyboard) else { return }
		window.rootViewController = switchBundle.customer
		customerRelationship = switchBundle
	}
	
	public func seatNew(
		_ customerId: String,
		beAnimated animated: Bool? = true,
		via presentationType: DTPresentations? = nil,
		from storyboard: String? = nil) {
		let presentationType = presentationType ?? DTPresentations.show
		guard
			let currentCustomer = customerRelationship?.customer,
			let switchBundle = createBundle(from: customerId, and: storyboard),
			let customer = switchBundle.customer
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
		}
		customerRelationship?.cleanUp()
		customerRelationship = switchBundle
	}
	

	
	fileprivate func createBundle(from customerId: String, and storyboard: String? = nil) -> DTSwitchesRelationship? {
		guard
			let switchRelationship = switchRelationships[customerId],
			let customer = UIStoryboard(name: get_(storyboard), bundle: nil).instantiateViewController(withIdentifier: customerId) as? DTCustomer
			else { return nil }
		let
		waiter = switchRelationship.waiterType.init(maitreD: self, customer: customer),
		headChef = switchRelationship.headChefType != nil ?
			switchRelationship.headChefType!.init(
				waiter: waiter,
				sousChefs: getKitchenStaff(from: switchRelationship.kitchenStaffTypes)) :
			nil
		customer.assign(waiter, and: sommelier)
		return DTSwitchesRelationship(customer: customer, waiter: waiter, headChef: headChef)
	}
	
	fileprivate func get_(_ storyboard: String?) -> String {
		return storyboard ?? "Main"
	}
	
	fileprivate func getKitchenStaff(from dependencyTypes: [DTKitchenMember.Type]?) -> [String: DTKitchenMember]? {
		guard dependencyTypes?.count ?? -1 > 0 else { return nil }
		var kitchenStaff: [String: DTKitchenMember] = [:]
		for dependencyType in dependencyTypes! {
			let dependencyId = dependencyType.staticId
			if let dependencyClass = kitchenStaffSingletons[dependencyId] {
				kitchenStaff[dependencyId] = dependencyClass
			}
		}
		return kitchenStaff
	}
}

public class DTMaitreD {
	fileprivate let
	key: String,
	sommelier: DTSommelier
	
	fileprivate var
	kitchenStaffSingletons: Dictionary<String, DTKitchenMember>,
	switchRelationships: Dictionary<String, DTInternalSwitchRelationship>,
	window: UIWindow!,
	customerRelationship: DTSwitchesRelationship?,
	sideCustomerRelationship: DTSwitchesRelationship?

	required public init() {
		key = NSUUID().uuidString
		switchRelationships = [:]
		kitchenStaffSingletons = [:]
		let bundledJson = DTBundledJson()
		kitchenStaffSingletons[DTBundledJson.staticId] = bundledJson
		sommelier = DTSommelier(bundledJson: bundledJson)
	}
}
