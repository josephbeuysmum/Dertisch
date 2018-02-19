//
//  FZ_PT_ET_Padlock.swift
//  Hasenblut
//
//  Created by Richard Willis on 12/02/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public protocol FZWornClosetEntityProtocol {
	var wornCloset: FZWornCloset { get }
	func fillWornCloset ()
	func getProtocolKey ( with implementerKey: String ) -> String?
}
