//
//  DT_ET_Order.swift
//  Cirk
//
//  Created by Richard Willis on 23/10/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

// todo better generic word for dishes and dishes than "passable"
//public typealias DTDishes = DTPassable
public typealias DTOrder = DTPassable
public typealias DTTicket = String

public protocol DTPassableProtocol {
	var ticket: DTTicket { get }
	var content: Any? { get }
}

//public protocol DTDishesProtocol {}

public struct DTPassable: DTPassableProtocol {
	public let
	ticket: DTTicket,
	content: Any?
	
	public init(_ ticket: DTTicket, _ content: Any?) {
		self.ticket = ticket
		self.content = content
	}
}

public struct DTDishes {//}: DTDishesProtocol {
	var ticket: DTTicket { return passable.ticket }
	var dishes: DTDishCollection? { return passable.content as? DTDishCollection }
	
	private let passable: DTPassable
	
	public init(_ id: DTTicket, _ content: DTDishCollection?) {
		passable = DTPassable(id, content)
	}
}

