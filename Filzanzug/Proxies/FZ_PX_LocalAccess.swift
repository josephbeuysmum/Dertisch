//
//  FZ_SV_UserDefaults.swift
//  Boilerplate
//
//  Created by Richard Willis on 11/02/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

import UIKit

public class FZLocalAccessProxy: FZLocalAccessProxyProtocol {
	public var signalBox: FZSignalsEntity!
	public var entities: FZModelClassEntities!
	public var className: String { return FZClassConsts.localAccess }
	public var signals: FZSignalsService!

	fileprivate let
	key: String,
	storage: UserDefaults = UserDefaults.standard
	
	// _values provides a platform for the storage of data that has a
	// very short lifespan, like an ID that needs somwhere to live whilst one
	// ViewController segues out, and another segues in. These temporary
	// values are stored in the _values Dictionary below
	fileprivate var
	_isActivated: Bool,
	_values: Dictionary < String, String >
	
	
	
	public required init () {
		_isActivated = false
		key = NSUUID().uuidString
		signalBox = FZSignalsEntity( key )
		entities = FZModelClassEntities( key )
//		_signals = signals
		_values = [:]
	}
	
	deinit {}
	
	public func activate () {
		_isActivated = true
	}
	
	
	
	public func getValue ( by key: String ) -> String? { return _values[ key ] }
	
	public func set ( value: String, by key: String, and caller: FZCaller? = nil ) {
		let signalKey = FZSignalConsts.valueSet
		FZMisc.set( signals: signals, withKey: signalKey, andCaller: caller )
		_values[ key ] = value
		signals.transmitSignalFor( key: signalKey, data: key )
	}
	
	public func annulValue ( by key: String ) -> String? {
		guard _values[ key ] != nil else { return nil }
		return _values.removeValue( forKey: key )
	}
	
	public func removeValues () {
		for ( key, _ ) in _values { _ = annulValue( by: key ) }
		signals.transmitSignalFor( key: FZSignalConsts.valuesRemoved )
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
		FZMisc.set( signals: signals, withKey: signalKey, andCaller: caller )
		storage.setValue( value, forKey: key )
		storage.synchronize()
		signals.transmitSignalFor( key: signalKey )
	}
	
	// does this property exist?
//	public func has ( key: String ) -> Bool
//	{
//		return retrieve( key: key ) != nil
//	}
}
