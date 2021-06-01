//
//  String+Utils.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 31/05/2021.
//

import Foundation

// MARK: Optional init

extension String {
    /// Creates an instance from the description of a given `LosslessStringConvertible?` optional.
    init?<T>(_ value: T?) where T: LosslessStringConvertible {
        guard let value = value else { return nil }
        self.init(value)
    }
}
