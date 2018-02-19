//
//  FZ_PT_Presenter.swift
//  Hasenblut
//
//  Created by Richard Willis on 22/06/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

import Foundation

public extension FZPresenterProtocol {
	var className: String { return String( describing: self ) }
	var viewController: FZViewController? {
		guard let scopedWornCloset = _wornCloset else { return nil }
		return scopedWornCloset.presenterEntities?.getViewControllerBy( key: scopedWornCloset.key )
	}
	// todo this is repeated code, is there any way to avoid repeating it?
	fileprivate var _wornCloset: FZWornCloset? {
		let selfReflection = Mirror( reflecting: self )
		for ( _, child ) in selfReflection.children.enumerated() {
			if child.value is FZWornCloset { return ( child.value as! FZWornCloset ) }
		}
		return nil
	}
	
	
	
	public func activate () {
//		lo()
		_ = signalBox.signals.scanOnceFor( key: FZSignalConsts.viewLoaded, scanner: self ) {
			[ unowned self ] _, data in
//			lo()
			guard data as? FZViewController == self.viewController else { return }
			self.signalBox.signals.transmitSignalFor( key: FZSignalConsts.presenterActivated, data: self )
			self.postViewActivated() }
	}
	
	public func initialiseSignals () {
		guard let scopedWornCloset = _wornCloset else { return }
		scopedWornCloset.entities = FZPresenterEntities( scopedWornCloset.key )
		signalBox.signals.scanFor( key: FZInjectionConsts.routing, scanner: self ) {
			_, data in
			lo(data)
			guard data is FZRoutingService else { return }
			scopedWornCloset.presenterEntities?.set( routingService: data as! FZRoutingService ) }
		signalBox.signals.scanFor( key: FZInjectionConsts.viewController, scanner: self ) {
			_, data in
			lo(data)
			guard data is FZViewController else { return }
			scopedWornCloset.presenterEntities?.set( viewController: data as! FZViewController ) }
		_ = Timer.scheduledTimer( withTimeInterval: TimeInterval( 0.5 ), repeats: false ) {
			[ unowned self ] timer in
			lo(timer)
			_ = self.signalBox.signals.stopScanningFor( key: FZInjectionConsts.routing, scanner: self )
			_ = self.signalBox.signals.stopScanningFor( key: FZInjectionConsts.viewController, scanner: self )
			timer.invalidate() }
	}
	
	public func present ( viewName: String ) {
		guard
			let scopedWornCloset = _wornCloset,
			let viewController = scopedWornCloset.presenterEntities?.getViewControllerBy( key: scopedWornCloset.key )
			else { return }
		scopedWornCloset.presenterEntities?.getRoutingServiceBy( key: scopedWornCloset.key )?.present(
			viewController: viewName,
			on: viewController )
	}
	
	// implemented just in case they are not required in their given implementer, so that a functionless function need not be added
	public func deallocate () { _wornCloset?.deallocate() }
	public func postViewActivated () { lo() }
}

public protocol FZPresenterProtocol: FZWornClosetImplementerProtocol {
	var viewController: FZViewController? { get }
	func postViewActivated ()
	func present ( viewName: String )
}
