//
//  FZ_ET_CoreData.swift
//  Filzanzug
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public enum FZCoreDataTypes {
	case string( String ), int( Int ), bool( Bool )
}

extension FZCoreDataTypes: Equatable {
	public static func == ( lhs: FZCoreDataTypes, rhs: FZCoreDataTypes ) -> Bool {
		switch ( lhs, rhs ) {
		case ( .string, .string ), ( .int, .int ), ( .bool, .bool ):	return true
		default:														return false
		}
	}
}

public struct FZCoreDataKey {
	public let key: String
	public let type: FZCoreDataTypes
	
	public init ( key: String, type: FZCoreDataTypes ) {
		self.key = key
		self.type = type
	}
}

public struct FZCoreDataEntity: FZCoreDataEntityProtocol {
	public var allAttributes: [ [ FZCoreDataTypes ] ] { return all_attributes }
	public var name: String { return name_ }
	
	fileprivate let
	name_: String,
	keys_: [ FZCoreDataKey ],
	count_: Int
	
	fileprivate var all_attributes: [ [ FZCoreDataTypes ] ]
	
	init () { fatalError( "init() has not been implemented" ) }
	
	public init ( name: String, keys: [ FZCoreDataKey ] ) {
		name_ = name
		keys_ = keys
		count_ = keys_.count
		all_attributes = []
	}
	
	mutating public func add ( attributes: [ FZCoreDataTypes ] ) {
		guard attributes.count == count_ else { return }
		for i in 0..<count_ { if attributes[ i ] != keys_[ i ].type { return } }
		all_attributes.append( attributes )
	}
	
	mutating public func add ( multipleAttributes: [ [ FZCoreDataTypes ] ] ) {
		multipleAttributes.forEach { attributes in add( attributes: attributes ) }
	}
	
	public func getKey ( by index: Int ) -> String? {
		return keys_[ index ].key
	}
}

