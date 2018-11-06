//
//  DT_ET_Order.swift
//  Cirk
//
//  Created by Richard Willis on 23/10/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

// todo better generic word for orders and dishes than "passable"
public typealias DTDish = DTPassable
public typealias DTOrder = DTPassable
public typealias DTTicket = String

public struct DTPassable: DTPassableProtocol {
	public var id: DTTicket { return id_ }
	public var content: Any? { return content_ }
	
	private let
	id_: DTTicket,
	content_: Any?
	
	public init(_ id: DTTicket, _ content: Any?) {
		id_ = id
		content_ = content
	}
}

