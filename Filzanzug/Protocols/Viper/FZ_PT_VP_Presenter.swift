//
//  FZ_PT_VP_Presenter.swift
//  Filzanzug
//
//  Created by Richard Willis on 22/06/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

import Foundation

public extension FZPresenterProtocol {
	public var className: String { return String( describing: self ) }
	public var viewController: FZViewController? { return wornCloset.getPresenterEntities( by: _reflectedKey )?.viewController }
	fileprivate var _reflectedKey: String? {
		let selfReflection = Mirror( reflecting: self )
		for ( _, child ) in selfReflection.children.enumerated() {
			if child.value is FZKeyring { return ( child.value as? FZKeyring )?.key }
		}
		return nil
	}

	
	
	public func activate () {
		guard let scopedSignals = wornCloset.getSignals( by: _reflectedKey ) else { return }
//		guard let scopedKey = _reflectedKey else { return }
		_ = scopedSignals.scanOnceFor( key: FZSignalConsts.viewLoaded, scanner: self as AnyObject ) {
//			[ unowned self ]
			_, data in
			guard data as? FZViewController == self.viewController else { return }
			scopedSignals.transmitSignalFor( key: FZSignalConsts.presenterActivated, data: self )
			self.postViewActivated() }
	}
	
//	public func initialiseSignals () {
//		guard let scopedKey = _reflectedKey else { return }
//		wornCloset.entities = FZPresenterEntities()
//		wornCloset.signalBox?.signals?.scanFor( key: FZInjectionConsts.routing, scanner: self ) {
//			_, data in
//			guard data is FZRoutingService else { return }
//			self.wornCloset.getPresenterEntities( by: scopedWornCloset.1.key )?.routing = data as? FZRoutingService }
//			self.wornCloset.signalBox?.signals?.scanFor( key: FZInjectionConsts.viewController, scanner: self ) {
//				_, data in
//				guard data is FZViewController else { return }
//				self.wornCloset.getPresenterEntities( by: scopedKey )?.viewController = data as? FZViewController }
//		_ = Timer.scheduledTimer( withTimeInterval: TimeInterval( 0.5 ), repeats: false ) {
//			[ unowned self ] timer in
//			_ = self.wornCloset.signalBox?.signals?.stopScanningFor( key: FZInjectionConsts.routing, scanner: self )
//			_ = self.wornCloset.signalBox?.signals?.stopScanningFor( key: FZInjectionConsts.viewController, scanner: self )
//			timer.invalidate() }
//	}
	
	public func present ( viewName: String ) {
		guard
			let scopedKey = _reflectedKey,
			let viewController = wornCloset.getPresenterEntities( by: scopedKey )?.viewController
			else { return }
		wornCloset.getPresenterEntities( by: scopedKey )?.routing?.present( viewController: viewName, on: viewController )
	}
	
	// implemented just in case they are not required in their given implementer, so that a functionless function need not be added
	public func deallocate () { wornCloset.deallocate() }
	public func postViewActivated () { lo() }
}

public protocol FZPresenterProtocol: FZWornClosetImplementerProtocol {
	var viewController: FZViewController? { get }
	func postViewActivated ()
	func present ( viewName: String )
}
