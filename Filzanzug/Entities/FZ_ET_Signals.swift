//
//  FZ_ET_Signals.swift
//  Filzanzug
//
//  Created by Richard Willis on 02/01/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

extension FZSignalsEntity: FZSignalsEntityProtocol {}

public class FZSignalsEntity {
	public var delegate: FZInitialiseSignalsProtocol? {
		get { return nil }
		set {
			guard _delegate == nil else { return }
			_delegate = newValue
		}
	}
	public var signals: FZSignalsService {
		get { return _signals }
		set {
			guard _signals == nil else { return }
			_signals = newValue
			_delegate?.initialiseSignals()
		}
	}
	
	fileprivate var
	_signals: FZSignalsService!,
	_delegate: FZInitialiseSignalsProtocol?
	
	
	
	public init () {
		_delegate = nil
	}
}
