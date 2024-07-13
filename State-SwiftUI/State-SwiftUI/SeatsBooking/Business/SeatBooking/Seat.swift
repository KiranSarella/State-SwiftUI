//
//  SeatBooking.swift
//  State-SwiftUI
//
//

import Foundation

class Seat: Identifiable {
    var id = UUID()
    var seatNumber: Int
    var amount: Float = 250
    var currentState: SeatStatus = .available {
        didSet {
            onStatusChange?()
        }
    }
    
    private(set) var state: SeatState!
    
    var onStatusChange: (() -> ())?
    
    init(seatNumber: Int) {
        self.seatNumber = seatNumber
        // Initial state
        self.state = AvailableState(context: self)
    }
    
    func updateCurrentState(currentState: SeatStatus) {
        self.currentState = currentState
        state = switch currentState {
        case .available:
            AvailableState(context: self)
        case .selected:
            SelectedState(context: self)
        case .paymentProcessing:
            PaymentProcessingState(context: self)
        case .booked:
            BookedState(context: self)
        }
    }
    
    func setNextState(_ state: SeatState) {
        self.state = state
    }
    
    func select() throws {
        try state.select(in: self)
    }
    
    func cancel() throws {
        try state.cancel(in: self)
    }
    
    func book() throws {
        try state.book(in: self)
    }

    
}


