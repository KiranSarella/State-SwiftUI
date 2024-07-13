//
//  SeatsState.swift
//  State-SwiftUI
//
//

import SwiftUI


struct SeatVM: Identifiable {
    var id: UUID
    var seatNumber: Int
    var currentState: SeatStatus = .available {
        didSet {
            print("SeatVM: \(currentState)")
            updateColor()
            updateAnimationState()
        }
    }
    
    var color: Color = .black
    
    init(seat: Seat) {
        id = seat.id
        seatNumber = seat.seatNumber
        currentState = seat.currentState
    }
    
    mutating func update(seat: Seat) {
        currentState = seat.currentState
    }
    
    var seatModel: Seat {
        Seat(seatVM: self)
    }
    
    mutating func updateColor() {
        print(#function)
        color = switch currentState {
        case .available:
            Color.black
        case .selected:
            Color.blue
        case .paymentProcessing:
            Color.yellow
        case .booked:
            Color.green
        }
    }
    
    var triggerAnimation = false
    
    mutating func updateAnimationState() {
        if currentState == .paymentProcessing {
            triggerAnimation = true
        } else {
            triggerAnimation = false
        }
    }
}

extension Seat {
    convenience init(seatVM: SeatVM) {
        self.init(seatNumber: seatVM.seatNumber)
        id = seatVM.id
        updateCurrentState(currentState: seatVM.currentState)
    }
}

@Observable
class SeatsViewState {
    
    private let business = SeatBookingBusiness()
    
    var seats = [SeatVM]()
    
    var selectedSeatNumber: Int?
    var bookingInProgress: Bool = false
    
    var disableBookButton: Bool {
        selectedSeatNumber == nil || bookingInProgress == true
    }
    
    var disableCancelButton: Bool {
        selectedSeatNumber == nil || bookingInProgress == true
    }
    
    init() {
        seats = business.getAvailableSeats().map { SeatVM(seat: $0) }
    }
    
    func selectedSeat(seat: inout SeatVM) {
        do {
            var seatModel = seat.seatModel
            try business.selectedSeat(seat: &seatModel)
            seat.update(seat: seatModel)
            selectedSeatNumber = seat.seatNumber
        } catch {
            
        }
    }
    
    func bookSeat(seat: inout SeatVM) {
        
        var seatModel = seat.seatModel
        //
        seatModel.onStatusChange = {
            DispatchQueue.main.async {
                if let index = self.seats.firstIndex(where: { $0.id == seatModel.id }) {
                    self.seats[index].currentState = seatModel.currentState
                    if seatModel.currentState != .paymentProcessing  {
                        self.clearSelectionItemState()
                    }
                }
            }
        }
        
        business.bookSeat(seat: &seatModel)
        seat.update(seat: seatModel)
    }
    
    func cancelSeat(seat: inout SeatVM) {
        var seatModel = seat.seatModel
        business.cancelSeat(seat: &seatModel)
        seat.update(seat: seatModel)
    }
    
    func book() {
        bookingInProgress = true
        for i in 0..<seats.count {
            if seats[i].currentState == .selected {
                bookSeat(seat: &seats[i])
            }
        }
    }
    
    func cancel() {
        clearSelectionItemState()
        
        for i in 0..<seats.count {
            if seats[i].currentState == .selected || seats[i].currentState == .paymentProcessing {
                cancelSeat(seat: &seats[i])
            }
        }
    }
    
    func clearSelectionItemState() {
        print(#function)
        selectedSeatNumber = nil
        bookingInProgress = false
    }
}

