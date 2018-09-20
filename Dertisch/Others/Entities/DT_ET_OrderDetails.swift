//
//  DT_ETorders_ignature.swift
//  Dertisch
//
//  Created by Richard Willis on 04/04/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

import Foundation

// DTOrderDetails stores a uniquely identifiable way to track signal orders, with a key and a flag denoting whether the signal is permanently observed or just a one-off
extension DTOrderDetails {
	public enum returnMethods { case callback, delegate, none }
	
	public var description: String {
		return "\(key)-\(id_)"
	}
	
	public var returnMethod: returnMethods {
		switch true {
		case callback != nil:	return returnMethods.callback
		case delegate != nil:	return returnMethods.delegate
		default:				return returnMethods.none
		}
	}
	
	public mutating func cleanUp() {
		order_ = nil
	}
}

public struct DTOrderDetails {
	public let
	key: String,
	isContinuous: Bool,
	callback: DTOrderCallback?
	
	public var delegate: DTOrderCallbackDelegateProtocol?
	
	fileprivate let id_: String
	
	fileprivate var order_: DTOrdererProtocol?
	
	init(
		key: String,
		order: DTOrdererProtocol,
		isContinuous: Bool = true,
		delegate: DTOrderCallbackDelegateProtocol? = nil,
		callback: DTOrderCallback? = nil) {
		self.key = key
		self.callback = callback
		self.delegate = delegate
		self.isContinuous = isContinuous
		id_ = NSUUID().uuidString
		order_ = order
	}
}
