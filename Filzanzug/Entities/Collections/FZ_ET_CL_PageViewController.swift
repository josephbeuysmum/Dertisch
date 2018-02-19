//
//  FZ_ET_CL_PageViewController.swift
//  Hasenblut
//
//  Created by Richard Willis on 08/12/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

extension FZPageViewControllerEntities: FZRoutingEntityProtocol, FZDeallocatableProtocol {}

public class FZPageViewControllerEntities {
	fileprivate let key: String
	
	fileprivate var routing: FZRoutingService?

	
	
	public init ( _ key: String ) { self.key = key }
	
	
	
	public func deallocate () {
		routing = nil
	}
	
	public func getRoutingServiceBy ( key: String ) -> FZRoutingService? { return key == self.key ? routing : nil }
	
	public func set ( routingService: FZRoutingService ) {
		guard routing == nil else { return }
		routing = routingService
	}
}
