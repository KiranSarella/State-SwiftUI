//
//  SeatsView.swift
//  State-SwiftUI
//
//

import SwiftUI

struct SeatsView: View {
    
    @State var state = SeatsViewState()
    
    private let fixedColumn = [
        GridItem(.adaptive(minimum: 120))
    ]
    
    func canDisable(_ seat: Int) -> Bool {
        if state.selectedSeatNumber == nil {
            return false
        } else {
            if state.selectedSeatNumber == seat {
                return false
            }
        }
        
        return true
    }
    
    func imagecolor(_ seat: SeatVM) -> Color {
        if canDisable(seat.seatNumber) {
            return seat.color.opacity(0.3)
        } else {
            return seat.color
        }
    }
    
    var body: some View {
        
        VStack {
            ScrollView {
                LazyVGrid(columns: fixedColumn, spacing: 20) {
                    ForEach($state.seats) { $seat in
                        Button {
                            state.selectedSeat(seat: &seat)
                        } label: {
                            VStack {
                                Image(systemName: "chair.lounge")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .foregroundStyle(imagecolor(seat))
                                    .symbolEffect(.pulse, options: .speed(2).repeat(5), isActive: seat.triggerAnimation)
                                Text("\(seat.seatNumber)")
                                
                            }
                            .padding()
                            .onChange(of: seat.currentState) { oldValue, newValue in
                                print("SeatUI: \(seat.seatNumber)", newValue)
                            }
                        }
                        .disabled(canDisable(seat.seatNumber))
                        
                    }
                }
            }
            
            HStack {
                
                Button {
                    state.cancel()
                } label: {
                    Text("Cancel")
                        .padding(.horizontal)
                }
                .buttonStyle(.bordered)
                .tint(.red)
                .disabled(state.disableBookButton)
                
                Button {
                    state.book()
                } label: {
                    Text("Book")
                        .padding(.horizontal)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .disabled(state.disableBookButton)
                

            }
            
            Spacer()
        }
        
        
    }
}

#Preview {
    SeatsView()
}
