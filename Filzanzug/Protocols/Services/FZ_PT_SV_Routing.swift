//
//  FZ_PT_SV_Routing.swift
//  Filzanzug
//
//  Created by Richard Willis on 12/11/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

import UIKit

public protocol FZRoutingServiceProtocol: FZModelClassProtocol {
	func add ( rootViewController id: String, inside window: UIWindow, from storyboard: String? )
	func createNibFrom ( name nibName: String, for owner: FZViewController ) -> UIView?
	func create ( viewController id: String, from storyboard: String? ) -> UIViewController?
	func createAlertWith (
		title: String,
		message: String,
		buttonLabel: String,
		handler: @escaping ( ( UIAlertAction ) -> Void ),
		plusExtraButtonLabel extraButtonLabel: String? ) -> UIAlertController
	func present ( viewController id: String, on currentViewController: FZViewController )
	func present ( viewController id: String, on currentViewController: FZViewController, from storyboard: String )
}
