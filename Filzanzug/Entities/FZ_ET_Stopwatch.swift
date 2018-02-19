//
//  FZStopwatchEntity.swift
//  Hasenblut
//
//  Created by Richard Willis on 05/02/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

extension FZStopwatchEntity: FZStopwatchEntityProtocol {}

public class FZStopwatchEntity {
	fileprivate let key: String
	
	fileprivate var stopwatch: FZStopwatch?
	
	
	
	init ( _ key: String ) { self.key = key }
	
	public func deallocate () {
		stopwatch = nil
	}
	
	public func getStopwatchBy ( key scopedKey: String ) -> FZStopwatch? {
		return key == self.key ? stopwatch : nil
	}
	
	public func set ( stopwatch: FZStopwatch ) {
		guard self.stopwatch == nil else { return }
		self.stopwatch = stopwatch
	}
}
