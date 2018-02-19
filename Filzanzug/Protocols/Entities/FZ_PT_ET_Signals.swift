//
//  FZ_PT_ET_Signals.swift
//  Filzanzug
//
//  Created by Richard Willis on 02/01/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public protocol FZSignalsEntityProtocol {
	var delegate: FZInitialiseSignalsProtocol? { get set }
	var signals: FZSignalsService { get set }
}
