//
//  DT_ET_Order.swift
//  Cirk
//
//  Created by Richard Willis on 23/10/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

// todo better generic word for orders and dishes than "passable"
//public typealias DTDish = DTPassable
public typealias DTOrder = DTPassable
public typealias DTTicket = String

public protocol DTPassableProtocol {
	var id: DTTicket { get }
	var content: Any? { get }
}

public protocol DTDishProtocol {
	var isHot: Bool { get }
}

public struct DTPassable: DTPassableProtocol {
	public let
	id: DTTicket,
	content: Any?
	
	public init(_ id: DTTicket, _ content: Any?) {
		self.id = id
		self.content = content
	}
}

public struct DTDish: DTDishProtocol {
	var id: DTTicket { return passable.id }
	var content: Any? { return passable.content }

	public let isHot: Bool
	
	private let passable: DTPassable
	
	public init(_ id: DTTicket, _ isHot: Bool, _ content: Any?) {
		passable = DTPassable(id, content)
		self.isHot = isHot
	}
}

