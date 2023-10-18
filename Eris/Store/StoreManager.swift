//
//  StoreManager.swift
//  Eris
//
//  Created by Dmitry Chicherin on 18/10/2566 BE.
//

import Foundation
import StoreKit

class StoreManager: ObservableObject {
    // 3:
    private var productIDs = ["stone"]
    // 4:
    @Published var products = [Product]()
    // 5:
    init() {
        /*Task {
            await requestProducts()
        }*/
        
    }
    // 6:
    @MainActor
    func requestProducts() async {
        do {
            // 7:
            products = try await Product.products(for: productIDs)
        } catch {
            // 8:
            print(error)
    }
  }
}
