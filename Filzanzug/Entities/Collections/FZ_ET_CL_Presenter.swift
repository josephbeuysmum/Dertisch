//
//  FZ_ET_CL_PresenterEntities.swift
//  Filzanzug
//
//  Created by Richard Willis on 03/08/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

extension FZPresenterEntities: FZPresenterEntitiesCollectionProtocol {
	public var routing: FZRoutingService? { return routing_ }
	public var viewController: FZViewController? { return view_controller }
	
	public func deallocate() {
		routing_ = nil
		view_controller = nil
	}
}

public class FZPresenterEntities {
	fileprivate var
	routing_: FZRoutingService?,
	view_controller: FZViewController?,
	values: Dictionary<String, Any>?
	
	public required init(routing: FZRoutingService? = nil, viewController: FZViewController? = nil) {
		routing_ = routing
		view_controller = viewController
	}
	
	public func getValue(by key: String) -> Any? {
		return values?[key]
	}
	
	public func set(_ value: Any?, by key: String) {
		if values == nil { values = [:] }
		values![key] = value
	}
}
