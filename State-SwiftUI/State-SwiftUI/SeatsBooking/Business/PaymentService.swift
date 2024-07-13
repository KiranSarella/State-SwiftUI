//
//  PaymentService.swift
//  State-SwiftUI
//
//

import Foundation

class PaymentService {
    
    func doPayment(_ amount: Float, seatNo: Int) async -> Bool {
        print(#function, seatNo, amount)
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        return true
    }
}
