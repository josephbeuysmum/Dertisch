//
//  FZ_PT_ET_Presenter.swift
//  Filzanzug
//
//  Created by Richard Willis on 04/08/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

public protocol FZPresenterEntitiesCollectionProtocol: FZEntitiesCollectionProtocol {
	var routing: FZRoutingService? { get }
	var viewController: FZViewController? { get }
	init ( routing: FZRoutingService?, viewController: FZViewController? )
}
