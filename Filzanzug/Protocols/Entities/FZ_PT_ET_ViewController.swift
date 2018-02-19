//
//  FZ_PT_ET_ViewController.swift
//  Filzanzug
//
//  Created by Richard Willis on 28/09/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

public protocol FZViewControllerEntityProtocol {
	func getViewControllerBy ( key: String ) -> FZViewController?
	func set ( viewController: FZViewController )
}
