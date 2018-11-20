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

// tood this needs changing from Any? to <T?>
public protocol DTPassableProtocol {
	var ticket: DTTicket { get }
	var content: Any? { get }
}

//public protocol DTDishProtocol {}

public struct DTPassable: DTPassableProtocol {
	public let
	ticket: DTTicket,
	content: Any?
	
	public init(_ ticket: DTTicket, _ content: Any?) {
		self.ticket = ticket
		self.content = content
	}
}

public struct DTDish {//}: DTDishProtocol {
	var ticket: DTTicket { return passable.ticket }
	var content: Any? { return passable.content }
	
	private let passable: DTPassable
	
	public init(_ id: DTTicket, _ content: Any?) {
		passable = DTPassable(id, content)
	}
}

