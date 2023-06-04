//
//  GamingView.swift
//  CYOATemplate
//
//  Created by Judy YU on 2023-06-03.
//

import Blackbird
import SwiftUI

struct GamingView: View {
    // MARK: Stored properties
    
    // What node are we on?
    @State var currentNodeId: Int = 174
    
    // Needed to query database
    //@Environment(\.blackbirdDatabase) var db: Blackbird.Database?
    
    @State private var showPopUp: Bool = false
    
    // Values
    @State var energy: Int = 8
    
    @State var mentality: Int = 8
    
    @State var food: Int = 4
    
    @State private var isEnding: Bool = false
    
    // MARK: Computed properties
    var mentalityState: String {
        if mentality <= 2 {
            return "Insane"
        } else if mentality <= 5 {
            return "Worried"
        } else if mentality <= 9 {
            return "Healthy"
        } else {
            return "Good"
        }
    }
    
    var body: some View {
        
        ZStack {
            
            // Background
            Color.black
                .ignoresSafeArea(.all)
            
            VStack(alignment: .leading) {
                
                InformationView(currentNodeId: currentNodeId, energy: $energy, mentality: $mentality, food: $food)
                
                ChoicesView(currentNodeId: $currentNodeId, energy: $energy, mentality: $mentality, food: $food, isEnding: $isEnding)
                
                if isEnding == false {
                    // Display changes in values
                    Text("Energy - 1, Food + 3")
                        .padding(.horizontal)
                    
                    // Divider
                    Divider()
                        .frame(height: 1.5)
                        .overlay(.white)
                    
                    // Display values
                    HStack(alignment: .top, spacing: 15) {
                        
                        Text("ME")
                            .font(.title3)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            
                            HStack {
                                // Energy
                                Text("Energy")
                                
                                // Completion meter
                                CompletionMeterView(energy: CGFloat(energy))
                            }
                            
                            // Mentality & Food
                            HStack {
                                
                                Text("Mentality: \(mentalityState)")
                                    .padding(.trailing, 20)
                                
                                Spacer()
                                
                                Image("Bread")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                
                                Text(": \(food)")
                                
                            }
                            .padding(.trailing, 50)
                        }
                        
                        // Settings
                        Button(action: {
                            withAnimation(.linear(duration: 0.3)) {
                                showPopUp.toggle()
                            }
                        }, label: {
                            Image(systemName: "gear")
                                .scaleEffect(2)
                                .foregroundColor(.white)
                        })
                        .padding([.leading, .top], 10)
                        
                }
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                
                }
                
            }
            .padding(.bottom, 10)
            .edgesIgnoringSafeArea(.horizontal)
            .edgesIgnoringSafeArea(.bottom)
            
            SettingsView(show: $showPopUp, currentNodeId: $currentNodeId, energy: $energy, mentality: $mentality, food: $food)
        }
        .foregroundColor(.white)
        
    }
    
}

// Preview provider
struct GamingView_Previews: PreviewProvider {
    static var previews: some View {
        GamingView()
        // Make the database available to all other view through the environment
            .environment(\.blackbirdDatabase, AppDatabase.instance)
    }
}

