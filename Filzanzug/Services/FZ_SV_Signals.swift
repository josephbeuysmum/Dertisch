 //
//  FZ_SV_Signals.swift
//  Boilerplate
//
//  Created by Richard Willis on 11/02/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

import Signals

public class FZSignalsService: FZSignalsServiceProtocol {
	// _signals are the actual signals, whilst _signatures are references to the classes that observer them
	// a signal may have many signatures, but a signature only has one signal
	fileprivate var
	_signals: Dictionary < String, Signal< ( String, Any? ) > >,
	_signatures: Dictionary < String, [ FZSignalSignature ] >
	
	
	
	public required init () {
		_signals = Dictionary < String, Signal< ( String, Any? ) > >()
		_signatures = Dictionary < String, [ FZSignalSignature ] >()
	}
	
	deinit {}
	
	
	
	// removes a signal
	public func annulSignalFor ( key: String, scanner: AnyObject ) {
		guard
			let signal = _getSignalBy( key: key, createIfMissing: false ) as Signal< ( String, Any? ) >?
			else { return }
		_annulSignalFor( key: key, signal: signal )
		loFeedback( "_annulSignalFor", key )
//		_log()
	}
	
	public func hasSignalFor ( key: String ) -> Bool { return _signals[ key ] != nil }
	
	// can be called from without to check current list of signals and scanners
	public func logSignatures () {
		var output = "CURRENT SIGNATURES:"
		for ( _, signatures ) in _signatures {
			_ = signatures.map { signature in output = "\( output ) \( signature.description )" }
		}
	}
	
	// adds a scanner
	@discardableResult
	public func scanFor (
		key: String,
		scanner: AnyObject,
		block: @escaping ( String, Any? ) -> Void ) -> Bool {
		return _scanFor( key: key, scanner: scanner, block: block, scanContinuously: true )
	}
	
	// adds many scanners
	@discardableResult
	public func scanFor (
		keys: [ String ],
		scanner: AnyObject,
		block: @escaping ( String, Any? ) -> Void
		) -> FZGradedBool {
		let len = keys.count
		var successes = 0.0
		_ = keys.map { key in
			if !_scanFor( key: key, scanner: scanner, block: block, scanContinuously: true ) { successes += 1 }
		}
		// FZGradedBool allows us to show what percent of additions were successful
		return FZGradedBool( successes / Double( len ) )
	}
	
	// adds a scanner once, so that once it has fired it automatically annuls itself
	@discardableResult
	public func scanOnceFor (
		key: String,
		scanner: AnyObject,
		block: @escaping ( String, Any? ) -> Void
		) -> Bool {
		return _scanFor( key: key, scanner: scanner, block: block, scanContinuously: false )
	}
	
	// removes a scanner
	public func stopScanningFor ( key: String, scanner: AnyObject ) -> Bool {
		return _stopScanningFor( key: key, scanner: scanner )
//		_log()
	}
	
	// removes multiple scanners
	public func stopScanningFor ( keys: [ String ], scanner: AnyObject ) -> FZGradedBool {
		var successes = 0.0
		_ = keys.map { key in if _stopScanningFor( key: key, scanner: scanner ) { successes += 1 } }
		// FZGradedBool allows us to show what percent of additions were successful
		return FZGradedBool( successes / Double( keys.count ) )
	}
	
	// transmits a signal
	public func transmitSignalFor ( key: String, data: Any? = nil ) {
		_transmitSignalFor( key: key, data: data )
	}
	
	
	
