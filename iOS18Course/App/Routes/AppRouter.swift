//
//  AppRouter.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 26/2/2025.
//

import SwiftUI

@Observable
class AppRouter {
    var path: NavigationPath = NavigationPath()
    
    func push(_ route: any Hashable) {
        path.append(route)
    }
    
    func replace(for route: any Hashable) {
        if path.isEmpty {
            push(route)
        } else {
            pop()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.push(route)
            }
        }
    }
    
    func pop() {
        if path.isEmpty == false {
            path.removeLast()
        }
    }
    
    func pop(for amount: Int) {
        if path.isEmpty == false && amount <= path.count {
            path.removeLast(amount)
        }
    }
    
    func popAll() {
        path.removeLast(path.count)
    }
}
