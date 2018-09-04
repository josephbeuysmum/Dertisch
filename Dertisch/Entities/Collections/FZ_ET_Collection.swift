//
//  DT_ET_CL_Custom.swift
//  Dertisch
//
//  Created by Richard Willis on 11/03/2018.
//

//extension DTBespokeEntities: DTBespokeEntitiesProtocol {
//	public func cleanUp() {
//		model_classes?.removeAll()
//		model_classes = nil
//	}
//	
//	public func add(_ modelClass: DTKitchenProtocol) {
//		let id = getModelClassId(by: String(describing: modelClass))
//		guard model_classes?[id] == nil else { return }
//		model_classes![id] = modelClass
//	}
//	
//	public subscript(type: DTKitchenProtocol.Type) -> DTKitchenProtocol? {
//		return model_classes?[getModelClassId(by: String(describing: type))]
//	}
//	
//	
//	
//	fileprivate func getModelClassId(by className: String) -> String {
//		guard let dotIndex = DTString.getIndexOf(subString: DTCharConsts.dot, inString: className) else { return className }
//		return DTString.getSubStringOf(string: className, between: dotIndex + 1, and: className.count)!
//	}
//}
//
//public class DTBespokeEntities {
//	fileprivate lazy var model_classes: Dictionary<String, DTKitchenProtocol>? = [:]
//}
