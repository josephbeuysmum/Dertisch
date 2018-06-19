//
//  FZ_ETsignals_ignature.swift
//  Filzanzug
//
//  Created by Richard Willis on 04/04/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

// FZSignalWavelength stores a uniquely identifiable way to track signal scanners, with a key and a flag denoting whether the signal is permanently observed or just a one-off
extension FZSignalWavelength {
	public typealias FZSignalCallback = (String, Any?) -> Void
	
	public var description: String {
		return "\(key)-\(id_)"
	}
	
	public mutating func deallocate () {
		scanner_ = nil
	}
}

public struct FZSignalWavelength {
	public let
	key: String,
	scansContinuously: Bool,
	callback: FZSignalCallback?
	
	fileprivate let id_: String
	
	fileprivate var scanner_: FZSignalReceivableProtocol?
	
	init(key: String, scanner: FZSignalReceivableProtocol, scansContinuously: Bool = true, callback: FZSignalCallback? = nil) {
		self.key = key
		self.callback = callback
		self.scansContinuously = scansContinuously
		id_ = NSUUID().uuidString
		scanner_ = scanner
	}
}
