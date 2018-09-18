//
//  DT_TableCell.swift
//  Dertisch
//
//  Created by Richard Willis on 27/07/2018.
//

import UIKit

public protocol DTTableViewCellProtocol: class, DTPopulatableCustomerProtocol {}

open class DTTableViewCell: UITableViewCell, DTTableViewCellProtocol {
	open func serve<T>(with data: T?) {}
}
