 //
//  DT_SVorders_.swift
//  Dertisch
//
//  Created by Richard Willis on 11/02/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

extension DTOrders: DTOrdersProtocol {
	public func cancel(order key: String, order: AnyObject) {
		annulOrder( by: key )
	}
	
	public func has(order key: String) -> Bool { return orders_[key] != nil }
	
	@discardableResult
	public func listenFor(order key: String, order: DTOrderReceivableProtocol, callback: @escaping DTOrderCallback) -> Bool {
		return make(callback: callback, key: key, order: order, isContinuous: true)
	}
	
//	public func listenFor(order key: String, order: DTOrderReceivableProtocol, delegate: DTOrderCallbackDelegateProtocol) -> Bool {
//		return make(delegate: delegate, key: key, order: order, isContinuous: true)
//	}
	
	@discardableResult
	public func listenForOneOff(order key: String, order: DTOrderReceivableProtocol, callback: @escaping DTOrderCallback) -> Bool {
		return make(callback: callback, key: key, order: order, isContinuous: false)
	}
	
//	public func listenForOneOff(order key: String, order: DTOrderReceivableProtocol, delegate: DTOrderCallbackDelegateProtocol) -> Bool {
//		return make(delegate: delegate, key: key, order: order, isContinuous: false)
//	}
	
	public func stopWaitingFor(order key: String, order: DTOrderReceivableProtocol) {
		annulOrder(by: key)
	}
	
	public func make(order key: String, with value: Any? = nil) {
		guard var order = orders_[key] else { return }
		order.transmit(with: value)
		// permitting myself a comment here. adding this extra function 'removeSingleUseWavelengths()' because if we try to remove the wavelengths in the order.transmit() function call the compiler will complain that we are potentially modifying the internal wave_lengths dictionary from two places simultaneously, which is obviously dangerous. The fact that we are accessing it from out here means it would be safe, but the compiler does not know that. I believe this is because DTOrders are structs, although I'm not sure yet
		order.removeSingleUseWavelengths()
		orders_[key] = order
	}
	
	
	
	fileprivate func make(
		callback: @escaping DTOrderCallback,
		key: String,
		order: DTOrderReceivableProtocol,
		isContinuous: Bool) -> Bool {
		createOrderIfNecessary(by: key)
		return orders_[key]!.add(callback: callback, order: order, isContinuous: isContinuous)
	}
	
	fileprivate func make(
		delegate: DTOrderCallbackDelegateProtocol,
		key: String,
		order: DTOrderReceivableProtocol,
		isContinuous: Bool) -> Bool {
		createOrderIfNecessary(by: key)
		return orders_[key]!.add(delegate: delegate, order: order, isContinuous: isContinuous)
	}
	
	// if nothing is left scanning to this order, it might as well be deleted
	fileprivate func annulEmpty ( order: DTOrder, key: String ){//}, order: AnyObject ) {
//		loFeedback( "ANNUL EMPTY key: \( key ) orders: \( _getDTOrderDetailssDescription() )" )
		guard !order.hasOrders else { return }
		annulOrder( by: key )
	}
	
	// annuls a order
	fileprivate func annulOrder ( by key: String ) {
		guard has(order: key) else { return }
		orders_[key]!.removeAllDetails()
		orders_.removeValue( forKey: key )
	}
	
	// returns a order by a key; creates the order if it's missing
	fileprivate func createOrderIfNecessary ( by key: String ) {
		guard !has(order: key) else { return }
		orders_[key] = DTOrder( key )
	}
}

public class DTOrders {
	fileprivate var orders_: Dictionary<String, DTOrder>
	
	required public init () {
		orders_ = [:]
	}
	
	deinit {}
}
