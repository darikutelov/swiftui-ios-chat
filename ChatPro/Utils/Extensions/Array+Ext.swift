//
//  Array+Ext.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 5.10.24.
//

import Foundation

extension Array {
    func isLastItem(_ item: Element) -> Bool where Element: Equatable {
        guard let lastItem = self.last else { return false }
        return item == lastItem
    }
}
