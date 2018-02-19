//
//  FZ_PT_ET_API.swift
//  Filzanzug
//
//  Created by Richard Willis on 28/09/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

public protocol FZApiEntityProtocol {
	func getApiServiceBy ( key scopedKey: String ) -> FZUrlSessionService?
	func set ( apiService: FZUrlSessionService )
}
