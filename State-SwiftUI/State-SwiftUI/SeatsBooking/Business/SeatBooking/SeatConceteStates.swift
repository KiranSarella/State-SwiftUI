//
//  States.swift
//  State-SwiftUI
//
//

import Foundation

enum SeatStatus: String {
    case available
    case selected
    case paymentProcessing
    case booked
}

protocol SeatState {
    
    init(context: Seat)
    // all events
    func select(in context: Seat) throws
    func cancel(in context: Seat) throws
    func book(in context: Seat) throws
    func confirmPayment(in context: Seat) throws
}

extension SeatState {
    
    func select(in context: Seat) throws {
        throw SeatError.selectonNotAllowed
    }
    
    func cancel(in context: Seat) throws {
        throw SeatError.cancelNotAllowed
    }
    
    func book(in context: Seat) throws {
        throw SeatError.bookingNowAllowed
    }
    
    func confirmPayment(in context: Seat) throws {
        throw SeatError.paymentNotAllowed
    }
    
}

enum SeatError: Error {
    case selectonNotAllowed
    case cancelNotAllowed
    case bookingNowAllowed
    case paymentNotAllowed
}

// create each state
struct AvailableState: SeatState {
    
    init(context: Seat) {
        context.currentState = .available
    }
    
    func select(in context: Seat) throws {
        let newState = SelectedState(context: context)
        context.setNextState(newState)
    }
   
}

struct SelectedState: SeatState {
    
    init(context: Seat) {
        context.currentState = .selected
    }
    
    func cancel(in context: Seat) {
        let newState = AvailableState(context: context)
        context.setNextState(newState)
    }
   
    func book(in context: Seat) {
        let newState = PaymentProcessingState(context: context)
        context.setNextState(newState)
    }
}


class PaymentProcessingState: SeatState {
    
    required init(context: Seat) {
        context.currentState = .paymentProcessing
        
        startPaymentProcessing(in: context)
    }
    
    func cancel(in context: Seat) {
        let newState = AvailableState(context: context)
        context.setNextState(newState)
    }
    
    func confirmPayment(in context: Seat) {
        let newState = BookedState(context: context)
        context.setNextState(newState)
    }
    
    func startPaymentProcessing(in seat: Seat) {
        Task {
            let paymentSuccess = await PaymentService().doPayment(seat.amount, seatNo: seat.seatNumber)
            if paymentSuccess {
                confirmPayment(in: seat)
            }
        }
        
    }
    
}

struct BookedState: SeatState {
    init(context: Seat) {
        context.currentState = .booked
    }
}
