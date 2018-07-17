//
//  FZ_ET_CL_PresenterEntities.swift
//  Filzanzug
//
//  Created by Richard Willis on 03/08/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

extension FZPresenterCloset: FZPresenterClosetProtocol {
	public func routing(_ key: FZKey?) -> FZRoutingService? {
		return key?.teeth == key_ ? routing_service : nil
	}
	
	public func signals(_ key: FZKey?) -> FZSignalsService? {
		return key?.teeth == key_ ? signals_service : nil
	}
	
	public func viewController(_ key: FZKey?) -> FZViewController? {
		return key?.teeth == key_ ? view_controller : nil
	}
	
	public func deallocate() {
		view_controller?.deallocate()
		routing_service = nil
		view_controller = nil
	}
	
	public func set(routing: FZRoutingService) {
		guard routing_service == nil else { return }
		routing_service = routing
	}
	
	public func set(signalsService: FZSignalsService) {
		guard signals_service == nil else { return }
		signals_service = signalsService
	}
	
	public func set(viewController: FZViewController) {
		guard view_controller == nil else { return }
		view_controller = viewController
	}
}

public class FZPresenterCloset {
	fileprivate let key_: String

	fileprivate var
	routing_service: FZRoutingService?,
	signals_service: FZSignalsService?,
	view_controller: FZViewController?,
	values: Dictionary<String, Any>?
	
	required public init(_ delegate: FZViperClassProtocol, key: FZKey) {
		key_ = key.teeth
		guaranteeSingleInstanceOfSelf(within: delegate)
	}
}
