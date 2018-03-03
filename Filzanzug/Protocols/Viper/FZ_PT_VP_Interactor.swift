//
//  FZ_PT_UT_Interactor.swift
//  Filzanzug
//
//  Created by Richard Willis on 22/06/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

import Foundation

public extension FZInteractorProtocol {
	public var className: String { return String( describing: self ) }
	public var presenter: FZPresenterProtocol? { return wornCloset.getInteractorEntities( by: _reflectedKey )?.presenter }
	fileprivate var _reflectedKey: String? {
		let selfReflection = Mirror( reflecting: self )
		for ( _, child ) in selfReflection.children.enumerated() {
			if child.value is FZKeyring { return ( child.value as? FZKeyring )?.key }
		}
		return nil
	}

	
	
	public func activate () {
		guard
			let scopedKey = _reflectedKey,
			let presenterClassName = wornCloset.getInteractorEntities( by: scopedKey )?.presenter?.className,
			let scopedSignals = wornCloset.getSignals( by: scopedKey )
			else { return }
		_ = scopedSignals.scanFor( key: FZSignalConsts.presenterActivated, scanner: self as AnyObject ) {
//			[ unowned self ]
			_, data in
			guard
				let presenter = data as? FZPresenterProtocol,
				presenter.className == presenterClassName
				else { return }
			scopedSignals.transmitSignalFor( key: FZSignalConsts.interactorActivated, data: self )
			self.postPresenterActivated() }
		_ = Timer.scheduledTimer( withTimeInterval: TimeInterval( 1.0 ), repeats: false ) {
//			[ unowned self ]
			timer in
			_ = self.wornCloset.getSignals( by: scopedKey )?.stopScanningFor(
				key: FZSignalConsts.presenterActivated,
				scanner: self as AnyObject )
			timer.invalidate() }
	}
	
//	public func initialiseSignals () {
//		guard let scopedKey = _reflectedKey else { return }
//		wornCloset.entities = FZInteractorEntities()
//		wornCloset.signals?.scanFor( key: FZInjectionConsts.image, scanner: self ) {
//			_, data in
//			guard data is FZImageProxy else { return }
//			self.wornCloset.getInteractorEntities( by: scopedKey )?.image = data as? FZImageProxy }
//		wornCloset.signals?.scanFor( key: FZInjectionConsts.presenter, scanner: self ) {
//			 _, data in
//			guard data is FZPresenterProtocol else { return }
//			self.wornCloset.getInteractorEntities( by: scopedKey )?.presenter = data as? FZPresenterProtocol }
//		_ = Timer.scheduledTimer( withTimeInterval: TimeInterval( 0.5 ), repeats: false ) {
//			[ unowned self ] timer in
//			_ = self.wornCloset.signals?.stopScanningFor( key: FZInjectionConsts.image, scanner: self )
//			_ = self.wornCloset.signals?.stopScanningFor( key: FZInjectionConsts.presenter, scanner: self )
//			timer.invalidate() }
//	}
	
	// implemented just in case they are not required in their given implementer, so that a functionless function need not be added
	public func deallocate () { wornCloset.deallocate() }
	public func postPresenterActivated () { lo() }
}

public protocol FZInteractorProtocol: FZWornClosetImplementerProtocol {
	var presenter: FZPresenterProtocol? { get }
//	func createWornCloset () -> FZWornCloset?
	func postPresenterActivated ()
}
