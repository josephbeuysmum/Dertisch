//
//  FZ_ET_Signals.swift
//  Filzanzug
//
//  Created by Richard Willis on 02/01/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

extension FZSignalsEntity: FZSignalsEntityProtocol {}

public class FZSignalsEntity {
	public var signals: FZSignalsService {
		get { return _signals }
		set { if _signals == nil { _signals = newValue } }
	}
	
	fileprivate var _signals: FZSignalsService!
}
