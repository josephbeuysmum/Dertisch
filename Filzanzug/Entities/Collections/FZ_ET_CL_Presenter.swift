//
//  FZ_ET_EntityEntities.swift
//  Hasenblut
//
//  Created by Richard Willis on 03/08/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

extension FZPresenterEntities: FZPresenterEntitiesCollectionProtocol {}

public class FZPresenterEntities {
	public var isActivated: Bool { return viewController != nil ? viewController!.isViewLoaded : false }
	
	fileprivate let key: String
	
	fileprivate var
	routing: FZRoutingService?,
	viewController: FZViewController?
	
	
	
	public init ( _ key: String ) { self.key = key }
	
	
	
	public func deallocate () {
		routing = nil
		viewController = nil
	}
	
	public func getRoutingServiceBy ( key: String ) -> FZRoutingService? { return key == self.key ? routing : nil }
	
	public func getViewControllerBy ( key: String ) -> FZViewController? { return key == self.key ? viewController : nil }
	
	public func set ( routingService: FZRoutingService ) {
		guard routing == nil else { return }
		routing = routingService
	}
	
	public func set ( viewController: FZViewController ) {
		guard self.viewController == nil else { return }
		self.viewController = viewController
	}
}
