//
//  FZ_ETsignals_ignature.swift
//  Filzanzug
//
//  Created by Richard Willis on 04/04/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

// FZSignalWaveform stores a uniquely identifiable way to track signal scanners, with a key and a flag denoting whether the signal is permanently observed or just a one-off
extension FZSignalWaveform: FZDescribableProtocol {
	public typealias FZSignalCallback = ( String, Any? ) -> Void
	
	public var description: String {
		let
		space = FZCharConsts.space,
		underscore = FZCharConsts.underscore
		return "\( key )\( underscore )\( FZString.replaceInstancesOf( subString: space, with: underscore, inString: String( describing: scanner_! ) ) )"
	}
	
	public mutating func deallocate () {
		scanner_ = nil
	}
}

public struct FZSignalWaveform {
	public let
	key: String,
	scansContinuously: Bool,
	callback: FZSignalCallback?
	
	fileprivate var scanner_: FZSignalReceivableProtocol?
	
	init ( key: String, scanner: FZSignalReceivableProtocol, scansContinuously: Bool = true, callback: FZSignalCallback? = nil ) {
		self.key = key
		self.callback = callback
		self.scansContinuously = scansContinuously
		scanner_ = scanner
	}
}
