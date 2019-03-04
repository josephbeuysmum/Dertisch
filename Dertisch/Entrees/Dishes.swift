//
//  Dishes.swift
//  Dertisch
//
//  Created by Richard Willis on 14/02/2019.
//  Copyright © 2019 Rich Text Format Ltd. All rights reserved.
//

public protocol Dish {}
public protocol SimpleDish: Dish {}
public protocol ComplexDish: Dish {}

extension Array: SimpleDish {}
extension Bool: SimpleDish {}
extension Double: SimpleDish {}
extension Float: SimpleDish {}
extension Int: SimpleDish {}
extension String: SimpleDish {}

public typealias Dishionary = [String: SimpleDish]

public struct Dishes: ComplexDish {
	private var dishes = Dishionary()
	
	init(_ dishes: Dishionary) {
		self.dishes = dishes
	}
}

extension Dishes: Collection {
	public typealias Index = Dishionary.Index
	public typealias Element = Dishionary.Element
	
	public var startIndex: Index { return dishes.startIndex }
	public var endIndex: Index { return dishes.endIndex }
	
	public subscript(index: Index) -> Iterator.Element {
		get { return dishes[index] }
	}
	
	public subscript(key: String) -> SimpleDish? {
		get { return dishes[key] }
	}
	
	public func index(after i: Index) -> Index {
		return dishes.index(after: i)
	}
}

public protocol Dishionarizer {
	var dishionary: Dishionary? { get }
}
