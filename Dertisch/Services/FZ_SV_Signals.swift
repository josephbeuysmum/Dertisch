 //
//  FZ_SVsignals_.swift
//  Dertisch
//
//  Created by Richard Willis on 11/02/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

extension FZSignalsService: FZSignalsServiceProtocol {
	public func annul(signal key: String, scanner: AnyObject) {
		annulSignal( by: key )
	}
	
	public func has(signal key: String) -> Bool { return signals_[key] != nil }
	
	@discardableResult
	public func scanFor(signal key: String, scanner: FZSignalReceivableProtocol, callback: @escaping FZSignalCallback) -> Bool {
		return scanFor(callback: callback, key: key, scanner: scanner, scanContinuously: true)
	}
	
//	public func scanFor(signal key: String, scanner: FZSignalReceivableProtocol, delegate: FZSignalCallbackDelegateProtocol) -> Bool {
//		return scanFor(delegate: delegate, key: key, scanner: scanner, scanContinuously: true)
//	}
	
	@discardableResult
	public func scanOnceFor(signal key: String, scanner: FZSignalReceivableProtocol, callback: @escaping FZSignalCallback) -> Bool {
		return scanFor(callback: callback, key: key, scanner: scanner, scanContinuously: false)
	}
	
//	public func scanOnceFor(signal key: String, scanner: FZSignalReceivableProtocol, delegate: FZSignalCallbackDelegateProtocol) -> Bool {
//		return scanFor(delegate: delegate, key: key, scanner: scanner, scanContinuously: false)
//	}
	
	public func stopScanningFor(signal key: String, scanner: FZSignalReceivableProtocol) {
		annulSignal(by: key)
	}
	
	public func transmit(signal key: String, with value: Any? = nil) {
		guard var signal = signals_[key] else { return }
		signal.transmit(with: value)
		// permitting myself a comment here. adding this extra function 'removeSingleUseWavelengths()' because if we try to remove the wavelengths in the signal.transmit() function call the compiler will complain that we are potentially modifying the internal wave_lengths dictionary from two places simultaneously, which is obviously dangerous. The fact that we are accessing it from out here means it would be safe, but the compiler does not know that. I believe this is because FZSignals are structs, although I'm not sure yet
		signal.removeSingleUseWavelengths()
		signals_[key] = signal
	}
	
	
	
	fileprivate func scanFor(
		callback: @escaping FZSignalCallback,
		key: String,
		scanner: FZSignalReceivableProtocol,
		scanContinuously: Bool) -> Bool {
		createSignalIfNecessary(by: key)
		return signals_[key]!.add(callback: callback, scanner: scanner, scansContinuously: scanContinuously)
	}
	
	fileprivate func scanFor(
		delegate: FZSignalCallbackDelegateProtocol,
		key: String,
		scanner: FZSignalReceivableProtocol,
		scanContinuously: Bool) -> Bool {
		createSignalIfNecessary(by: key)
		return signals_[key]!.add(delegate: delegate, scanner: scanner, scansContinuously: scanContinuously)
	}
	
	// if nothing is left scanning to this signal, it might as well be deleted
	fileprivate func annulEmpty ( signal: FZSignal, key: String, scanner: AnyObject ) {
//		loFeedback( "ANNUL EMPTY key: \( key ) signals: \( _getFZSignalWavelengthsDescription() )" )
		guard !signal.hasScanners else { return }
		annulSignal( by: key )
	}
	
	// annuls a signal
	fileprivate func annulSignal ( by key: String ) {
		guard has(signal: key) else { return }
		signals_[key]!.removeAllWavelengths()
		signals_.removeValue( forKey: key )
	}
	
	// returns a signal by a key; creates the signal if it's missing
	fileprivate func createSignalIfNecessary ( by key: String ) {
		guard !has(signal: key) else { return }
		signals_[key] = FZSignal( key )
	}
}

public class FZSignalsService {
	fileprivate var signals_: Dictionary<String, FZSignal>
	
	required public init () {
		signals_ = [:]
	}
	
	deinit {}
}
