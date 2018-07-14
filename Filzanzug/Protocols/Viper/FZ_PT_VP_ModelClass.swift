//
//  FZ_PT_VP_ModelClass.swift
//  Filzanzug
//
//  Created by Richard Willis on 11/08/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

public extension FZModelClassProtocol {
	public var instanceDescriptor: String { return String( describing: self ) }
	// todo this is repeated code, is there any way to avoid repeating it?
//	fileprivate var closet_key: String? {
//		let selfReflection = Mirror( reflecting: self )
//		var key: String?
//		for ( _, child ) in selfReflection.children.enumerated() {
//			if child.value is FZKey {
//				if key != nil { fatalError("FZInteractors can only possess one FZKey") }
//				key = (child.value as? FZKey)?.key
//			}
//		}
//		return key
//	}
	
	
	
	public func activate () {}
	
//	func transmitActivation ( with key: String ) {
//		guard let scopedKey = closet_key else { return }
//		wornCloset.getSignals( by: scopedKey )?.transmitSignalFor( key: FZSignalConsts.modelClassActivated, data: className )
//	}
	
	public func deallocate () {}
}

public protocol FZModelClassProtocol: FZViperClassProtocol {
	var closet: FZModelClassEntities { get }
//	func transmitActivation ( with key: String )
}
