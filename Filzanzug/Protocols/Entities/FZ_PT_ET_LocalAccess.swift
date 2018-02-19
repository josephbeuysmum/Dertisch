//
//  FZ_PT_ET_WO_LocalAccess.swift
//  Hasenblut
//
//  Created by Richard Willis on 28/09/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

public protocol FZLocalAccessEntityProtocol {
	func getLocalAccessProxyBy ( key scopedKey: String ) -> FZLocalAccessProxy?
	func set ( localAccessProxy: FZLocalAccessProxy )
}
