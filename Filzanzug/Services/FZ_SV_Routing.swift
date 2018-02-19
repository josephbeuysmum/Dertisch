//
//  FZ_PX_View.swift
//  Hasenblut
//
//  Created by Richard Willis on 12/11/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

import SwinjectStoryboard
import UIKit

public class FZRoutingService: FZRoutingServiceProtocol {
	public var signalBox: FZSignalsEntity!
	public var entities: FZModelClassEntities!
	public var className: String { return FZClassConsts.routing }
	public var window: UIWindow? {
		get { return nil }
		set {
			guard _window == nil else { return }
			_window = newValue
			_window.makeKeyAndVisible()
			start()
		}
	}
	
	fileprivate var
	key: String,
	_isActivated: Bool,
	storyboards: [ String: SwinjectStoryboard ],
	_window: UIWindow!,
	_view: FZViewController?,
	_interactor: FZInteractorProtocol?,
	_presenter: FZPresenterProtocol?

	
	
	required public init () {
		_isActivated = false
		key = NSUUID().uuidString
		signalBox = FZSignalsEntity( key )
		entities = FZModelClassEntities( key )
		storyboards = [:]
	}
	
	deinit {}
	
	public func activate () {
		_isActivated = true
		guard let scopedSignals = signalBox.getSignalsServiceBy( key: key ) else { return }
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
	
	
	
	public func add ( rootViewController id: String ) {
		_add( rootViewController: id )
	}
	
	public func add ( rootViewController id: String, from storyboard: String ) {
		_add( rootViewController: id, from: storyboard )
	}
	
	public func createNibFrom ( name nibName: String, for owner: FZViewController ) -> UIView? {
		guard let viewArray = Bundle.main.loadNibNamed( nibName, owner: owner, options: nil ) else { return nil }
		return viewArray[ 0 ] as? UIView
	}
	
	public func create ( viewController id: String ) -> UIViewController? {
		return _create( viewController: id )
	}
	
	public func create ( viewController id: String, from storyboard: String ) -> UIViewController? {
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
		_window.rootViewController = viewController
	}
	
	fileprivate func _create ( viewController id: String, from storyboardName: String? = nil ) -> UIViewController? {
		let name = storyboardName ?? "Main"
		if storyboards[ name ] == nil { storyboards[ name ] = SwinjectStoryboard.create( name: name, bundle: nil ) }
		return storyboards[ name ]!.instantiateViewController( withIdentifier: id )
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
				self.signalBox.getSignalsServiceBy( key: self.key )?.transmitSignalFor( key: FZSignalConsts.viewRemoved )
		} )
	}
	
	fileprivate func set ( interactor: FZInteractorProtocol? ) {
//		guard interactor != _interactor else { return }
//		lo( _interactor, interactor )
		_interactor?.deallocate()
		_interactor = nil
		_interactor = interactor
	}
	
	fileprivate func set ( presenter: FZPresenterProtocol? ) {
//		guard presenter != _presenter else { return }
//		lo( _presenter, presenter )
		_presenter?.deallocate()
		_presenter = nil
		_presenter = presenter
	}

	fileprivate func set ( view: FZViewController? ) {
		guard view != _view else { return }
//		lo( _view, view )
		_view?.deallocate()
//		_view = nil
		_view = view
		signalBox.getSignalsServiceBy( key: key )?.transmitSignalFor( key: FZSignalConsts.viewSet )
	}
}
