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
    @Binding var viewStatus: String
    
    // What node are we on?
    @State var currentNodeId: Int = 1
    
    // Needed to query database
    @Environment(\.blackbirdDatabase) var db: Blackbird.Database?
    
    @State private var showPopUp: Bool = false
    
    @State private var opacity: CGFloat = 0
    
    // Show value panel or not?
    @State private var isEnding: Bool = false
    
    @State private var valuePanelOpacity: CGFloat = 1
    
    @State var speed: CGFloat = 0.025
    
    @State var textAllShown: Bool = false
    
    // Values
    @State var energy: Int = 8
    
    @State var mentality: Int = 8
    
    @State var food: Int = 4
    
    @State var energyChange: Int = 0
    
    @State var mentalityChange: Int = 0
    
    @State var foodChange: Int = 0
    
    @State var lastEnergy: Int = 8
    
    @State var lastMentality: Int = 8
    
    @State var lastFood: Int = 4
    
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
        
        if viewStatus == "main" {
            HomeView()
        } else if viewStatus == "summary" {
            SummaryView(viewStatus: $viewStatus)
        } else {
            ZStack {
                
                // Background
                Color.black
                    .ignoresSafeArea(.all)
                
                VStack(alignment: .leading) {
                    
                    InformationView(currentNodeId: currentNodeId, energy: $energy, mentality: $mentality, food: $food, speed: $speed, textAllShown: $textAllShown)
                        .onAppear {
                                        // Update visits count for this node
                                        Task {
                                            try await db!.transaction { core in
                                                try core.query("UPDATE Node SET visits = Node.visits + 1 WHERE node_id = ?", currentNodeId)
                                                // try core.query("UPDATE Node SET visits = ? Node.visits + 1 WHERE node_id = ?", 50, currentNodeId)
                                            }

                                        }

                                    }
                        .onChange(of: currentNodeId) { newNodeId in
                                            // Update visits count for this node
                                            Task {
                                                try await db!.transaction { core in
                                                    try core.query("UPDATE Node SET visits = Node.visits + 1 WHERE node_id = ?", newNodeId)
                                                }

                                            }

                                        }
                    
                    ChoicesView(currentNodeId: $currentNodeId, energy: $energy, mentality: $mentality, food: $food, isEnding: $isEnding, energyChange: $energyChange, mentalityChange: $mentalityChange, foodChange: $foodChange, lastEnergy: $lastEnergy, lastMentality: $lastMentality, lastFood: $lastFood, textAllShown: $textAllShown, viewStatus: $viewStatus)
                    
                    if valuePanelOpacity == 1 {
                        VStack {
                            // Display changes in values
                            HStack {
                                Text("Energy ")
                                Group {
                                    if energyChange > 0 {
                                        Text("+\(energyChange)")
                                    } else {
                                        Text("\(energyChange)")
                                            .opacity(energyChange != 0 ? 1 : 0)
                                    }
                                }
                                .frame(width: 30)
                                
                                Text("|  Metality")
                                Group {
                                    if mentalityChange > 0 {
                                        Text("+\(mentalityChange)")
                                    } else {
                                        Text("\(mentalityChange)")
                                            .opacity(mentalityChange != 0 ? 1 : 0)
                                    }
                                }
                                .frame(width: 30)
                                
                                Text("|  Food")
                                Group {
                                    if foodChange > 0 {
                                        Text("+\(foodChange)")
                                    } else {
                                        Text("\(foodChange)")
                                            .opacity(foodChange != 0 ? 1 : 0)
                                    }
                                }
                                .frame(width: 30)
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                            .onChange(of: currentNodeId) { _ in
                                energyChange = energy - lastEnergy
                                lastEnergy = energy
                                mentalityChange = mentality - lastMentality
                                lastMentality = mentality
                                foodChange = food - lastFood
                                lastFood = food
                            }
                            
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
                        .opacity(valuePanelOpacity)
                        
                    }
                    
                }
                .padding(.bottom, 10)
                .edgesIgnoringSafeArea(.horizontal)
                .edgesIgnoringSafeArea(.bottom)
                .onChange(of: isEnding) { currentIsEnding in
                    if currentIsEnding {
                        withAnimation(.easeInOut(duration: 1.5)) {
                            valuePanelOpacity = 0
                        }
                    } else {
                        withAnimation(.easeInOut(duration: 1.5)) {
                            valuePanelOpacity = 1
                        }
                    }
                }
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.5)) {
                        opacity = 1
                    }
                }
                
                SettingsView(show: $showPopUp, currentNodeId: $currentNodeId, textAllShown: $textAllShown, speed: $speed, energy: $energy, mentality: $mentality, food: $food, energyChange: $energyChange, mentalityChange: $mentalityChange, foodChange: $foodChange, lastEnergy: $lastEnergy, lastMentality: $lastMentality, lastFood: $lastFood)
            }
            .foregroundColor(.white)
        }
        
    }
    
}

// Preview provider
struct GamingView_Previews: PreviewProvider {
    static var previews: some View {
        GamingView(viewStatus: .constant(""))
        // Make the database available to all other view through the environment
            .environment(\.blackbirdDatabase, AppDatabase.instance)
    }
}

