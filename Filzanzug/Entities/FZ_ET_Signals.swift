//
//  FZ_ET_Signals.swift
//  Filzanzug
//
//  Created by Richard Willis on 02/01/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

extension FZSignalsEntity: FZSignalsEntityProtocol {}

public struct FZSignalsEntity {
	public var signals: FZSignalsService? {
		get { return _signals }
		set {
			guard _signals == nil else { return }
			_signals = newValue
		}
	}
	
	
	
	fileprivate var _signals: FZSignalsService?
}
