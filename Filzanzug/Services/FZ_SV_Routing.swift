//
//  FZ_SV_Routing.swift
//  Filzanzug
//
//  Created by Richard Willis on 12/11/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

import UIKit

public enum Presentations {
	case curl, dissolve, flip, rise, show
}

extension FZRoutingService: FZRoutingServiceProtocol {
//	public var closet: FZModelClassCloset { return closet_ }

	public var hasPopover: Bool {
		return popover_bundle != nil
	}
	
	public func activate() {}
	
	public func add(rootViewController id: String, from storyboard: String? = nil) {
		guard let viperBundle = create_bundle(viewController: id, from: storyboard) else { return }
		window_.rootViewController = viperBundle.viewController
		view_bundle = viperBundle
	}
	
	public func alert(actions: [UIAlertAction], title: String? = nil, message: String? = nil, style: UIAlertControllerStyle? = .alert) {
		guard let viewController = view_bundle?.viewController else { return }
		let
		alert = UIAlertController(title: title, message: message, preferredStyle: style!),
		countActions = actions.count
		for i in 0..<countActions {
			alert.addAction(actions[i])
		}
		viewController.present(alert, animated: true)
	}
	
	public func createNibFrom(name nibName: String, for owner: FZViewController) -> UIView? {
		guard let viewArray = Bundle.main.loadNibNamed(nibName, owner: owner, options: nil) else { return nil }
		return viewArray[0] as? UIView
	}
	
	public func create(_ viewControllerId: String, from storyboard: String? = nil) -> FZViewController? {
		return create_bundle(viewController: viewControllerId, from: storyboard)?.viewController
	}
	
//	public func createAlertWith(
//		title: String,
//		message: String,
//		buttonLabel: String,
//		handler: @escaping((UIAlertAction) -> Void),
//		plusExtraButtonLabel extraButtonLabel: String? = nil) -> UIAlertController {
//		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
//		// copy
//		alert.addAction(UIAlertAction(title: buttonLabel, style: UIAlertActionStyle.default, handler: handler))
//		if extraButtonLabel != nil {
//			alert.addAction(UIAlertAction(title: extraButtonLabel!, style: UIAlertActionStyle.default, handler: nil))
//		}
//		return alert
//	}
	
	public func dismissPopover() {
		guard hasPopover else { return }
		popover_bundle!.viewController?.dismiss(animated: true) {
			self.popover_bundle!.deallocate()
			self.popover_bundle = nil
			self.signals_.transmit(signal: FZSignalConsts.popoverRemoved)
		}
	}
	
	public func popover(
		_ viewControllerId: String,
		inside rect: CGRect? = nil,
		from storyboard: String? = nil) {
		guard
			!hasPopover,
			let currentViewController = view_bundle?.viewController,
			let viperBundle = create_bundle(viewController: viewControllerId, from: storyboard),
			let popover = viperBundle.viewController
			else { return }
		popover.modalPresentationStyle = .popover
		currentViewController.present(popover, animated: true) {
			self.signals_.transmit(signal: FZSignalConsts.popoverAdded)
		}
		popover.popoverPresentationController?.sourceView = currentViewController.view
		if let safeRect = rect {
			popover.popoverPresentationController?.sourceRect = safeRect
		}
		popover_bundle = viperBundle
	}
	
	public func present(
		_ viewControllerId: String,
		animated: Bool? = true,
		via presentation: Presentations? = nil,
		from storyboard: String? = nil) {
		let presentationType = presentation ?? Presentations.show
		guard
			let currentViewController = view_bundle?.viewController,
			let viperBundle = create_bundle(viewController: viewControllerId, from: storyboard),
			let viewController = viperBundle.viewController
			else { return }
		switch presentationType {
		case .curl:			viewController.modalTransitionStyle = .partialCurl
		case .dissolve:		viewController.modalTransitionStyle = .crossDissolve
		case .flip:			viewController.modalTransitionStyle = .flipHorizontal
		case .rise:			viewController.modalTransitionStyle = .coverVertical
		default:			()
		}
		currentViewController.present(viewController, animated: animated!) {
			currentViewController.removeFromParentViewController()
			self.signals_.transmit(signal: FZSignalConsts.viewRemoved)
		}
		view_bundle?.deallocate()
		view_bundle = viperBundle
	}
	
	public func register(
		_ modelClassType: FZModelClassProtocol.Type,
		with key: String,
		injecting dependencyTypes: [FZModelClassProtocol.Type]? = nil) {
		guard can_register(with: key) else { return }
		var modelClasses: [FZModelClassProtocol]?
		if let strongDependencyTypes = dependencyTypes {
			modelClasses = []
			for dependencyType in strongDependencyTypes {
				if let dependencyClass = model_class_singletons[String(describing: dependencyType)] {
					modelClasses!.append(dependencyClass)
				} else {
					fatalError("Attempting to inject a model class that has not been registered itself yet")
				}
			}
		}
		let modelClass = modelClassType.init(signals: signals_, modelClasses: modelClasses)
		model_class_singletons[String(describing: modelClassType)] = modelClass
		modelClass.activate()
	}
	
