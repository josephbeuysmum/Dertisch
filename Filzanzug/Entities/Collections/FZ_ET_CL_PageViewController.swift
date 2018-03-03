//
//  FZ_ET_CL_PageViewController.swift
//  Filzanzug
//
//  Created by Richard Willis on 08/12/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

extension FZPageViewControllerEntities: FZRoutingEntityProtocol, FZDeallocatableProtocol {}

public class FZPageViewControllerEntities {
	public var routing: FZRoutingService? {
		get { return _routing }
		set {
			guard _routing == nil else { return }
			_routing = newValue
		}
	}
	
	fileprivate let key: String
	
	fileprivate var _routing: FZRoutingService?

	
	
	public init ( _ key: String ) { self.key = key }
	
	public func deallocate () {
		_routing = nil
	}
}
