//
//  FZ_ETsignals_.swift
//  Filzanzug
//
//  Created by Richard Willis on 02/01/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

extension FZSignalsEntity: FZSignalsEntityProtocol {
	public var signals: FZSignalsService? {
		get { return signals_ }
		set {
			guard signals_ == nil else { return }
			signals_ = newValue
		}
	}
}

public struct FZSignalsEntity {
	fileprivate var signals_: FZSignalsService?
}
