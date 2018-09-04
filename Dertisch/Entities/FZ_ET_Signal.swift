//
//  DT_ET_Signal.swift
//  Dertisch
//
//  Created by Richard Willis on 23/03/2018.
//  Copyright © 2018 Rich Text Lengthat Ltd. All rights reserved.
//

extension DTOrder: DTOrderProtocol {
	public var hasOrders: Bool { return wave_lengths.count > 0 }
	
	public mutating func cleanUp() {}
	
	public mutating func add(callback: @escaping DTOrderCallback, order: DTOrderReceivableProtocol, isContinuous: Bool) -> Bool {
		return add(wavelength: DTOrderDetails(
			key: transmissionName,
			order: order,
			isContinuous: isContinuous,
			delegate: nil,
			callback: callback))
	}
	
	public mutating func add(delegate: DTOrderCallbackDelegateProtocol, order: DTOrderReceivableProtocol, isContinuous: Bool) -> Bool {
		return add(wavelength: DTOrderDetails(
			key: transmissionName,
			order: order,
			isContinuous: isContinuous,
			delegate: delegate,
			callback: nil))
	}
	
	public mutating func cancel(order: DTOrderReceivableProtocol) {
		var tempWavelength = DTOrderDetails(key: transmissionName, order: order)
		let key = tempWavelength.description
		tempWavelength.cleanUp()
		removeWavelength(by: key)
	}
	
	public mutating func removeAllDetails() {
		wave_lengths.forEach { wavelength in
			var mutatableWavelength = wavelength.value
			mutatableWavelength.cleanUp()
		}
		wave_lengths.removeAll()
	}
		
	public mutating func removeSingleUseWavelengths() {
		wave_lengths.forEach { wavelength in
			guard !wavelength.value.isContinuous else { return }
			self.removeWavelength(by: wavelength.value.description)
		}
	}
	
	public func transmit(with value: Any?) {
		wave_lengths.forEach { wavelengthReference in
			var wavelength = wavelengthReference.value
			switch wavelength.returnMethod {
			case DTOrderDetails.returnMethods.callback:		wavelength.callback!(transmissionName, value)
			case DTOrderDetails.returnMethods.delegate:		wavelength.delegate!.orderTransmission(name: transmissionName, data: value)
			case DTOrderDetails.returnMethods.none:			()
			}
		}
	}
	
	fileprivate mutating func add(wavelength: DTOrderDetails) -> Bool {
		let key = wavelength.description
		guard wave_lengths[key] == nil else { return false }
		wave_lengths[key] = wavelength
		return true
	}
	
	fileprivate mutating func removeWavelength(by key: String) {
		guard var wavelength = wave_lengths.removeValue(forKey: key) else { return }
		wavelength.cleanUp()
	}
}

// orders_ are the actual orders,
// whilst wave_lengths are references to the classes that observe them
// a signal may have many signatures, but a signature only has one signal

public struct DTOrder {
	public var transmissionName: String
	
	fileprivate var wave_lengths: Dictionary<String, DTOrderDetails>
	
	public init (_ transmissionName: String) {
		self.transmissionName = transmissionName
		wave_lengths = [:]
	}
}
