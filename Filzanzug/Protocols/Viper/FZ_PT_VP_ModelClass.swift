//
//  FZ_PT_ModelClass.swift
//  Hasenblut
//
//  Created by Richard Willis on 11/08/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

public extension FZModelClassProtocol {
	public var className: String { return String( describing: self ) }
	// todo this is repeated code, is there any way to avoid repeating it?
	fileprivate var _wornCloset: FZWornCloset? {
		let selfReflection = Mirror( reflecting: self )
		for ( _, child ) in selfReflection.children.enumerated() {
			if child.value is FZWornCloset { return ( child.value as! FZWornCloset ) }
		}
		return nil
	}
	
	
	
	public func activate () {}
	
	public func initialiseSignals () {}
	
	func transmitActivation ( with key: String ) {
		signalBox.signals.transmitSignalFor( key: FZSignalConsts.modelClassActivated, data: className )
	}
	
	public func deallocate () { _wornCloset?.deallocate() }
}

public protocol FZModelClassProtocol: FZWornClosetImplementerProtocol {
	func transmitActivation ( with key: String )
}
