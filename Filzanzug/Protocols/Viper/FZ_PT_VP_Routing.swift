//
//  FZ_PT_PX_View.swift
//  Hasenblut
//
//  Created by Richard Willis on 12/11/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

import UIKit

public protocol FZRoutingServiceProtocol: FZModelClassProtocol {
	var window: UIWindow? { get set }
	func add ( rootViewController id: String )
	func add ( rootViewController id: String, from storyboard: String )
	func createNibFrom ( name nibName: String, for owner: FZViewController ) -> UIView?
	func create ( viewController id: String ) -> UIViewController?
	func create ( viewController id: String, from storyboard: String ) -> UIViewController?
	func createAlertWith (
		title: String,
		message: String,
		buttonLabel: String,
		handler: @escaping ( ( UIAlertAction ) -> Void ),
		plusExtraButtonLabel extraButtonLabel: String? ) -> UIAlertController
	func present ( viewController id: String, on currentViewController: FZViewController )
	func present ( viewController id: String, on currentViewController: FZViewController, from storyboard: String )
	func start ()
	func styleApp ()
}
