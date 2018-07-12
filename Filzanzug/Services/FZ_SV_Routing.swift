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
	public var wornCloset: FZWornCloset? { return worn_closet }

	
	
	public func activate () {
//		guard let scopedSignals = worn_closet.getSignals( by: key_ring.key ) else { return }
		is_activated = true
//		_ = scopedSignals.scanFor( key: FZSignalConsts.interactorActivated, scanner: self ) {
//			[weak self] _, data in self.set( interactor: data as? FZInteractorProtocol )
//		}
//		_ = scopedSignals.scanFor( key: FZSignalConsts.presenterActivated, scanner: self ) {
//			[weak self] _, data in self.set( presenter: data as? FZPresenterProtocol )
//		}
//		_ = scopedSignals.scanFor( key: FZSignalConsts.viewLoaded, scanner: self ) {
//			[weak self] _, data in self.set( view: data as? FZViewController )
//		}
	}
	
	
	
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
		let modelClassId = String(describing: modelClassType)
		guard canRegister(with: key) else { return }
		let modelClass = modelClassType.init(with: FZKeyring())
		let entities = FZModelClassEntities()
		// todo a switch statement feels suboptimal, revisit later with more knowledge and time
		if dependencyTypes != nil {
			_ = dependencyTypes!.map {
				dependencyType in
				if let dependencyClass = model_class_singletons[ String( describing: dependencyType ) ] {
					switch true {
					case dependencyClass is FZBundledJsonService:	entities.set(bundledJson: dependencyClass as! FZBundledJsonService)
					case dependencyClass is FZCoreDataProxy:		entities.set(coreData: dependencyClass as! FZCoreDataProxy)
					case dependencyClass is FZUrlSessionService:	entities.set(urlSession: dependencyClass as! FZUrlSessionService)
					default:										entities.bespokeRail.add(dependencyClass)
					}
				} else {
					fatalError( "Attempting to inject a model class that has not been registered itself yet" )
				}
			}
		}
		modelClass.wornCloset?.set(signals: worn_closet.getSignals(by: key_ring.key)!)
		modelClass.wornCloset?.set(entities: entities)
		model_class_singletons[modelClassId] = modelClass
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
		( self as! FZRoutingServiceExtensionProtocol ).registerDependencies( with: key_ring.key )
		window_ = window
		window_.makeKeyAndVisible()
		add( rootViewController: rootViewController, from: storyboard )
	}
	

	

	
	fileprivate func canRegister ( with key: String ) -> Bool {
		return is_activated == false && key == key_ring.key
	}
	
	fileprivate func _create ( viewController id: String, from storyboardName: String? = nil ) -> FZViewController? {
		let name = storyboardName ?? "Main"
		guard
			let vipRelationship = vip_relationships[ id ],
			let viewController = UIStoryboard( name: name, bundle: nil ).instantiateViewController( withIdentifier: id ) as? FZViewController
			else { return nil }
		set(viewController)
		set(presenter: vipRelationship.presenterType.init(with: FZKeyring()))
		set(interactor: vipRelationship.interactorType.init(with: FZKeyring()), with: vipRelationship.interactorDependencyTypes)
		return viewController
	}
	
	fileprivate func _present (
		viewController id: String,
		on currentViewController: FZViewController,
		from storyboard: String? = nil ) {
		guard let viewController = _create( viewController: id, from: storyboard ) else { return }
		currentViewController.present(
			viewController,
			animated: true,
			completion: {
				currentViewController.removeFromParentViewController()
				self.worn_closet.getSignals( by: self.key_ring.key )?.transmit(signal: FZSignalConsts.viewRemoved )
		} )
	}
	
	fileprivate func set ( interactor: FZInteractorProtocol, with dependencyTypes: [ FZModelClassProtocol.Type ]? ) {
		interactor_?.deallocate()
		interactor_ = interactor
		let entities = FZInteractorEntities( presenter: presenter_! )
		if dependencyTypes != nil {
			_ = dependencyTypes!.map {
				dependencyType in
				if let dependencyClass = model_class_singletons[ String( describing: dependencyType ) ] {
					if dependencyClass is FZImageProxy {
						entities.set( image: dependencyClass as! FZImageProxy )
					} else {
						entities.bespokeRail.add(dependencyClass)
					}
				} else {
					fatalError( "Attempting to inject a model class that has not been registered itself yet" )
				}
			}
		}
		interactor_!.wornCloset?.set( entities: entities )
		interactor_!.wornCloset?.set( signals: worn_closet.getSignals( by: key_ring.key )! )
		interactor_!.activate()
	}
	
	fileprivate func set ( presenter: FZPresenterProtocol ) {
		presenter_?.deallocate()
		presenter_ = presenter
		presenter_!.wornCloset?.set( signals: worn_closet.getSignals( by: key_ring.key )! )
		presenter_!.wornCloset?.set( entities: FZPresenterEntities( routing: self, viewController: view_controller ) )
		presenter_!.activate()
	}
	
	fileprivate func set ( _ viewController: FZViewController ) {
		guard viewController != view_controller else { return }
		view_controller?.deallocate()
		view_controller = viewController
		view_controller!.signalBox.signals = worn_closet.getSignals( by: key_ring.key )!
//		worn_closet.getSignals( by: key_ring.key )?.transmitSignalFor( key: FZSignalConsts.viewSet )
	}
}

public class FZRoutingService {
	fileprivate let key_ring: FZKeyring

	fileprivate var
	is_activated: Bool,
	model_class_singletons: Dictionary< String, FZModelClassProtocol >,
	vip_relationships: Dictionary< String, FZVipRelationship >,
	worn_closet: FZWornCloset,
	window_: UIWindow!,
	view_controller: FZViewController?,
	interactor_: FZInteractorProtocol?,
	presenter_: FZPresenterProtocol?

	required public init(with keyring: FZKeyring) {
		is_activated = false
		key_ring = keyring
		worn_closet = FZWornCloset(key_ring.key)
		worn_closet.set( signals: FZSignalsService() )
		model_class_singletons = [:]
		vip_relationships = [:]
	}
	
	deinit {}
}
