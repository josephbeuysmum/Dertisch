//
//  FZ_SV_Routing.swift
//  Filzanzug
//
//  Created by Richard Willis on 12/11/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

//import SwinjectStoryboard
import UIKit

extension FZRoutingService: FZRoutingServiceProtocol {
	public var closet: FZModelClassEntities { return closet_ }

	
	
	public func activate () {}
	
	public func add ( rootViewController id: String, from storyboard: String? = nil ) {
		guard let viewController = _create( viewController: id, from: storyboard ) else { return }
		window_.rootViewController = viewController
	}
	
	public func createNibFrom ( name nibName: String, for owner: FZViewController ) -> UIView? {
		guard let viewArray = Bundle.main.loadNibNamed( nibName, owner: owner, options: nil ) else { return nil }
		return viewArray[ 0 ] as? UIView
	}
	
	public func create ( viewController id: String, from storyboard: String? = nil ) -> FZViewController? {
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
	
	public func register (
		_ modelClassType: FZModelClassProtocol.Type,
		with key: String,
		injecting dependencyTypes: [FZModelClassProtocol.Type]? = nil) {
		guard
			canRegister(with: key),
			let signals = closet_.signals(key_.hash)
			else { return }
		let modelClass = modelClassType.init()
		// todo a switch statement feels suboptimal, revisit later with more knowledge and time
		if dependencyTypes != nil {
			_ = dependencyTypes!.map { dependencyType in
				if let dependencyClass = model_class_singletons[String(describing: dependencyType)] {
					switch true {
					case dependencyClass is FZBundledJsonService:
						modelClass.closet.set(bundledJson: dependencyClass as! FZBundledJsonService)
					case dependencyClass is FZCoreDataProxy:
						modelClass.closet.set(coreData: dependencyClass as! FZCoreDataProxy)
					case dependencyClass is FZUrlSessionService:
						modelClass.closet.set(urlSession: dependencyClass as! FZUrlSessionService)
					default:
						modelClass.closet.bespoke.add(dependencyClass)
					}
				} else {
					fatalError( "Attempting to inject a model class that has not been registered itself yet" )
				}
			}
		}
		modelClass.closet.set(signalsService: signals)
		model_class_singletons[String(describing: modelClassType)] = modelClass
		modelClass.activate()
	}
	
	// todo some presenters and view controllers do not need an interactor (intro page in Cirk for example) and this registation should handle that case too
	public func register (
		_ viewControllerId: String,
		as viewControllerType: FZViewControllerProtocol.Type,
		with interactorType: FZInteractorProtocol.Type,
		and presenterType: FZPresenterProtocol.Type,
		lockedBy key: String,
		andInjecting interactorDependencyTypes: [ FZModelClassProtocol.Type ]? = nil ) {
		guard
			vip_relationships[ viewControllerId ] == nil,
			canRegister( with: key )
			else { return }
		vip_relationships[ viewControllerId ] = FZVipRelationship(
			viewControllerType: viewControllerType,
			interactorType: interactorType,
			presenterType: presenterType,
			interactorDependencyTypes: interactorDependencyTypes )
	}
	
	public func start ( rootViewController: String, window: UIWindow, storyboard: String? = nil ) {
		guard
			window_ == nil,
			self is FZRoutingServiceExtensionProtocol
			else { return }
		( self as! FZRoutingServiceExtensionProtocol ).registerDependencies( with: key_.hash )
		window_ = window
		window_.makeKeyAndVisible()
		add( rootViewController: rootViewController, from: storyboard )
	}
	

	

	
	fileprivate func canRegister ( with key: String ) -> Bool {
		return is_activated == false && key == key_.hash
	}
	
	fileprivate func _create ( viewController id: String, from storyboardName: String? = nil ) -> FZViewController? {
		let name = storyboardName ?? "Main"
		guard
			let vipRelationship = vip_relationships[ id ],
			let viewController = UIStoryboard( name: name, bundle: nil ).instantiateViewController( withIdentifier: id ) as? FZViewController
			else { return nil }
		set(viewController)
		set(presenter: vipRelationship.presenterType.init())
		set(interactor: vipRelationship.interactorType.init(), with: vipRelationship.interactorDependencyTypes)
		return viewController
	}
	
	fileprivate func _present (
		viewController id: String,
		on currentViewController: FZViewController,
		from storyboard: String? = nil ) {
		guard let viewController = _create(viewController: id, from: storyboard) else { return }
		currentViewController.present(
			viewController,
			animated: true,
			completion: {
				currentViewController.removeFromParentViewController()
				self.closet_.signals(self.key_.hash)?.transmit(signal: FZSignalConsts.viewRemoved)
		} )
	}
	
	fileprivate func set(interactor: FZInteractorProtocol, with dependencyTypes: [FZModelClassProtocol.Type]?) {
		interactor_?.deallocate()
		guard let signals = closet_.signals(key_.hash) else { return }
		interactor_ = interactor
		if dependencyTypes != nil {
			_ = dependencyTypes!.map {
				dependencyType in
				if let dependencyClass = model_class_singletons[String(describing: dependencyType)] {
					if dependencyClass is FZImageProxy {
						interactor.closet?.set(imageProxy: dependencyClass as! FZImageProxy)
					} else {
						interactor.closet?.bespoke.add(dependencyClass)
					}
				} else {
					fatalError( "Attempting to inject a model class that has not been registered itself yet" )
				}
			}
		}
		interactor_!.closet?.set(signalsService: signals)
		interactor_!.activate()
	}
	
	// todo do these IA PR and VC need to be passed via set or can they be created here (so that we don't need setter functions on the entity collections)
	fileprivate func set(presenter: FZPresenterProtocol) {
		presenter_?.deallocate()
		guard
			let signals = closet_.signals(key_.hash),
			let viewController = view_controller
			else { return }
		presenter_ = presenter
		presenter_!.closet?.set(signalsService: signals)
		presenter_!.closet?.set(routing: self)
		presenter_!.closet?.set(viewController: viewController)
		presenter_!.activate()
	}
	
	fileprivate func set(_ viewController: FZViewController) {
		guard
			let signals = closet_.signals(key_.hash),
			let viewController = view_controller
			else { return }
		view_controller?.deallocate()
		view_controller = viewController
		view_controller!.set(signalsService: signals)
	}
}

public class FZRoutingService {
	fileprivate var
	is_activated: Bool,
	model_class_singletons: Dictionary< String, FZModelClassProtocol >,
	vip_relationships: Dictionary< String, FZVipRelationship >,
	key_: FZKeyring!,
	closet_: FZModelClassEntities!,
	window_: UIWindow!,
	view_controller: FZViewController?,
	interactor_: FZInteractorProtocol?,
	presenter_: FZPresenterProtocol?

	required public init() {
		is_activated = false
		model_class_singletons = [:]
		vip_relationships = [:]
		key_ = FZKeyring(delegate: self)
		closet_ = FZModelClassEntities(delegate: self, key: key_.hash)
		closet_.set(signalsService: FZSignalsService())
	}
	
	deinit {}
}
