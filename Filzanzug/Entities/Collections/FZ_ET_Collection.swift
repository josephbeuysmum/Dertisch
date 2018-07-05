//
//  FZ_ET_CL_Custom.swift
//  Filzanzug
//
//  Created by Richard Willis on 11/03/2018.
//

extension FZBespokeEntities: FZBespokeEntitiesCollectionProtocol {
	public func deallocate() {
		model_classes?.removeAll()
		model_classes = nil
	}
	
	public func add(_ modelClass: FZModelClassProtocol) {
		let id = getModelClassId(by: String(describing: modelClass))
		guard model_classes?[id] == nil else { return }
		model_classes![id] = modelClass
	}
	
	public subscript(type: FZModelClassProtocol.Type) -> FZModelClassProtocol? {
		return model_classes?[getModelClassId(by: String(describing: type))]
	}
	

	
	fileprivate func getModelClassId(by className: String ) -> String {
		guard let dotIndex = FZString.getIndexOf(subString: FZCharConsts.dot, inString: className) else { return className }
		return FZString.getSubStringOf(string: className, between: dotIndex + 1, and: className.count)!
	}
}

public class FZBespokeEntities {
	fileprivate lazy var model_classes: Dictionary< String, FZModelClassProtocol >? = [:]
}
