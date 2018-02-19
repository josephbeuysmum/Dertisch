//
//  FZ_PT_ET_Interactor.swift
//  Filzanzug
//
//  Created by Richard Willis on 15/08/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

public protocol FZInteractorEntityProtocol {
	func getInteractorBy ( key: String ) -> FZInteractorProtocol?
	func set ( interactor: FZInteractorProtocol )
}
