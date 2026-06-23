//
//  ProductViewModel.swift
//  SwiftBooster
//
//  Created by BADR  QABA on 2026-06-14.
//

import Foundation

@MainActor
public class ProductViewModel: ObservableObject {
    
    private let useCases: ProductRepositoryUseCases
    
    @Published
    public var state: MainState = MainState()
    
    init(useCases: ProductRepositoryUseCases) {
        self.useCases = useCases
    }
    
    private func getProducts() async {
        do {
            let _ = try await useCases.getProductsIds(page: 1)
        } catch {
            
        }
        
    }
    
    private func login() {
        if state.isValidForm {
            
        }
    }
}
