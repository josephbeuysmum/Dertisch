//
//  DT_EX_UIControl.swift
//  Dertisch
//
//  Created by Richard Willis on 26/05/2018.
//

// taken from aepryus at: https://stackoverflow.com/questions/25919472/adding-a-closure-as-target-to-a-uibutton
//fileprivate class ClosureSleeve {
//	let closure: ()->()
//	
//	init (_ closure: @escaping ()->()) {
//		self.closure = closure
//	}
//	
//	@objc func invoke () {
//		closure()
//	}
//}

//extension UIControl {
//	public func addAction(for controlEvents: UIControlEvents, _ closure: @escaping ()->()) {
//		let sleeve = ClosureSleeve(closure)
//		addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
//		objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
//	}
//}
