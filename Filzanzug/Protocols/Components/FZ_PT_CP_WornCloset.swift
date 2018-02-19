//
//  FZ_PT_ET_WornCloset.swift
//  Hasenblut
//
//  Created by Richard Willis on 13/02/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public protocol FZWornClosetProtocol: class, FZDeallocatableProtocol, FZInitableProtocol, FZIsActivatedProtocol {
	var interactorEntities: FZInteractorEntities? { get set }
	var modelClassEntities: FZModelClassEntities? { get set }
	var presenterEntities: FZPresenterEntities? { get set }
	var signalBox: FZSignalsEntity? { get set }
	func activate ( with protocolKey: String )
	func getClosetKey ( by protocolKey: String ) -> String?
	func set ( entities: FZEntitiesCollectionProtocol )
	func set ( protocolKey: String ) -> String?
	func set ( signalBox: FZSignalsEntity? )
}
