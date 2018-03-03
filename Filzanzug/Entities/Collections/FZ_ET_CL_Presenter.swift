//
//  FZ_ET_CL_PresenterEntities.swift
//  Filzanzug
//
//  Created by Richard Willis on 03/08/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

extension FZPresenterEntities: FZPresenterEntitiesCollectionProtocol {}

public class FZPresenterEntities {
	public var routing: FZRoutingService? { return _routing }
	public var viewController: FZViewController? { return _viewController }
	
	fileprivate var
	_routing: FZRoutingService?,
	_viewController: FZViewController?
	
	
	
	public required init ( routing: FZRoutingService? = nil, viewController: FZViewController? = nil ) {
		_routing = routing
		_viewController = viewController
	}
	
	public func deallocate () {
		_routing = nil
		_viewController = nil
	}
}
