//
//  SeatBookingBusiness.swift
//  State-SwiftUI
//
//

import Foundation


class SeatBookingBusiness {
    
    
    func getAvailableSeats() -> [Seat] {
        (1...9).map { Seat(seatNumber: $0) }
    }
    
    func selectedSeat(seat: inout Seat) throws {
        
        do {
            try seat.select()
        } catch {
            print(error)
            throw error
        }
    }
    
    func bookSeat(seat: inout Seat) {
        do {
            try seat.book()
        } catch {
            print(error)
        }
    }
    
    func cancelSeat(seat: inout Seat) {
        do {
            try seat.cancel()
        } catch {
            print(error)
        }
        
    }
    
}
