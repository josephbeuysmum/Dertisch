//
//  Carte.swift
//  Dertisch
//
//  Created by Richard Willis on 14/02/2019.
//  Copyright © 2019 Rich Text Format Ltd. All rights reserved.
//

import Foundation

public protocol CarteForCustomer {}

// todo reinstate carte.stock()? And see if we can somehow make it generic?
public protocol CarteForWaiter {
	//	func stock(with order: FulfilledOrder)
	func empty()
}

public protocol CarteProtocol: CarteForCustomer, CarteForWaiter {
	//	init(_ entrees: Dishes?)
}

public extension CarteForWaiter {
	//	func stock(with order: FulfilledOrder) {}
	func empty() {}
}

public extension CarteForCustomer {
	func des<T>(_ id: String) -> T? {
		guard let dishes = (self as? Carte)?.dishes_ else { return nil }
		let tempValue: Any?
		if let mandatoryValue = dishes[id] {
			tempValue = mandatoryValue
		} else if let optionalValue = dishes["\(id).some"] {
			tempValue = optionalValue
		} else {
			tempValue = nil
		}
		guard tempValue != nil else { return nil }
		let value = tempValue!
		if let result = value as? T {
			return result
		} else {
			// todo add CGFloat etc. here
			let tType = type(of: T.self)
			switch true {
			case tType == String.Type.self:
				return "\(value)" as? T
			case tType == Int.Type.self:
				if value is Float { return Int(round(Double(value as! Float))) as? T }
				if value is Double { return Float(value as! Double) as? T }
			case tType == Float.Type.self:
				if value is Int { return Float(value as! Int) as? T }
				if value is Double { return Float(value as! Double) as? T }
			case tType == Double.Type.self:
				if value is Int { return Double(value as! Int) as? T }
				if value is Float { return Double(value as! Float) as? T }
			case tType == Bool.Type.self:
				if value is Int { return ((value as! Int) == 1) as? T }
				if value is String { return ((value as! String) == "1") as? T }
				if value is Double { return ((value as! Double) == 1.0) as? T }
				if value is Float { return ((value as! Float) == 1.0) as? T }
			default: ()
			}
		}
		return nil
	}
	
	// todo we are currently using these to get array, when really they should be accessible through des<T>()
	func entrees<T>() -> T? {
		return (self as? Carte)?.entrees_ as? T
	}
}

// tood GC class or struct?
public struct Carte: CarteProtocol {
	// todo do these need trailing underscores?
	fileprivate let entrees_: Dishionarizer
	fileprivate var dishes_: Dishes?
	
	public init(_ entrees: Dishionarizer) {
		self.entrees_ = entrees
		guard let dishionary = entrees.dishionary else { return }
		self.dishes_ = Dishes(dishionary)
	}
}













fileprivate func dishionize(_ value: Any) -> Dishionary? {
	var dishionary = Dishionary()
	dishionize_(value, in: &dishionary)
	return dishionary.count > 0 ? dishionary : nil
}

fileprivate func dishionize_(_ value: Any, in dishionary: inout Dishionary, with prefix: String? = nil) {
	let mirror = Mirror(reflecting: value)
	var arrayCount = 0
	_ = mirror.children.compactMap {
		let
		label = $0.label ?? "\(arrayCount)",
		compositeLabel = prefix == nil ? label : "\(prefix!).\(label)",
		countChildren = Mirror(reflecting: $0.value).children.count
		if countChildren > 0 {
			if let array = $0.value as? Array<Any> {
				dishionary["\(compositeLabel).count"] = array.count
			}
			dishionize_($0.value, in: &dishionary, with: compositeLabel)
		} else if let value = $0.value as? SimpleDish {
			dishionary[compositeLabel] = value
		}
		arrayCount += 1
	}
}

extension Dishionarizer {
	// todo make dishionary once and once only
	var dishionary: Dishionary? {
		return dishionize(self)
	}
}
