//
//  FZ_PT_ET_ModelClass.swift
//  Filzanzug
//
//  Created by Richard Willis on 04/08/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

public protocol FZModelClassEntitiesCollectionProtocol: FZBespokeEntitiesEntityProtocol, FZEntitiesCollectionProtocol {
	var localAccess: FZLocalAccessProxy? { get }
	var urlSession: FZUrlSessionService? { get }
	func set ( localAccess newValue: FZLocalAccessProxy )
	func set ( urlSession newValue: FZUrlSessionService )
//	init ( localAccess: FZLocalAccessProxy?, urlSession: FZUrlSessionService? )
}
