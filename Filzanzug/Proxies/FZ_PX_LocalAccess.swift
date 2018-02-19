//
//  FZ_SV_UserDefaults.swift
//  Boilerplate
//
//  Created by Richard Willis on 11/02/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

import UIKit

public class FZLocalAccessProxy: FZLocalAccessProxyProtocol {
	public var signalBox: FZSignalsEntity

	fileprivate let
	_wornCloset: FZWornCloset,
	storage: UserDefaults = UserDefaults.standard
	
	// _values provides a platform for the storage of data that has a
	// very short lifespan, like an ID that needs somwhere to live whilst one
	// ViewController segues out, and another segues in. These temporary
	// values are stored in the _values Dictionary below
	fileprivate var
	_isActivated: Bool,
	_values: Dictionary < String, String >
	
	
	
	required public init () {
		_isActivated = false
		signalBox = FZSignalsEntity()
		_wornCloset = FZWornCloset()
		_wornCloset.entities = FZModelClassEntities( _wornCloset.key )
		_values = [:]
	}
	
	deinit {}
	
	public func activate () {
		_isActivated = true
	}
	
	
	
	public func getValue ( by key: String ) -> String? { return _values[ key ] }
	
	public func set ( value: String, by key: String, and caller: FZCaller? = nil ) {
		let signalKey = FZSignalConsts.valueSet
		FZMisc.set( signals: signalBox.signals, withKey: signalKey, andCaller: caller )
		_values[ key ] = value
		signalBox.signals.transmitSignalFor( key: signalKey, data: key )
	}
	
	public func annulValue ( by key: String ) -> String? {
		guard _values[ key ] != nil else { return nil }
		return _values.removeValue( forKey: key )
	}
	
	public func removeValues () {
		for ( key, _ ) in _values { _ = annulValue( by: key ) }
		signalBox.signals.transmitSignalFor( key: FZSignalConsts.valuesRemoved )
	}
	
	public func deleteValue ( by key: String ) {
		storage.removeObject( forKey: key )
	}
	
//	public func deleteValues ( key: String ) {}
	
	public func retrieveValue ( by key: String ) -> String? {
		return storage.string( forKey: key )
	}
	
	// store ("set") the given property
	public func store ( value: String, by key: String, and caller: FZCaller? = nil ) {
		let signalKey = FZSignalConsts.valueStored
		FZMisc.set( signals: signalBox.signals, withKey: signalKey, andCaller: caller )
		storage.setValue( value, forKey: key )
		storage.synchronize()
		signalBox.signals.transmitSignalFor( key: signalKey )
	}
	
	// does this property exist?
//	public func has ( key: String ) -> Bool
//	{
//		return retrieve( key: key ) != nil
//	}
}
