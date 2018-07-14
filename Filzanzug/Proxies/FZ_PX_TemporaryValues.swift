//
//  FZ_PX_LocalAccess.swift
//  Filzanzug
//
//  Created by Richard Willis on 11/02/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

import UIKit

extension FZTemporaryValuesProxy: FZTemporaryValuesProxyProtocol {
	public var entities: FZModelClassEntities { return entities_ }
	
	
	
	public func activate () { is_activated = true }
	
	public func getValue ( by key: String ) -> String? { return values_[ key ] }
	
	public func set ( _ value: String, by key: String ) {
		values_[ key ] = value
		entities_.signals(key_ring.key)?.transmit(signal: FZSignalConsts.valueSet, with: key )
	}
	
	public func annulValue ( by key: String ) {
		guard values_[ key ] != nil else { return }
		values_.removeValue( forKey: key )
	}
	
	public func removeValues () {
		guard let signals = entities_.signals(key_ring.key) else { return }
		for ( key, _ ) in values_ { _ = annulValue( by: key ) }
		signals.transmit(signal: FZSignalConsts.valuesRemoved )
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
//		guard let signals = wornCloset.getSignals( by: key_ring.key ) else { return }
//		let signalKey = FZSignalConsts.valueStored
//		FZMisc.set( signals: signals, withKey: signalKey, andCaller: caller )
//		storage.setValue( value, forKey: key )
//		storage.synchronize()
//		signals.transmitSignalFor( key: signalKey )
//	}

}

public class FZTemporaryValuesProxy {
	fileprivate var
	is_activated: Bool,
	values_: Dictionary < String, String >,
	key_ring: FZKeyring!,
	entities_: FZModelClassEntities!

	required public init() {
		is_activated = false
		values_ = [:]
		key_ring = FZKeyring(self)
		entities_ = FZModelClassEntities(key_ring.key)
	}
	
	deinit {}
}
