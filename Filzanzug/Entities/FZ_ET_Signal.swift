//
//  FZ_ET_Signal.swift
//  Filzanzug
//
//  Created by Richard Willis on 23/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

extension FZSignal: FZSignalProtocol {
	public typealias FZSignalCallback = ( String, Any? ) -> Void

	public var hasScanners: Bool { return wave_forms.count > 0 }
	
	public func deallocate () {
		lo("what happens here?")
	}
	

	public mutating func add ( _ scanner: FZSignalReceivableProtocol, scansContinuously: Bool, callback: @escaping FZSignalCallback ) -> Bool {
		let waveform = FZSignalWaveform( key: transmission, scanner: scanner, scansContinuously: scansContinuously, callback: callback )
		let key = waveform.description
		guard wave_forms[ key ] == nil else { return false }
		wave_forms[ key ] = waveform
		return true
	}
	
	public mutating func remove ( _ scanner: FZSignalReceivableProtocol ) {
		var tempWaveform = FZSignalWaveform( key: transmission, scanner: scanner )
		let key = tempWaveform.description
		tempWaveform.deallocate()
		guard var waveForm = wave_forms.removeValue( forKey: key ) else { return }
		waveForm.deallocate()
	}
	
	public mutating func removeAllScanners () {
		wave_forms.forEach { waveForm in
			var wf = waveForm.value
			wf.deallocate()
		}
		wave_forms.removeAll()
	}
		
	public func transmit ( with value: Any? ) {
		wave_forms.forEach { waveForm in
			guard waveForm.value.callback != nil else { return }
			waveForm.value.callback!( transmission, value )
		}
	}
}

// signals_ are the actual signals,
// whilst wave_forms are references to the classes that observe them
// a signal may have many signatures, but a signature only has one signal

/*
mand value/id
array closures
func transmit ( with value/id )

*/
public struct FZSignal {
	public var transmission: String
	
	fileprivate var wave_forms: Dictionary< String, FZSignalWaveform >
	
	public init ( _ transmission: String ) {
		self.transmission = transmission
		wave_forms = [:]
	}
}