	// create a scanning relationship
	fileprivate func _scanFor (
		key: String,
		scanner: AnyObject,
		block: @escaping ( String, Any? ) -> Void,
		scanContinuously: Bool
		) -> Bool {
		// block duplicate scanners
		guard !_scannerExistsFor( key: key, scanner: scanner ) else { return false }
		var success = false
		
		// get or create signal
		if let signal = _getSignalBy( key: key, createIfMissing: true ) as Signal< ( String, Any? )>? {
			let signature = FZSignalSignature(
				key: key,
				scanner: scanner,
				scansContinuously: scanContinuously )
			
			// register the scanner to the signal
			if _signatures[ key ] == nil { _signatures[ key ] = [ FZSignalSignature ]() }
			_signatures[ key ]!.append( signature )
			
			// then scan
			if scanContinuously {
				signal.subscribe( on: scanner, callback: block )
			} else {
				// _onOneOffSignalFired scans to annul single-firing scanners and signals
				signal.subscribeOnce(
					on: scanner,
					callback: {
						[ unowned self ] key, _ in
						guard let scopedSignatures = self._signatures[ key ] else { return }
//							let len = scopedSignatures.count as Int?
//						var scopedSignature: FZSignalSignature
						
						// loop through all scopedSignatures
						_ = scopedSignatures.map {
							scopedSignature in
							// if we found the one to annul, then do so
							if scopedSignature.scansContinuously == false && scopedSignature.key == key {
								// this is a bit hacky: signals take maybe 0.01 secs to fire, so we have to delay the removal of their scanners for at least this length of time so that they still have time to scan before being annulled
								DispatchQueue.main.asyncAfter(
									deadline: DispatchTime.now() + 0.1,
									execute: {
										loFeedback( "REMOVING ONE-OFF LISTENER key: \( key ) scanner: \( scopedSignature.scanner )" )
										_ = self._stopScanningFor( key: key, scanner: scopedSignature.scanner )
								} )
							}
						} } )
				signal.subscribeOnce( on: scanner, callback: block )
			}
			success = true
		}
		loFeedback( "ADD LISTENER key: \( key ) scanner: \( String( describing: FZString.simplify( description: scanner.description ) ) ) signals:  \( _getFZSignalSignaturesDescription() )" )
		
		return success
	}
	
	// if nothing is left scanning to this signal, it might as well be deleted
	fileprivate func _annulEmpty ( signal: Signal< ( String, Any? ) >, key: String, scanner: AnyObject ) {
		loFeedback( "ANNUL EMPTY key: \( key ) signals: \( _getFZSignalSignaturesDescription() )" )
		guard signal.observers.count < 1 else { return }
		_annulSignalFor( key: key, signal: signal )
	}
	
	// annuls a signal
	fileprivate func _annulSignalFor ( key: String, signal: Signal< ( String, Any? ) > ) {
		signal.cancelAllSubscriptions()
		_signals.removeValue( forKey: key )
		_signatures.removeValue( forKey: key )
	}
	
	// returns a signal by a key; creates the signal if it's missing
	fileprivate func _getSignalBy ( key: String, createIfMissing: Bool ) -> Signal< ( String, Any? ) >? {
		if _signals[ key ] == nil && createIfMissing {
			_signals[ key ] = Signal< ( String, Any? ) >()
		}
		
		return _signals[ key ] == nil ? nil : _signals[ key ]!
	}
	
	// logging function
	fileprivate func _getFZSignalSignaturesDescription () -> String {
		var signaturesDescription = FZCharConsts.emptyString
		for ( key, _ ) in _signals { signaturesDescription = "\( signaturesDescription )\n^                           \( key )" }
		return signaturesDescription
	}
	
	// checks for existence of a scanner
	fileprivate func _scannerExistsFor ( key: String, scanner: AnyObject ) -> Bool {
		guard
			let scanners = _signatures[ key ] as [ FZSignalSignature ]?,
			let countScanners = scanners.count as Int?
			else { return false }
		for i in 0..<countScanners { if scanners[ i ].scanner === scanner { return true } }
		return false
	}
	
	fileprivate func _stopScanningFor ( key: String, scanner: AnyObject ) -> Bool {
		guard let signal = _getSignalBy( key: key, createIfMissing: false ) else { return false }
		
		// stop scanning
		signal.clearLastData()
		signal.cancelSubscription( for: scanner )
		
		// if nothing is left scanning to this signal, we might as well delete it
		_annulEmpty( signal: signal, key: key, scanner: scanner )
		
		if let scopedSignatures = _signatures[ key ] {
			let countScopedSignatures = scopedSignatures.count
			var scopedSignature: FZSignalSignature
			for i in 0..<countScopedSignatures {
				scopedSignature = scopedSignatures[ i ]
				
				// any signature with the signal's key that belongs to the calling object can also be deleted
				if  scopedSignature.key == key,
					scopedSignature.scanner === scanner {
					_signatures[ key ]!.remove( at: i )
					break
				}
			}
		}
		loFeedback( "ANNUL LISTENER key: \( key ) scanner: \( String( describing: FZString.simplify( description: scanner.description ) ) ) signals: \( _getFZSignalSignaturesDescription() )" )
		return true
	}
	
	fileprivate func _transmitSignalFor ( key: String, data: Any? = nil ) {
		guard let signal = _getSignalBy( key: key, createIfMissing: false ) as Signal< ( String, Any? ) >? else {
			loFeedback( "no signal for: \( key )" )
			return
		}
		loFeedback( "TRANSMITTING key: \( key )" )
		signal => ( key, data: data )
		//		if _logs { _log() }
	}
}
