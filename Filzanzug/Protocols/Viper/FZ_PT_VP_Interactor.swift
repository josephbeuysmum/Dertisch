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
	public var presenter: FZPresenterProtocol? {
		guard let scopedWornCloset = _wornCloset else { return nil }
		return scopedWornCloset.interactorEntities?.getPresenterBy( key: scopedWornCloset.key )
	}
	fileprivate var _wornCloset: FZWornCloset? {
		let selfReflection = Mirror( reflecting: self )
		for ( _, child ) in selfReflection.children.enumerated() {
			if child.value is FZWornCloset { return ( child.value as! FZWornCloset ) }
		}
		return nil
	}

	
	
	public func activate () {
		lo(_wornCloset?.interactorEntities)
		guard
			let scopedWornCloset = _wornCloset,
			let presenterClassName = scopedWornCloset.interactorEntities?.getPresenterBy( key: scopedWornCloset.key )?.className
			else { return }
		lo()
		_ = signalBox.signals.scanFor( key: FZSignalConsts.presenterActivated, scanner: self ) {
			[ unowned self ] _, data in
			lo()
			guard
				let presenter = data as? FZPresenterProtocol,
				presenter.className == presenterClassName
				else { return }
			self.signalBox.signals.transmitSignalFor( key: FZSignalConsts.interactorActivated, data: self )
			self.postPresenterActivated() }
		_ = Timer.scheduledTimer( withTimeInterval: TimeInterval( 1.0 ), repeats: false ) {
			[ unowned self ] timer in
			_ = self.signalBox.signals.stopScanningFor( key: FZSignalConsts.presenterActivated, scanner: self )
			timer.invalidate() }
	}
	
	public func initialiseSignals () {
		guard let scopedWornCloset = _wornCloset else { return }
		scopedWornCloset.entities = FZInteractorEntities( scopedWornCloset.key )
		signalBox.signals.scanFor( key: FZInjectionConsts.image, scanner: self ) {
			_, data in
			lo(data)
			guard data is FZImageProxy else { return }
			scopedWornCloset.interactorEntities?.set( imageProxy: data as! FZImageProxy ) }
		signalBox.signals.scanFor( key: FZInjectionConsts.presenter, scanner: self ) {
			 _, data in
			lo(data)
			guard data is FZPresenterProtocol else { return }
			scopedWornCloset.interactorEntities?.set( presenter: data as! FZPresenterProtocol ) }
		_ = Timer.scheduledTimer( withTimeInterval: TimeInterval( 0.5 ), repeats: false ) {
			[ unowned self ] timer in
			lo(timer)
			_ = self.signalBox.signals.stopScanningFor( key: FZInjectionConsts.image, scanner: self )
			_ = self.signalBox.signals.stopScanningFor( key: FZInjectionConsts.presenter, scanner: self )
			timer.invalidate() }
	}
	
	// implemented just in case they are not required in their given implementer, so that a functionless function need not be added
	public func deallocate () { _wornCloset?.deallocate() }
	public func postPresenterActivated () { lo() }
}

public protocol FZInteractorProtocol: FZWornClosetImplementerProtocol {
	var presenter: FZPresenterProtocol? { get }
//	func createWornCloset () -> FZWornCloset?
	func postPresenterActivated ()
}
