//
//  FZ_PT_Timeable.swift
//  Hasenblut
//
//  Created by Richard Willis on 22/06/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

public protocol FZStopwatchEntityProtocol: FZDeallocatableProtocol {
	func getStopwatchBy ( key scopedKey: String ) -> FZStopwatch?
	func set ( stopwatch: FZStopwatch )
}
