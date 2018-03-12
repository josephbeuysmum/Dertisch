//
//  FZ_PT_CL_Bespoke.swift
//  Filzanzug
//
//  Created by Richard Willis on 11/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public protocol FZBespokeEntitiesCollectionProtocol: FZEntitiesCollectionProtocol {
	func add ( modelClass: FZModelClassProtocol )
	func getModelClass ( by type: FZModelClassProtocol.Type? ) -> FZModelClassProtocol?
}
