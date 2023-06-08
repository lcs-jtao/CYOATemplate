//
//  SettingsView.swift
//  CYOATemplate
//
//  Created by Judy YU on 2023-06-03.
//

import SwiftUI

// Adapted from: https://johncodeos.com/how-to-create-a-popup-window-with-swiftui/
struct SettingsView: View {
    
    // MARK: Stored Properties
    @State var viewStatus = "setting"
    
    @Binding var show: Bool
    
    @Binding var currentNodeId: Int
    
    @Binding var textAllShown: Bool
    
    @Binding var speed: CGFloat
    
    @State private var textSpeed: String = "Medium"
    
    // Values
    @Binding var energy: Int
    
    @Binding var mentality: Int
    
    @Binding var food: Int
    
    @Binding var energyChange: Int
    
    @Binding var mentalityChange: Int
    
    @Binding var foodChange: Int
    
    @Binding var lastEnergy: Int
    
    @Binding var lastMentality: Int
    
    @Binding var lastFood: Int
    
    var body: some View {
        
        if viewStatus == "main" {
            HomeView()
        } else {
            ZStack {
                if show {
                    // PopUp background color
                    Color.black.opacity(show ? 0.4 : 0)
                        .edgesIgnoringSafeArea(.all)
                    
                    // PopUp Window
                    VStack(alignment: .center, spacing: 15) {
                        
                        VStack(spacing: 15) {
                            
                            ZStack {
                                
                                Text("- SETTINGS -")
                                    .font(.title3)
                                    .padding(.top)
                                
                                HStack {
                                    
                                    Spacer()
                                    
                                    // Close button
                                    Button(action: {
                                        
                                        // Dismiss the pop up
                                        withAnimation(.linear(duration: 0.2)) {
                                            show = false
                                        }
                                        
                                    }, label: {
                                        Image(systemName: "xmark")
                                            .foregroundColor(Color.white)
                                            .font(.title)
                                            .frame(width: 30, height: 30)
                                            .padding(5)
                                            .border(.white)
                                            .cornerRadius(6)
                                        
                                    })
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            
                            Text("Map of the coastal area")
                                .font(.custom("DarumadropOne-Regular", fixedSize: 15))
                            
                            // Map
                            Image("Map")
                                .resizable()
                                .frame(maxHeight: 200)
                                .padding(.horizontal)
                            
                            VStack(spacing: 20) {
                                // Adjust speed button
                                Button(action: {
                                    
                                    switch textSpeed {
                                    case "Medium":
                                        textSpeed = "Fast"
                                    case "Fast":
                                        textSpeed = "Really fast"
                                    case "Really fast":
                                        textSpeed = "Slow"
                                    case "Slow":
                                        textSpeed = "Medium"
                                    default:
                                        textSpeed = "Medium"
                                    }
                                    
                                }, label: {
                                    HStack {
                                        
                                        Spacer()
                                        
                                        Text("Text speed: \(textSpeed)")
                                        
                                        Spacer()
                                    }
                                })
                                .buttonStyle(CustomButton())
                                .onChange(of: textSpeed) { currentTextSpeed in
                                    switch currentTextSpeed {
                                    case "Medium":
                                        speed = 0.025
                                    case "Fast":
                                        speed = 0.01
                                    case "Really fast":
                                        speed = 0.005
                                    case "Slow":
                                        speed = 0.04
                                    default:
                                        speed = 0.025
                                    }
                                }
                                
                                HStack(spacing: 20) {
                                    
                                    // Restart button
                                    Button(action: {
                                        
                                        // Let the button animation show before switching to the next node
                                        Task {
                                            try await Task.sleep(for: Duration.seconds(0.15))
                                            
                                            // Go back to node 1
                                            currentNodeId = 1
                                            
                                            // Dismiss the pop up
                                            withAnimation(.linear(duration: 0.2)) {
                                                show = false
                                            }
                                        }
                                        
                                        // Reset values
                                        energy = 8
                                        mentality = 8
                                        food = 4
                                        energyChange = 0
                                        mentalityChange = 0
                                        foodChange = 0
                                        lastEnergy = 8
                                        lastMentality = 8
                                        lastFood = 4
                                        
                                    }, label: {
                                        HStack {
                                            Spacer()
                                            Image(systemName: "arrow.counterclockwise")
                                            Text("Restart")
                                            Spacer()
                                        }
                                    })
                                    .buttonStyle(CustomButton())
                                    .disabled(textAllShown ? false : true)
                                    .opacity(textAllShown ? 1 : 0.7)
                                    
                                    // Home button
                                    Button(action: {
                                        
                                        // Reset values
                                        energy = 8
                                        mentality = 8
                                        food = 4
                                        energyChange = 0
                                        mentalityChange = 0
                                        foodChange = 0
                                        lastEnergy = 8
                                        lastMentality = 8
                                        lastFood = 4
                                        
                                        // Let the button animation show before switching to the next node
                                        Task {
                                            try await Task.sleep(for: Duration.seconds(0.15))
                                            
                                            viewStatus = "main"
                                        }
                                        
                                    }, label: {
                                        HStack {
                                            Spacer()
                                            Image(systemName: "house")
                                            Text("Home")
                                            Spacer()
                                        }
                                    })
                                    .buttonStyle(CustomButton())
                                }
                                .padding(.bottom, 20)
                            }
                            .padding(.horizontal)

                        }
                        
                    }
                    .frame(maxWidth: 320)
                    .border(Color.white, width: 1)
                    .background(Color.black)
                }
            }
            .foregroundColor(.white)
        }
        
    }
    
}

// Preview provider
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(show: .constant(true), currentNodeId: .constant(1), textAllShown: .constant(true), speed: .constant(0.02), energy: .constant(8), mentality: .constant(6), food: .constant(6), energyChange: .constant(0), mentalityChange: .constant(0), foodChange: .constant(0), lastEnergy: .constant(8), lastMentality: .constant(6), lastFood: .constant(6))
    }
}
