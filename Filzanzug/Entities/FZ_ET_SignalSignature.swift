//
//  FZ_ETsignals_ignature.swift
//  Filzanzug
//
//  Created by Richard Willis on 04/04/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

// FZSignalSignature stores a uniquely identifiable way to track signal scanners, with a key and a flag denoting whether the signal is permanently observed or just a one-off
extension FZSignalSignature {
	public var description: String { get { return "\( key ) \( scanner ) \( scansContinuously )" } }
}

public struct FZSignalSignature {
	public let
	key: String,
	scanner: AnyObject,
	scansContinuously: Bool
}
