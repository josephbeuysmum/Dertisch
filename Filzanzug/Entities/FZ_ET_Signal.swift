//
//  FZ_ET_Signal.swift
//  Filzanzug
//
//  Created by Richard Willis on 23/03/2018.
//  Copyright © 2018 Rich Text Lengthat Ltd. All rights reserved.
//

extension FZSignal: FZSignalProtocol {
	public typealias FZSignalCallback = (String, Any?) -> Void

	public var hasScanners: Bool { return wave_lengths.count > 0 }
	
	public func deallocate () {}
	

	public mutating func add(_ scanner: FZSignalReceivableProtocol, scansContinuously: Bool, callback: @escaping FZSignalCallback) -> Bool {
		let
		wavelength = FZSignalWavelength(key: transmission, scanner: scanner, scansContinuously: scansContinuously, callback: callback),
		key = wavelength.description
		guard wave_lengths[key] == nil else { return false }
		wave_lengths[key] = wavelength
		return true
	}
	
	public mutating func remove(_ scanner: FZSignalReceivableProtocol) {
		var tempWavelength = FZSignalWavelength(key: transmission, scanner: scanner)
		let key = tempWavelength.description
		tempWavelength.deallocate()
		removeWavelength(by: key)
	}
	
	public mutating func removeAllWavelengths () {
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
		wave_lengths.forEach { wavelength in
			wavelength.value.callback?(transmission, value)
		}
	}
	
	fileprivate mutating func removeWavelength(by key: String) {
		guard var wavelength = wave_lengths.removeValue(forKey: key) else { return }
		wavelength.deallocate()
	}
}

// signals_ are the actual signals,
// whilst wave_lengths are references to the classes that observe them
// a signal may have many signatures, but a signature only has one signal

/*
mand value/id
array closures
func transmit ( with value/id )

*/
public struct FZSignal {
	public var transmission: String
	
	fileprivate var wave_lengths: Dictionary<String, FZSignalWavelength>
	
	public init (_ transmission: String) {
		self.transmission = transmission
		wave_lengths = [:]
	}
}
