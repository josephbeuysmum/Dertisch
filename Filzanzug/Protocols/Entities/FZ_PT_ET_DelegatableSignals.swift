//
//  FZ_PT_ET_DelegatableSignals.swift
//  Filzanzug
//
//  Created by Richard Willis on 22/02/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public protocol FZDelegatableSignalsEntityProtocol: FZSignalsEntityProtocol {
	var delegate: FZInitialiseSignalsProtocol? { get set }
}

