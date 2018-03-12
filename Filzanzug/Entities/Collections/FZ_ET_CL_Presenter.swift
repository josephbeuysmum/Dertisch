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
	
	public func deallocate () {
		routing_ = nil
		view_controller = nil
	}
}

public class FZPresenterEntities {
	fileprivate var
	routing_: FZRoutingService?,
	view_controller: FZViewController?
	
	public required init ( routing: FZRoutingService? = nil, viewController: FZViewController? = nil ) {
		routing_ = routing
		view_controller = viewController
	}
}
