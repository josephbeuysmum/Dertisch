//
//  FZ_PX_LocalAccess.swift
//  Filzanzug
//
//  Created by Richard Willis on 11/02/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

import UIKit

extension FZTemporaryValuesProxy: FZTemporaryValuesProxyProtocol {
	public var wornCloset: FZWornCloset { get { return worn_closet } set {} }
	
	
	
	public func activate () { _isActivated = true }
	
	public func getValue ( by key: String ) -> String? { return _values[ key ] }
	
	public func set ( value: String, by key: String, and caller: FZCaller? = nil ) {
		guard let scopedSignals = wornCloset.getSignals( by: key_ring.key ) else { return }
		let signalKey = FZSignalConsts.valueSet
		FZMisc.set( signals: scopedSignals, withKey: signalKey, andCaller: caller )
		_values[ key ] = value
		scopedSignals.transmitSignalFor( key: signalKey, data: key )
	}
	
	public func annulValue ( by key: String ) -> String? {
		guard _values[ key ] != nil else { return nil }
		return _values.removeValue( forKey: key )
	}
	
	public func removeValues () {
		guard let scopedSignals = wornCloset.getSignals( by: key_ring.key ) else { return }
		for ( key, _ ) in _values { _ = annulValue( by: key ) }
		scopedSignals.transmitSignalFor( key: FZSignalConsts.valuesRemoved )
	}
	
//	public func deleteValue ( by key: String ) {
//		storage.removeObject( forKey: key )
//	}
//	
//	//	public func deleteValues ( key: String ) {}
//	
//	public func retrieveValue ( by key: String ) -> String? {
//		return storage.string( forKey: key )
//	}
//	
//	// store ("set") the given property
//	public func store ( value: String, by key: String, and caller: FZCaller? = nil ) {
//		guard let scopedSignals = wornCloset.getSignals( by: key_ring.key ) else { return }
//		let signalKey = FZSignalConsts.valueStored
//		FZMisc.set( signals: scopedSignals, withKey: signalKey, andCaller: caller )
//		storage.setValue( value, forKey: key )
//		storage.synchronize()
//		scopedSignals.transmitSignalFor( key: signalKey )
//	}

}

public class FZTemporaryValuesProxy {
	fileprivate let
	key_ring: FZKeyring,
	worn_closet: FZWornCloset
//	, storage: UserDefaults = UserDefaults.standard
	
	// _values provides a platform for the storage of data that has a
	// very short lifespan, like an ID that needs somwhere to live whilst one
	// ViewController segues out, and another segues in. These temporary
	// values are stored in the _values Dictionary below
	fileprivate var
	_isActivated: Bool,
	_values: Dictionary < String, String >
	
	required public init () {
		_isActivated = false
		key_ring = FZKeyring()
		worn_closet = FZWornCloset( key_ring.key )
		_values = [:]
		lo()
	}
	
	deinit {}
}