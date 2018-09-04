//
//  DT_ET_CL_InteractorEntities.swift
//  Dertisch
//
//  Created by Richard Willis on 03/08/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

//extension DTHeadChefCloset: DTHeadChefClosetProtocol {
//	public var bespoke: DTBespokeEntities { return bespoke_entities! }
//	
//	// todo make these (and equivs in Presenter and ModelClass files) into optional subscripts
//	public func imageSousChef(_ key: DTKey?) -> DTImageSousChef? {
//		return key?.teeth == key_ ? image_proxy : nil
//	}
//
//	public func waiter(_ key: DTKey?) -> DTWaiterProtocol? {
//		return key?.teeth == key_ ? waiter_ : nil
//	}
//	
//	public func orders(_ key: DTKey?) -> DTOrders? {
//		return key?.teeth == key_ ? orders_ : nil
//	}
//	
//	public func cleanUp() {
//		bespoke_entities?.cleanUp()
//		image_proxy?.cleanUp()
//		waiter_?.cleanUp()
//		orders_?.stopWaitingFor(signal: DTOrderConsts.waiterUpdated, order: self)
//		bespoke_entities = nil
//		image_proxy = nil
//		waiter_ = nil
//		orders_ = nil
//	}
//	
//	public func set(imageSousChef: DTImageSousChef) {
//		guard image_proxy == nil else { return }
//		image_proxy = imageSousChef
//	}
//
//	public func set(waiter: DTWaiterProtocol) {
//		guard waiter_ == nil else { return }
//		waiter_ = waiter
//	}
//	
//	public func set(ordersService: DTOrders) {
//		guard orders_ == nil else { return }
//		orders_ = ordersService
//		orders_!.listenFor(order: DTOrderConsts.waiterUpdated, order: self) { _, data in
//			guard let waiter = data as? DTWaiterProtocol else { return }
//			self.waiter_ = waiter
//		}
//	}
//}
//
//public class DTHeadChefCloset {
//	fileprivate let key_: String
//	
//	fileprivate var
//	image_proxy: DTImageSousChef?,
//	waiter_: DTWaiterProtocol?,
//	orders_: DTOrders?
//	
//	fileprivate lazy var bespoke_entities: DTBespokeEntities? = DTBespokeEntities()
//	
//	required public init(_ delegate: DTSwitchClassProtocol, key: DTKey) {
//		key_ = key.teeth
//		guaranteeSingleInstanceOfSelf(within: delegate)
//	}
//}
