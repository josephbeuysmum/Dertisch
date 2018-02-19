//
//  FZ_PT_ET_SignalBox.swift
//  Hasenblut
//
//  Created by Richard Willis on 02/01/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public protocol FZSignalsEntityProtocol: FZDeallocatableProtocol {
	func getSignalsServiceBy ( key scopedKey: String ) -> FZSignalsService?
	func set ( signalsService: FZSignalsService )
}

