//
//  FZ_ET_Signal.swift
//  Filzanzug
//
//  Created by Richard Willis on 23/03/2018.
//  Copyright © 2018 Rich Text Lengthat Ltd. All rights reserved.
//

extension FZSignal: FZSignalProtocol {
	public var hasScanners: Bool { return wave_lengths.count > 0 }
	
	public func deallocate () {}
	

	public mutating func add(callback: @escaping FZSignalCallback, scanner: FZSignalReceivableProtocol, scansContinuously: Bool) -> Bool {
		return add(wavelength: FZSignalWavelength(
			key: transmissionName,
			scanner: scanner,
			scansContinuously: scansContinuously,
			delegate: nil,
			callback: callback))
	}
	
	public mutating func add(delegate: FZSignalCallbackDelegateProtocol, scanner: FZSignalReceivableProtocol, scansContinuously: Bool) -> Bool {
		return add(wavelength: FZSignalWavelength(
			key: transmissionName,
			scanner: scanner,
			scansContinuously: scansContinuously,
			delegate: delegate,
			callback: nil))
	}
	
	public mutating func remove(scanner: FZSignalReceivableProtocol) {
		var tempWavelength = FZSignalWavelength(key: transmissionName, scanner: scanner)
		let key = tempWavelength.description
		tempWavelength.deallocate()
		removeWavelength(by: key)
	}
	
	public mutating func removeAllWavelengths() {
		wave_lengths.forEach { wavelength in
			var mutatableWavelength = wavelength.value
			mutatableWavelength.deallocate()
		}
		wave_lengths.removeAll()
	}
		
	public mutating func removeSingleUseWavelengths() {
		wave_lengths.forEach { wavelength in
			guard !wavelength.value.scansContinuously else { return }
			self.removeWavelength(by: wavelength.value.description)
		}
	}
	
	public func transmit(with value: Any?) {
		wave_lengths.forEach { wavelengthReference in
			var wavelength = wavelengthReference.value
			switch wavelength.returnMethod {
			case FZSignalWavelength.returnMethods.callback:		wavelength.callback!(transmissionName, value)
			case FZSignalWavelength.returnMethods.delegate:		wavelength.delegate!.signalTransmission(name: transmissionName, data: value)
			case FZSignalWavelength.returnMethods.none:			()
			}
		}
	}
	
	fileprivate mutating func add(wavelength: FZSignalWavelength) -> Bool {
		let key = wavelength.description
		guard wave_lengths[key] == nil else { return false }
		wave_lengths[key] = wavelength
		return true
	}
	
	fileprivate mutating func removeWavelength(by key: String) {
		guard var wavelength = wave_lengths.removeValue(forKey: key) else { return }
		wavelength.deallocate()
	}
}

// signals_ are the actual signals,
// whilst wave_lengths are references to the classes that observe them
// a signal may have many signatures, but a signature only has one signal

public struct FZSignal {
	public var transmissionName: String
	
	fileprivate var wave_lengths: Dictionary<String, FZSignalWavelength>
	
	public init (_ transmissionName: String) {
		self.transmissionName = transmissionName
		wave_lengths = [:]
	}
}
