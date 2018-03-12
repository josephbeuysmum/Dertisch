//
//  FZ_SV_Routing.swift
//  Filzanzug
//
//  Created by Richard Willis on 12/11/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

import SwinjectStoryboard
import UIKit

extension FZRoutingService: FZRoutingServiceProtocol {
	public func activate () {
		guard let scopedSignals = wornCloset.getSignals( by: keyring_.key ) else { return }
		is_activated = true
		_ = scopedSignals.scanFor( key: FZSignalConsts.interactorActivated, scanner: self ) {
			[ unowned self ] _, data in self.set( interactor: data as? FZInteractorProtocol )
		}
		_ = scopedSignals.scanFor( key: FZSignalConsts.presenterActivated, scanner: self ) {
			[ unowned self ] _, data in self.set( presenter: data as? FZPresenterProtocol )
		}
		_ = scopedSignals.scanFor( key: FZSignalConsts.viewLoaded, scanner: self ) {
			[ unowned self ] _, data in self.set( view: data as? FZViewController )
		}
	}
	
	
	
	public func add ( rootViewController id: String, inside window: UIWindow, from storyboard: String? = nil ) {
		guard window_ == nil else { return }
		window_ = window
		window_.makeKeyAndVisible()
		_add( rootViewController: id, from: storyboard )
	}
	
	public func createNibFrom ( name nibName: String, for owner: FZViewController ) -> UIView? {
		guard let viewArray = Bundle.main.loadNibNamed( nibName, owner: owner, options: nil ) else { return nil }
		return viewArray[ 0 ] as? UIView
	}
	
	public func create ( viewController id: String, from storyboard: String? = nil ) -> UIViewController? {
		return _create( viewController: id, from: storyboard )
	}
	
	public func createAlertWith (
		title: String,
		message: String,
		buttonLabel: String,
		handler: @escaping ( ( UIAlertAction ) -> Void ),
		plusExtraButtonLabel extraButtonLabel: String? = nil ) -> UIAlertController {
		let alert = UIAlertController(
			title: title,
			message: message,
			preferredStyle: UIAlertControllerStyle.alert )
		
		// copy
		alert.addAction( UIAlertAction(
			title: buttonLabel,
			style: UIAlertActionStyle.default,
			handler: handler ) )
		
		if extraButtonLabel != nil {
			alert.addAction( UIAlertAction(
				title: extraButtonLabel!,
				style: UIAlertActionStyle.default,
				handler: nil ) )
		}
		
		return alert
	}
	
	public func present ( viewController id: String, on currentViewController: FZViewController ) {
		_present( viewController: id, on: currentViewController )
	}
	
	public func present ( viewController id: String, on currentViewController: FZViewController, from storyboard: String ) {
		_present( viewController: id, on: currentViewController, from: storyboard )
	}
	
	
	
	fileprivate func _add ( rootViewController id: String, from storyboard: String? = nil ) {
		guard let viewController = _create( viewController: id, from: storyboard ) else { return }
		window_.rootViewController = viewController
	}
	
	fileprivate func _create ( viewController id: String, from storyboardName: String? = nil ) -> UIViewController? {
		let name = storyboardName ?? "Main"
		if storyboards_[ name ] == nil { storyboards_[ name ] = SwinjectStoryboard.create( name: name, bundle: nil ) }
		return storyboards_[ name ]!.instantiateViewController( withIdentifier: id )
	}
	
	fileprivate func _present (
		viewController id: String,
		on currentViewController: FZViewController,
		from storyboard: String? = nil ) {
		guard let viewController = _create( viewController: id, from: storyboard ) else { return }
		//		lo(currentViewController, currentViewController.parent)
		currentViewController.present(
			viewController,
			animated: true,
			completion: {
				currentViewController.removeFromParentViewController()
				self.wornCloset.getSignals( by: self.keyring_.key )?.transmitSignalFor( key: FZSignalConsts.viewRemoved )
		} )
	}
	
	fileprivate func set ( interactor: FZInteractorProtocol? ) {
		//		guard interactor != interactor_ else { return }
		//		lo( interactor_, interactor )
		interactor_?.deallocate()
		interactor_ = nil
		interactor_ = interactor
	}
	
	fileprivate func set ( presenter: FZPresenterProtocol? ) {
		//		guard presenter != presenter_ else { return }
		//		lo( presenter_, presenter )
		presenter_?.deallocate()
		presenter_ = nil
		presenter_ = presenter
	}
	
	fileprivate func set ( view: FZViewController? ) {
		guard view != view_ else { return }
		//		lo( view_, view )
		view_?.deallocate()
		//		view_ = nil
		view_ = view
		wornCloset.getSignals( by: keyring_.key )?.transmitSignalFor( key: FZSignalConsts.viewSet )
	}
}

open class FZRoutingService {
	public var wornCloset: FZWornCloset
//	public var window: UIWindow? {
//		get { return nil }
//		set {
//			guard window_ == nil else { return }
//			window_ = newValue
//			window_.makeKeyAndVisible()
//			lo( signalBox.signals )
//		}
//	}
	
	fileprivate let keyring_: FZKeyring
	
	fileprivate var
	is_activated: Bool,
	storyboards_: [ String: SwinjectStoryboard ],
	window_: UIWindow!,
	view_: FZViewController?,
	interactor_: FZInteractorProtocol?,
	presenter_: FZPresenterProtocol?

	required public init () {
		is_activated = false
		keyring_ = FZKeyring()
		wornCloset = FZWornCloset( keyring_.key )
		storyboards_ = [:]
	}
	
	deinit {}
}
