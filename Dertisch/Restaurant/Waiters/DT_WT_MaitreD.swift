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
		with key: String,
		waiter waiterType: DTWaiter.Type?,
		chef headChefType: DTHeadChef.Type?,
		kitchenStaff kitchenStaffTypes: [DTKitchenMember.Type]?)
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
		// todo sideCustomerRelationship is a weird name, change it
		sideCustomerRelationship!.customer?.dismiss(animated: true) {
			self.sideCustomerRelationship!.endShift()
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
		let kitchenStaffMember = kitchenStaffType.init(kitchenClasses)
		self.kitchenStaff[kitchenStaffType.staticId] = kitchenStaffMember
		kitchenStaffMember.startShift()
	}
	
	public func introduce(
		_ customerId: String,
		as customerType: DTCustomerProtocol.Type,
		with key: String,
		waiter waiterType: DTWaiter.Type? = nil,
		chef headChefType: DTHeadChef.Type? = nil,
		kitchenStaff kitchenStaffTypes: [DTKitchenMember.Type]? = nil) {
		guard
			switchesRelationships[customerId] == nil,
			key == self.key
			else { return }
		switchesRelationships[customerId] = DTInternalSwitchRelationship(
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
			// todo maybe don't do this?
			currentCustomer.removeFromParent()
		}
		customerRelationship?.endShift()
		customerRelationship = switchBundle
	}
	
	
	
	fileprivate func createBundle(from customerId: String, and storyboard: String? = nil) -> DTSwitchesRelationship? {
		guard
			let switchesRelationship = switchesRelationships[customerId],
			let customer = UIStoryboard(
				name: storyboard ?? "Main",
				bundle: nil).instantiateViewController(withIdentifier: customerId) as? DTCustomer
			else { return nil }
		let kitchenStaff = getKitchenStaff(from: switchesRelationship.kitchenStaffTypes)
		var headChef = switchesRelationship.headChefType != nil ? switchesRelationship.headChefType!.init(kitchenStaff) : nil
		let waiter = switchesRelationship.waiterType != nil ?
			switchesRelationship.waiterType!.init(customer: customer, maitreD: self, headChef: headChef) :
			GeneralWaiter(customer: customer, maitreD: self, headChef: headChef)
		headChef?.waiter = waiter
		customer.assign(waiter, and: sommelier)
		waiter.startShift()
		headChef?.startShift()
		return DTSwitchesRelationship(customer: customer, waiter: waiter, headChef: headChef)
	}
	
	fileprivate func getKitchenStaff(from dependencyTypes: [DTKitchenMember.Type]?) -> [String: DTKitchenMember]? {
		guard dependencyTypes?.count ?? -1 > 0 else { return nil }
		var kitchenStaff: [String: DTKitchenMember] = [:]
		for dependencyType in dependencyTypes! {
			let dependencyId = dependencyType.staticId
			if let dependencyClass = self.kitchenStaff[dependencyId] {
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
	kitchenStaff: Dictionary<String, DTKitchenMember>,
	switchesRelationships: Dictionary<String, DTInternalSwitchRelationship>,
	window: UIWindow!,
	customerRelationship: DTSwitchesRelationship?,
	sideCustomerRelationship: DTSwitchesRelationship?

	required public init() {
		key = NSUUID().uuidString
		switchesRelationships = [:]
		kitchenStaff = [:]
		let bundledJson = DTBundledJson()
		kitchenStaff[DTBundledJson.staticId] = bundledJson
		sommelier = DTSommelier(bundledJson: bundledJson)
	}
}
