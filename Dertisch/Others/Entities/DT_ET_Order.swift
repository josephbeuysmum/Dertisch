//
//  DT_ET_Signal.swift
//  Dertisch
//
//  Created by Richard Willis on 23/03/2018.
//  Copyright © 2018 Rich Text Lengthat Ltd. All rights reserved.
//

extension DTOrder: DTOrderProtocol {
	public var hasOrders: Bool { return orders_.count > 0 }
	
	public mutating func cleanUp() {}
	
	public mutating func add(callback: @escaping DTOrderCallback, order: DTOrdererProtocol, isContinuous: Bool) -> Bool {
		return add(order: DTOrderDetails(
			key: transmissionName,
			order: order,
			isContinuous: isContinuous,
			delegate: nil,
			callback: callback))
	}
	
	public mutating func add(delegate: DTOrderCallbackDelegateProtocol, order: DTOrdererProtocol, isContinuous: Bool) -> Bool {
		return add(order: DTOrderDetails(
			key: transmissionName,
			order: order,
			isContinuous: isContinuous,
			delegate: delegate,
			callback: nil))
	}
	
	public mutating func cancel(order: DTOrdererProtocol) {
		var tempWavelength = DTOrderDetails(key: transmissionName, order: order)
		let key = tempWavelength.description
		tempWavelength.cleanUp()
		removeWavelength(by: key)
	}
	
	public mutating func removeAllDetails() {
		orders_.forEach { order in
			var mutatableWavelength = order.value
			mutatableWavelength.cleanUp()
		}
		orders_.removeAll()
	}
		
	public mutating func removeSingleUseWavelengths() {
		orders_.forEach { order in
			guard !order.value.isContinuous else { return }
			self.removeWavelength(by: order.value.description)
		}
	}
	
	public func transmit(with value: Any?) {
		orders_.forEach { orderReference in
			var order = orderReference.value
			switch order.returnMethod {
			case DTOrderDetails.returnMethods.callback:		order.callback!(transmissionName, value)
			case DTOrderDetails.returnMethods.delegate:		order.delegate!.orderTransmission(name: transmissionName, data: value)
			case DTOrderDetails.returnMethods.none:			()
			}
		}
	}
	
	fileprivate mutating func add(order: DTOrderDetails) -> Bool {
		let key = order.description
		guard orders_[key] == nil else { return false }
		orders_[key] = order
		return true
	}
	
	fileprivate mutating func removeWavelength(by key: String) {
		guard var order = orders_.removeValue(forKey: key) else { return }
		order.cleanUp()
	}
}

// orders_ are the actual orders,
// whilst orders_ are references to the classes that observe them
// a signal may have many signatures, but a signature only has one signal

public struct DTOrder {
	public var transmissionName: String
	
	fileprivate var orders_: Dictionary<String, DTOrderDetails>
	
	public init (_ transmissionName: String) {
		self.transmissionName = transmissionName
		orders_ = [:]
	}
}
