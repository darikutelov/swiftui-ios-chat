//
//  UIApplication+Ext.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 5.10.24.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
