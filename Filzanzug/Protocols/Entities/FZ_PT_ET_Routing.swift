//
//  FZ_PT_ET_Routing.swift
//  Filzanzug
//
//  Created by Richard Willis on 28/09/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

public protocol FZRoutingEntityProtocol {
	func getRoutingServiceBy ( key: String ) -> FZRoutingService?
	func set ( routingService: FZRoutingService )
}
