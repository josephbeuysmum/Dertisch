//
//  FZ_PT_ModelClass.swift
//  Hasenblut
//
//  Created by Richard Willis on 11/08/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

// herehere this needs adding into worncloset stuff too
extension FZModelClassProtocol {
	public func transmitActivation ( with key: String ) {
		signalBox.getSignalsServiceBy( key: key )?.transmitSignalFor( key: FZSignalConsts.modelClassActivated, data: className )
	}
}

public protocol FZModelClassProtocol: FZSignalBoxEntityProtocol, FZModelClassEntitiesEntityProtocol, FZActivatableProtocol, FZClassNameProtocol {
	func transmitActivation ( with key: String )
}
