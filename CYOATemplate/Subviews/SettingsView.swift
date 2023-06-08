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
                        
                        VStack {
                            
                            ZStack {
                                
                                Text("- SETTINGS -")
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
                            
                            // Map
                            Image("Coast")
                                .resizable()
                                .frame(maxHeight: 200)
                                .padding(.horizontal)
                            
                            // Divider
                            Divider()
                                .frame(width: 200, height: 1.5)
                                .overlay(.gray)
                            
                            HStack(spacing: 20) {
                                
                                // Restart button
                                Button(action: {
                                    
                                    // Go back to node 1
                                    currentNodeId = 1
                                    // Dismiss the pop up
                                    withAnimation(.linear(duration: 0.2)) {
                                        show = false
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
                                        Image(systemName: "arrow.counterclockwise")
                                        Text("Restart")
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
                                        Image(systemName: "house")
                                        Text("Home")
                                    }
                                })
                                .buttonStyle(CustomButton())
                            }
                            .padding(.bottom, 20)
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
        SettingsView(show: .constant(true), currentNodeId: .constant(1), textAllShown: .constant(true), energy: .constant(8), mentality: .constant(6), food: .constant(6), energyChange: .constant(0), mentalityChange: .constant(0), foodChange: .constant(0), lastEnergy: .constant(8), lastMentality: .constant(6), lastFood: .constant(6))
    }
}
