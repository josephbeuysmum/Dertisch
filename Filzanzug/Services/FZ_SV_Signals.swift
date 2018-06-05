 //
//  FZ_SVsignals_.swift
//  Filzanzug
//
//  Created by Richard Willis on 11/02/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

//import Signals

extension FZSignalsService: FZSignalsServiceProtocol {
	public typealias FZSignalCallback = (String, Any?) -> Void
	
	// removes a signal
	public func annulSignal (by key: String, scanner: AnyObject) {
		_annulSignal( by: key )
	}
	
	public func hasSignal (for key: String) -> Bool { return signals_[ key ] != nil }
	
	// adds a scanner
	@discardableResult
	public func scanFor (key: String, scanner: FZSignalReceivableProtocol, callback: @escaping FZSignalCallback) -> Bool {
		return _scanFor(key: key, scanner: scanner, scanContinuously: true, callback: callback)
	}
	
	// adds a scanner once
	@discardableResult
	public func scanOnceFor (key: String, scanner: FZSignalReceivableProtocol, callback: @escaping FZSignalCallback) -> Bool {
		return _scanFor(key: key, scanner: scanner, scanContinuously: false, callback: callback)
	}
	
	// removes a scanner
	public func stopScanningFor (key: String, scanner: AnyObject) {
		_annulSignal(by: key)
	}
	
	// transmits a signal
	public func transmitSignal(by key: String, with value: Any? = nil) {
		signals_[ key ]?.transmit(with: value)
	}
	
	
	
	// create a scanning relationship
	fileprivate func _scanFor (
		key: String,
		scanner: FZSignalReceivableProtocol,
		scanContinuously: Bool,
		callback: @escaping FZSignalCallback
		) -> Bool {
		_createSignalIfNecessary( by: key )
		return signals_[ key ]!.add( scanner, scansContinuously: scanContinuously, callback: callback )
	}
	
	// if nothing is left scanning to this signal, it might as well be deleted
	fileprivate func _annulEmpty ( signal: FZSignal, key: String, scanner: AnyObject ) {
//		loFeedback( "ANNUL EMPTY key: \( key ) signals: \( _getFZSignalWaveformsDescription() )" )
		guard !signal.hasScanners else { return }
		_annulSignal( by: key )
	}
	
	// annuls a signal
	fileprivate func _annulSignal ( by key: String ) {
		guard hasSignal( for: key ) else { return }
		signals_[ key ]!.removeAllScanners()
		signals_.removeValue( forKey: key )
	}
	
	// returns a signal by a key; creates the signal if it's missing
	fileprivate func _createSignalIfNecessary ( by key: String ) {
		guard !hasSignal( for: key ) else { return }
		signals_[ key ] = FZSignal( key )
	}
}

public class FZSignalsService {
	fileprivate var
	signals_: Dictionary < String, FZSignal >
	
	required public init () {
		signals_ = Dictionary < String, FZSignal >()
	}
	
	deinit {}
}