	// todo some presenters and view controllers do not need an interactor (intro page in Cirk for example) and this registation should handle that case too
	public func register(
		_ viewControllerId: String,
		as viewControllerType: FZViewControllerProtocol.Type,
		with interactorType: FZInteractorProtocol.Type,
		and presenterType: FZPresenterProtocol.Type,
		lockedBy key: String,
		andInjecting interactorDependencyTypes: [FZModelClassProtocol.Type]? = nil) {
		guard
			vip_relationships[viewControllerId] == nil,
			can_register(with: key)
			else { return }
		vip_relationships[viewControllerId] = FZVipRelationship(
			viewControllerType: viewControllerType,
			interactorType: interactorType,
			presenterType: presenterType,
			interactorDependencyTypes: interactorDependencyTypes)
	}
	
	public func start(rootViewController: String, window: UIWindow, storyboard: String? = nil) {
		guard
			window_ == nil,
			self is FZRoutingServiceExtensionProtocol
			else { return }
		(self as! FZRoutingServiceExtensionProtocol).registerDependencies(with: key_)
		window_ = window
		window_.makeKeyAndVisible()
		add(rootViewController: rootViewController, from: storyboard)
	}
	
	
	
	fileprivate func can_register(with key: String) -> Bool {
		return is_activated == false && key == key_
	}
	
	fileprivate func create_bundle(viewController id: String, from storyboard: String? = nil) -> FZViperBundle? {
		guard
			let vipRelationship = vip_relationships[id],
			let viewController = UIStoryboard(name: get_(storyboard), bundle: nil).instantiateViewController(withIdentifier: id) as? FZViewController
			else { return nil }
		let presenter = vipRelationship.presenterType.init(signals: signals_, routing: self)
		viewController.set(signals_, and: presenter)
		let interactor = vipRelationship.interactorType.init(
			signals: signals_,
			presenter: presenter,
			dependencies: get_interactor_dependencies(from: vipRelationship.interactorDependencyTypes))
		presenter.activate()
		interactor.activate()
		return FZViperBundle(viewController: viewController, interactor: interactor, presenter: presenter)
	}
	
	fileprivate func get_(_ storyboard: String?) -> String {
		return storyboard ?? "Main"
	}
	
	fileprivate func get_interactor_dependencies(
//		interactor: inout FZInteractorProtocol,
//		with presenter: FZPresenterProtocol,
		from dependencyTypes: [FZModelClassProtocol.Type]?) -> [FZModelClassProtocol]? {
		guard let dependencyTypes = dependencyTypes else { return nil }
		var dependencies: [FZModelClassProtocol] = []
		_ = dependencyTypes.map {
			dependencyType in
			if let dependencyClass = model_class_singletons[String(describing: dependencyType)] {
				dependencies.append(dependencyClass)
//				if dependencyClass is FZImageProxy {
//					interactor.closet?.set(imageProxy: dependencyClass as! FZImageProxy)
//				} else {
//					interactor.closet?.bespoke.add(dependencyClass)
//				}
			} else {
				fatalError("Attempting to inject a model class that has not been registered itself yet")
			}
		}
//		interactor.closet?.set(signalsService: signals)
//		interactor.closet?.set(presenter: presenter)
//		interactor.activate()
		return dependencies.count > 0 ? dependencies : nil
	}
	
	// todo do these IA PR and VC need to be passed via set or can they be created here (so that we don't need setter functions on the entity collections)
//	fileprivate func initialise_(presenter: inout FZPresenterProtocol, with viewController: FZViewController) -> Bool {
//		guard let signals = closet_.signals(key_) else { return false }
//		presenter.closet?.set(signalsService: signals)
//		presenter.closet?.set(routing: self)
//		presenter.closet?.set(viewController: viewController)
//		presenter.activate()
//		return true
//	}
	
//	fileprivate func initialise_(viewController: inout FZViewController) -> Bool {
//		guard let signals = closet_.signals(key_) else { return false }
//		viewController.set(signalsService: signals)
//		return true
//	}
}

public class FZRoutingService {
	fileprivate let
	signals_: FZSignalsService,
	key_: String
	
	fileprivate var
	is_activated: Bool,
	model_class_singletons: Dictionary<String, FZModelClassProtocol>,
	vip_relationships: Dictionary<String, FZVipRelationship>,
//	key_: FZKey!,
//	closet_: FZModelClassCloset!,
	window_: UIWindow!,
	view_bundle: FZViperBundle?,
	popover_bundle: FZViperBundle?

	required public init() {
		signals_ = FZSignalsService()
		key_ = NSUUID().uuidString // FZKey(self)
		is_activated = false
		model_class_singletons = [:]
		vip_relationships = [:]
//		closet_ = FZModelClassCloset(self, key: key_)
//		closet_.set(signals: FZSignalsService())
	}
}
