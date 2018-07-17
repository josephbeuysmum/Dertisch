//
//  FZ_PT_Components.swift
//  Filzanzug
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public protocol FZStopwatchProtocol: FZSignalsEntityProtocol, FZSignalReceivableProtocol {
	func startWith(delay: Double, andData data: Any?, _ callback: @escaping(String, Any?) -> Void)
	func stop()
}
