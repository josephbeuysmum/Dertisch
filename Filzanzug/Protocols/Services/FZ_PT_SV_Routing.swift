//
//  FZ_PT_SV_A.swift
//  Filzanzug
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import UIKit

public protocol FZRoutingServiceProtocol: FZModelClassProtocol, FZRoutingServiceRegistrarProtocol {
	func add ( rootViewController id: String, from storyboard: String? )
	func createNibFrom ( name nibName: String, for owner: FZViewController ) -> UIView?
	func create ( viewController id: String, from storyboard: String? ) -> FZViewController?
	func createAlertWith (
		title: String,
		message: String,
		buttonLabel: String,
		handler: @escaping ( ( UIAlertAction ) -> Void ),
		plusExtraButtonLabel extraButtonLabel: String? ) -> UIAlertController
	//	func present ( viewController id: String, on currentViewController: FZViewController )
	func present ( viewController id: String, on currentViewController: FZViewController, from storyboard: String )
	func start ( rootViewController: String, window: UIWindow, storyboard: String? )
}

public protocol FZRoutingServiceExtensionProtocol {
	func registerDependencies ( with key: String )
}

public protocol FZRoutingServiceRegistrarProtocol {
	func register (
		_ modelClassType: FZModelClassProtocol.Type,
		with key: String,
		injecting dependencyTypes: [ FZModelClassProtocol.Type ]? )
	func register (
		_ viewControllerId: String,
		as viewControllerType: FZViewControllerProtocol.Type,
		with interactorType: FZInteractorProtocol.Type,
		and presenterType: FZPresenterProtocol.Type,
		lockedBy key: String,
		andInjecting interactorDependencyTypes: [ FZModelClassProtocol.Type ]? )
}
