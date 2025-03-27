//
//  LegacyTableViewCellModel.swift
//  UIKitComponents
//
//  Created by Alex Kuznetcov on 3/28/25.
//

import UIKit

public protocol LegacyTableViewCellModelProtocol {
    
    associatedtype Model
    func configure(with model: Model)
    
    static var identifier: String { get }
}

open class LegacyTableViewCellModel {
    
    public var id: String?
    public var identifier: String = ""
    public var cellClass: AnyClass?
    
    public init(
        identifier: String,
        cellClass: AnyClass?
    ) {
        self.identifier = identifier
        self.cellClass = cellClass
    }
}

extension LegacyTableViewCellModel: Equatable {
    
    public static func == (
        lhs: LegacyTableViewCellModel,
        rhs: LegacyTableViewCellModel
    ) -> Bool {
        lhs.id == rhs.id &&
        lhs.identifier == rhs.identifier
    }
}

public extension LegacyTableViewCellModelProtocol {
    
    static var identifier: String {
        String(describing: Self.self)
    }
}
