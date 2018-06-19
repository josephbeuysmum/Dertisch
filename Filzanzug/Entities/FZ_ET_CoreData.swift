//
//  FZ_ET_CoreData.swift
//  Filzanzug
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public enum FZCDTypes { case bool, double, int, string }

//extension FZCDTypes: Equatable {
//	public static func == (lhs: FZCDTypes, rhs: FZCDTypes) -> Bool {
//		switch (lhs, rhs) {
//		case (.string, .string), (.int, .int), (.bool, .bool):		return true
//		default:													return false
//		}
//	}
//}


public protocol FZCDAble {}

extension Bool: FZCDAble {}
extension Double: FZCDAble {}
extension Int: FZCDAble {}
extension String: FZCDAble {}



public struct FZCDKey {
	public let key: String
	public let type: FZCDTypes
	
	public init (_ key: String, _ type: FZCDTypes) {
		self.key = key
		self.type = type
	}
}



public struct FZCDAttribute {
	public let key: String
	public let value: FZCDAble
	
	public init (_ key: String, _ value: FZCDAble) {
		self.key = key
		self.value = value
	}
}


public struct FZCDEntity: FZCDEntityProtocol {
	fileprivate typealias TypesCollection = [String: FZCDTypes]
	
	public var attributes: [String: FZCDAble] { return attributes_ }
	public var name: String { return name_ }
	
	fileprivate let
	name_: String,
	types_: TypesCollection
	
	fileprivate var attributes_: [String: FZCDAble]
	
	init () { fatalError("init() has not been implemented") }
	
	public init (_ name: String, keys: [FZCDKey]) {
		name_ = name
		attributes_ = [:]
		var types: TypesCollection = [:]
		keys.forEach { key in
			types[key.key] = key.type
		}
		types_ = types
	}
	
//	mutating public func add (_ attribute: FZCDAttribute) {
	mutating public func add(_ attribute: FZCDAble, by key: String) -> Bool {
		guard
			let type = types_[key],
			self.assessValidity(of: attribute, by: type)
			else { return false }
		attributes_[key] = attribute
		return true
	}
	
//	mutating public func add (attributes: [FZCDAttribute]) {
//		attributes.forEach { attribute in add(attribute) }
//	}

//	mutating public func add ( multipleAttributes: [ [ FZCDTypes ] ] ) {
//		multipleAttributes.forEach { attributes in add( attributes: attributes ) }
//	}
	
//	public func getKey ( by index: Int ) -> String? {
//		return types_[ index ].key
//	}
	
fileprivate func assessValidity(of attribute: FZCDAble, by type: FZCDTypes) -> Bool {
		switch type {
		case FZCDTypes.bool:	return attribute is Bool
		case FZCDTypes.double:	return attribute is Double
		case FZCDTypes.int:		return attribute is Int || attribute is Int16 || attribute is Int32 || attribute is Int64
		case FZCDTypes.string:	return attribute is String
		}
	}
}

