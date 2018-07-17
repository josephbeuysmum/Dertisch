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
	
//	private var view_activated: String { return "ViewActivated" }

	
	
	func activate() {
		guard
			let key = key_,
			let signals = closet?.signals(key)
			else { return }
		_ = signals.scanOnceFor(signal: FZSignalConsts.viewLoaded, scanner: self) { _, data in
			guard
				let passedViewController = data as? FZViewController,
				let ownViewController = self.closet?.viewController(key),
				passedViewController == ownViewController
				else { return }
			signals.scanOnceFor(signal: FZSignalConsts.navigateTo, scanner: self) { _, data in
				guard let viewName = data as? String else { return }
				self.present(viewName)
			}
			var mutatingSelf = self
			mutatingSelf.viewActivated()
			signals.transmit(signal: FZSignalConsts.presenterActivated, with: self)
		}
	}
	
	func present(_ viewName: String) {
		guard
			let key = key_,
			let viewController = closet?.viewController(key)
			else { return }
		closet?.routing(key)?.present(viewController: viewName, on: viewController)
	}
	
	func updateSelf() {
		guard let signals = closet?.signals(key_) else { return }
		signals.transmit(signal: FZSignalConsts.presenterUpdated, with: self)
	}
}

public protocol FZPresenterProtocol: FZViperClassProtocol {
	var closet: FZPresenterCloset? { get }
	func updateSelf()
	mutating func populateView<T>(with data: T?)
	func present(_ viewName: String)
	mutating func viewActivated()
}
