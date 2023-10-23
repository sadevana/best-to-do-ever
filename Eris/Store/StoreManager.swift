//
//  StoreManager.swift
//  Eris
//
//  Created by Dmitry Chicherin on 18/10/2566 BE.
//

import Foundation
import StoreKit

final class StoreManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    static let shared = StoreManager()
    var products = [SKProduct]()
    private var completion: ((CompanionModel)->Void)?
    public func fetchProducts() {
        let request = SKProductsRequest(
            productIdentifiers:  Set(Product.allCases.compactMap({$0.rawValue}))
        )
        request.delegate = self
        request.start()
    }
    public func purchase(product: Product, completion: @escaping ((CompanionModel)->Void)){
        guard SKPaymentQueue.canMakePayments() else {
            return
        }
        guard let storeKitProduct = products.first(where: {$0.productIdentifier == product.rawValue}) else {
            return
        }
        self.completion = completion
        let paymentRequest = SKPayment(product: storeKitProduct)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(paymentRequest)
    }
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        print("Products recieved \(response.products.first?.productIdentifier)")
    }
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach({
            switch $0.transactionState {
            case .purchasing:
                print("Purchasing")
                break
            case .purchased:
                if let product = Product(rawValue: $0.payment.productIdentifier){
                    completion?(product.model)
                }
                SKPaymentQueue.default().finishTransaction($0)
                break
            case .failed:
                break
            case .restored:
                break
            case .deferred:
                break
            @unknown default:
                break
            }
        })
    }
    enum Product: String, CaseIterable {
        case Aiko
        var model: CompanionModel {
            switch self{
            case .Aiko:
                return enumCompanions.Aiko.getModel()
            }
        }
    }
    var aikoPurchased: Bool {
        return UserDefaults.standard.bool(forKey: "Aiko")
    }
}
