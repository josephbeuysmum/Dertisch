//
//  DT_PX_LocalAccess.swift
//  Dertisch
//
//  Created by Richard Willis on 11/02/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

import UIKit

extension DTTemporaryValuesSousChef: DTTemporaryValuesSousChefProtocol {
//	public var closet: DTKitchenCloset { return closet_ }
	
	
	
	public func startShift() { is_activated = true }
	
	public func getValue(by key: String, andAnnul: Bool? = false) -> DTStorableDataType? {
		guard let value = values_[key] else { return nil }
		if andAnnul! { annulValue(by: key) }
		return value
	}
	
	// todo use DTStorableDataType protocol (or something damned similar) to make value more flexible than just String
	public func set(_ value: DTStorableDataType, by key: String) {
		values_[key] = value
		orders_.make(order: DTOrderConsts.valueSet, with: key)
	}
	
	public func annulValue(by key: String) {
		guard values_[key] != nil else { return }
		values_.removeValue(forKey: key)
	}
	
	public func removeValues() {
//		guard let orders = closet_.orders(key_) else { return }
		for (key, _) in values_ { _ = annulValue(by: key) }
		orders_.make(order: DTOrderConsts.valuesRemoved )
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
//	public func store ( value: String, by key: String, and caller: DTCaller? = nil ) {
//		guard let orders = wornCloset.getSignals( by: key_.teeth ) else { return }
//		let signalKey = DTOrderConsts.valueStored
//		DTMisc.set( orders: orders, withKey: signalKey, andCaller: caller )
//		storage.setValue( value, forKey: key )
//		storage.synchronize()
//		orders.transmitSignalFor( key: signalKey )
//	}

}

public class DTTemporaryValuesSousChef {
	fileprivate let orders_: DTOrders
	
	fileprivate var
	is_activated: Bool,
	values_: Dictionary<String, DTStorableDataType>
//	key_: DTKey!,
//	closet_: DTKitchenCloset!

	required public init(orders: DTOrders, kitchenStaffMembers: [DTKitchenProtocol]?) {
		orders_ = orders
		is_activated = false
		values_ = [:]
//		key_ = DTKey(self)
//		closet_ = DTKitchenCloset(self, key: key_)
	}
	
	deinit {}
}
