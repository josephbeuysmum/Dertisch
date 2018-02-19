//
//  FZ_ET_Signals.swift
//  Hasenblut
//
//  Created by Richard Willis on 02/01/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

extension FZSignalsEntity: FZSignalsEntityProtocol {}

public class FZSignalsEntity {
	fileprivate let key: String
	
	fileprivate var signals: FZSignalsService?
	
	
	
	init ( _ key: String ) { self.key = key }
	
	public func deallocate () {
		signals = nil
	}
	
	public func getSignalsServiceBy ( key: String ) -> FZSignalsService? {
		return key == self.key ? signals : nil
	}
	
	public func set ( signalsService: FZSignalsService ) {
		guard signals == nil else { return }
		signals = signalsService
	}
}
