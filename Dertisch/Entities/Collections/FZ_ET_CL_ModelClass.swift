//
//  DT_ET_CL_ModelClassEntities.swift
//  Dertisch
//
//  Created by Richard Willis on 03/08/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

//extension DTKitchenCloset: DTKitchenClosetProtocol {
//	public var bespoke: DTBespokeEntities { return bespoke_entities! }
//
//	public func bundledJson(_ key: DTKey?) -> DTBundledJsonService? {
//		return key?.teeth == key_ ? bundled_json : nil
//	}
//	
//	public func coreData(_ key: DTKey?) -> DTCoreDataSousChef? {
//		return key?.teeth == key_ ? core_data : nil
//	}
//	
//	public func orders(_ key: DTKey?) -> DTOrders? {
//		return key?.teeth == key_ ? orders_ : nil
//	}
//	
//	public func urlSession(_ key: DTKey?) -> DTUrlSessionSousChef? {
//		return key?.teeth == key_ ? url_session : nil
//	}
//	
//	public func cleanUp() {
//		bundled_json?.cleanUp()
//		bespoke_entities?.cleanUp()
//		core_data?.cleanUp()
//		url_session?.cleanUp()
//		bespoke_entities = nil
//		core_data = nil
//		orders_ = nil
//		url_session = nil
//	}
//	
//	public func set(bundledJson: DTBundledJsonService) {
//		guard bundled_json == nil else { return }
//		bundled_json = bundledJson
//	}
//
//	public func set(coreData: DTCoreDataSousChef) {
//		guard core_data == nil else { return }
//		core_data = coreData
//	}
//	
//	public func set(ordersService: DTOrders) {
//		guard orders_ == nil else { return }
//		orders_ = ordersService
//	}
//	
//	public func set(urlSession: DTUrlSessionSousChef) {
//		guard url_session == nil else { return }
//		url_session = urlSession
//	}
//}
//
//public class DTKitchenCloset {
//	fileprivate let key_: String
//
//	fileprivate var
//	bundled_json: DTBundledJsonService?,
//	core_data: DTCoreDataSousChef?,
//	orders_: DTOrders?,
//	url_session: DTUrlSessionSousChef?
//	
//	fileprivate lazy var bespoke_entities: DTBespokeEntities? = DTBespokeEntities()
//	
//	required public init(_ delegate: DTSwitchClassProtocol, key: DTKey) {
//		key_ = key.teeth
//		guaranteeSingleInstanceOfSelf(within: delegate)
//	}
//}
