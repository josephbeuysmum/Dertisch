//
//  DT_ET_Order.swift
//  Cirk
//
//  Created by Richard Willis on 23/10/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

// todo better generic word for dishes and dishes than "passable"
//public typealias OrderFromKitchen = Passable
public typealias Order = Passable
public typealias Ticket = String

public struct Passable {
	public let
	ticket: Ticket,
	content: Any?
	
	public init(_ ticket: Ticket, _ content: Any?) {
		self.ticket = ticket
		self.content = content
	}
}

public struct OrderFromKitchen {
	var ticket: Ticket { return passable.ticket }
	var dishes: Dishionarizer? { return passable.content as? Dishionarizer }
	
	private let passable: Passable
	
	public init(_ id: Ticket, _ content: Dishionarizer?) {
		passable = Passable(id, content)
	}
}
