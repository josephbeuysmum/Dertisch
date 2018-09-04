//
//  FZ_PT_VP_Presenter.swift
//  Filzanzug
//
//  Created by Richard Willis on 22/06/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

import Foundation

public extension FZPresenterProtocol {
	public var instanceDescriptor: String { return String(describing: self) }
	
//	public var closet: FZPresenterCloset? {
//		return FirstInstance().get(FZPresenterCloset.self, from: mirror_)
//	}
	
//	private var key_: FZKey? {
//		return FirstInstance().get(FZKey.self, from: mirror_)
//	}
	
	// todo these vars need to be made single instance safe
	private var mirror_: Mirror { return Mirror(reflecting: self) }
	private var routing_: FZRoutingService? { return FirstInstance().get(FZRoutingService.self, from: mirror_) }
	private var signals_: FZSignalsService? { return FirstInstance().get(FZSignalsService.self, from: mirror_) }
	private var view_controller: FZViewController? { return FirstInstance().get(FZViewController.self, from: mirror_) }
	

	
	func activate() {
		guard
//			let key = key_,
			let signals = signals_
			else { return }
		_ = signals.scanOnceFor(signal: FZSignalConsts.viewLoaded, scanner: self) { _, data in
			guard
				let strongSelf = self as FZPresenterProtocol?,
				strongSelf.check(data)
				else { return }
			strongSelf.viewLoaded()
			signals.transmit(signal: FZSignalConsts.presenterActivated, with: strongSelf)
		}
		_ = signals.scanOnceFor(signal: FZSignalConsts.viewAppeared, scanner: self) { _, data in
			guard
				let strongSelf = self as FZPresenterProtocol?,
				strongSelf.check(data)
				else { return }
			strongSelf.viewAppeared()
		}
	}
	
	
	// todo we may well have persistent viper objects in future versions of FZ, in which case an internal non-protocol (ie: extension only) function is an excellent way (the best way I currently know of) for FZ classes (ie: Routing) to talk to other FZ classes (ie: EntityCollections) without allowing apps utilising FZ (ie: Cirk) to access said function
//	internal func checkIn() {
//		closet?.signals(key_)?.transmit(signal: FZSignalConsts.presenterUpdated, with: self)
//	}
	
	func present(_ viewControllerId: String, animated: Bool) {
		guard
//			let key = key_,
			let signals = signals_,
			let routing = routing_
			else { return }
		if routing.hasPopover {
			signals.scanOnceFor(signal: FZSignalConsts.popoverRemoved, scanner: self) { _,_ in
				routing.present(viewControllerId, animated: animated)
			}
			routing.dismissPopover()
		} else {
			routing.present(viewControllerId, animated: animated)
		}
	}

	private func check(_ data: Any?) -> Bool {
		guard
			let passedViewController = data as? FZViewController,
			let ownViewController = view_controller
			else { return false }
		return passedViewController == ownViewController
	}
	
	mutating func deallocate() {}
	mutating func populate<T>(with data: T?) {}
	mutating func update<T>(with data: T?) {}
	func viewAppeared() {}
	func viewLoaded() {}
}

public protocol FZPresenterProtocol: FZViperClassProtocol, FZPopulatableViewProtocol, FZPresentableViewProtocol, FZUpdatableProtocol {
	init(signals: FZSignalsService, routing: FZRoutingService)//, viewController: FZViewController)
//	var closet: FZPresenterCloset? { get }
	func viewLoaded()
	func viewAppeared()
}

































