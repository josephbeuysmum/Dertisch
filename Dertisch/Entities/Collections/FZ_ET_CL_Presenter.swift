//
//  DT_ET_CL_WaiterEntities.swift
//  Dertisch
//
//  Created by Richard Willis on 03/08/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

//extension DTWaiterCloset: DTWaiterClosetProtocol {
//	public func routing(_ key: DTKey?) -> DTMaitreD? {
//		return key?.teeth == key_ ? maitre_dservice : nil
//	}
//	
//	public func orders(_ key: DTKey?) -> DTOrders? {
//		return key?.teeth == key_ ? orders_ : nil
//	}
//	
//	public func dishController(_ key: DTKey?) -> DTDish? {
//		return key?.teeth == key_ ? dish_ : nil
//	}
//	
//	public func cleanUp() {
//		dish_?.cleanUp()
//		maitre_dservice = nil
//		dish_ = nil
//	}
//	
//	public func set(routing: DTMaitreD) {
//		guard maitre_dservice == nil else { return }
//		maitre_dservice = routing
//	}
//	
//	public func set(ordersService: DTOrders) {
//		guard orders_ == nil else { return }
//		orders_ = ordersService
//	}
//	
//	public func set(dish: DTDish) {
//		guard dish_ == nil else { return }
//		dish_ = dish
//	}
//}
//
//public class DTWaiterCloset {
//	fileprivate let key_: String
//
//	fileprivate var
//	maitre_dservice: DTMaitreD?,
//	orders_: DTOrders?,
//	dish_: DTDish?,
//	values: Dictionary<String, Any>?
//	
//	required public init(_ delegate: DTSwitchClassProtocol, key: DTKey) {
//		key_ = key.teeth
//		guaranteeSingleInstanceOfSelf(within: delegate)
//	}
//}
