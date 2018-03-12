//
//  FZ_ET_CL_PageViewController.swift
//  Filzanzug
//
//  Created by Richard Willis on 08/12/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

extension FZPageViewControllerEntities: FZRoutingEntityProtocol, FZDeallocatableProtocol {
	public var routing: FZRoutingService? {
		get { return routing_ }
		set {
			guard routing_ == nil else { return }
			routing_ = newValue
		}
	}
	public func deallocate () {
		routing_ = nil
	}
}

public class FZPageViewControllerEntities {
	fileprivate let key: String
	
	fileprivate var routing_: FZRoutingService?

	public init ( _ key: String ) { self.key = key }
}
