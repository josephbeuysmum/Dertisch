//
//  FZ_ET_Caller.swift
//  Hasenblut
//
//  Created by Richard Willis on 27/06/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

public struct FZCaller {
	let caller: AnyObject?
	let block: ( ( String, Any? ) -> Void )?
}
