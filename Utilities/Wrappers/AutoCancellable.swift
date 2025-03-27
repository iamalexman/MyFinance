//
//  AutoCancellable.swift
//  Utilities
//
//  Created by Alex Kuznetcov on 3/28/25.
//

@propertyWrapper
public struct AutoCancellable {
    
    public var wrappedValue: Cancellable? {
        didSet {
            if let oldValue, oldValue.isCancelled {
                return
            }
            oldValue?.cancel()
        }
    }
    
    public init() { }
    
    public init(wrappedValue: Cancellable?) {
        self.wrappedValue = wrappedValue
    }
}

public protocol Cancellable {
    
    var isCancelled: Bool { get }
    
    func cancel()
}
