//
//  FZ_PT_Services.swift
//  Filzanzug
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

//import UIKit
//
//public protocol FZRoutingServiceProtocol: FZModelClassProtocol, FZRoutingServiceRegistrarProtocol {
//	func add ( rootViewController id: String, from storyboard: String? )
//	func createNibFrom ( name nibName: String, for owner: FZViewController ) -> UIView?
//	func create ( viewController id: String, from storyboard: String? ) -> FZViewController?
//	func createAlertWith (
//		title: String,
//		message: String,
//		buttonLabel: String,
//		handler: @escaping ( ( UIAlertAction ) -> Void ),
//		plusExtraButtonLabel extraButtonLabel: String? ) -> UIAlertController
//	//	func present ( viewController id: String, on currentViewController: FZViewController )
//	func present ( viewController id: String, on currentViewController: FZViewController, from storyboard: String )
//	func start ( rootViewController: String, window: UIWindow, storyboard: String? )
//}
//
//public protocol FZRoutingServiceExtensionProtocol {
//	func registerDependencies ( with key: String )
//}
//
//public protocol FZRoutingServiceRegistrarProtocol {
//	func register (
//		_ modelClassType: FZModelClassProtocol.Type,
//		with key: String,
//		injecting dependencyTypes: [ FZModelClassProtocol.Type ]? )
//	func register (
//		viewControllerId: String,
//		viewControllerType: FZViewControllerProtocol.Type,
//		interactorType: FZInteractorProtocol.Type,
//		presenterType: FZPresenterProtocol.Type,
//		with key: String,
//		injecting interactorDependencyTypes: [ FZModelClassProtocol.Type ]? )
//}

//public protocol FZSignalsServiceProtocol {
//	func annulSignalFor ( key: String, scanner: AnyObject )
//	func hasSignalFor ( key: String ) -> Bool
//	func logSignatures ()
//	func scanFor (
//		key: String,
//		scanner: AnyObject,
//		block: @escaping ( String, Any? ) -> Void ) -> Bool
//	func scanFor (
//		keys: [ String ],
//		scanner: AnyObject,
//		block: @escaping ( String, Any? ) -> Void ) -> FZGradedBool
//	func scanOnceFor (
//		key: String,
//		scanner: AnyObject,
//		block: @escaping ( String, Any? ) -> Void ) -> Bool
//	func stopScanningFor ( key: String, scanner: AnyObject ) -> Bool
//	func stopScanningFor ( keys: [ String ], scanner: AnyObject ) -> FZGradedBool
//	func transmitSignalFor ( key: String, data: Any? )
//}

//public protocol FZUrlSessionServiceProtocol: FZModelClassProtocol {
//	func call (
//		url: String,
//		method: FZUrlSessionService.methods,
//		parameters: Dictionary< String, String >?,
//		scanner: AnyObject?,
//		block: ( ( String, Any? ) -> Void )? )
//}

