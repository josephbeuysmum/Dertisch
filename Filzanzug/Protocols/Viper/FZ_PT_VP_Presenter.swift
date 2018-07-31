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
	
	public var closet: FZPresenterCloset? {
		return FirstInstance().get(FZPresenterCloset.self, from: mirror_)
	}
	
	private var key_: FZKey? {
		return FirstInstance().get(FZKey.self, from: mirror_)
	}
	
	private var mirror_: Mirror { return Mirror(reflecting: self) }

	
	
	func activate() {
		guard
			let key = key_,
			let signals = closet?.signals(key)
			else { return }
		_ = signals.scanOnceFor(signal: FZSignalConsts.viewLoaded, scanner: self) { _, data in
			guard self.check(data) else { return }
//			signals.scanOnceFor(signal: FZSignalConsts.navigateTo, scanner: self) { _, data in
//				guard let viewName = data as? String else { return }
//				self.present(viewName)
//			}
			self.viewLoaded()
			signals.transmit(signal: FZSignalConsts.presenterActivated, with: self)
		}
		_ = signals.scanOnceFor(signal: FZSignalConsts.viewAppeared, scanner: self) { _, data in
			guard self.check(data) else { return }
			self.viewAppeared()
		}
	}
	
	
	// todo we may well have persistent viper objects in future versions of FZ, in which case an internal non-protocol (ie: extension only) function is an excellent way (the best way I currently know of) for FZ classes (ie: Routing) to talk to other FZ classes (ie: EntityCollections) without allowing apps utilising FZ (ie: Cirk) to access said function
//	internal func checkIn() {
//		closet?.signals(key_)?.transmit(signal: FZSignalConsts.presenterUpdated, with: self)
//	}
	
//	func present(_ viewName: String) {
//		guard
//			let key = key_,
//			let viewController = closet?.viewController(key)
//			else { return }
//		closet?.routing(key)?.present(viewController: viewName, on: viewController)
//	}
	
	private func check(_ data: Any?) -> Bool {
		guard
			let passedViewController = data as? FZViewController,
			let ownViewController = self.closet?.viewController(key_)
			else { return false }
		return passedViewController == ownViewController
	}
	
	mutating func deallocate() {}
	mutating func populate<T>(with data: T?) {}
	func viewAppeared() {}
	func viewLoaded() {}
}

public protocol FZPresenterProtocol: FZViperClassProtocol, FZPopulatableViewProtocol {
	var closet: FZPresenterCloset? { get }
//	mutating func populate<T>(with data: T?)
//	func present(_ viewName: String)
	func viewLoaded()
	func viewAppeared()
}
