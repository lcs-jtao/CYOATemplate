//
//  ChoicesView.swift
//  CYOATemplate
//
//  Created by Judy YU on 2023-06-03.
//

import Blackbird
import SwiftUI

struct ChoicesView: View {
    
    // MARK: Stored properties
    
    // Needed to query database
    @Environment(\.blackbirdDatabase) var db: Blackbird.Database?
    
    // The list of edges retrieved
    @BlackbirdLiveModels var edges: Blackbird.LiveResults<Edge>
    
    @Binding var currentNodeId: Int
    
    @State var zeroEdgeShowButton = false
    
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
    
    // Is it an ending?
    @Binding var isEnding: Bool
    
    var body: some View {
        
        // Choices
        VStack {
            
            if edges.results.count == 0 {
                
                Spacer()
                
                // Zero edge (Endings)
                
                HStack (alignment: .center, spacing: 15) {
                    
                    // Restart
                    Button(action: {
                        
                        withAnimation(.easeIn(duration: 3)) {
                            currentNodeId = 1
                        }
                        
                        isEnding = false
                        
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
                    
                    // Home
                    Button(action: {
                        
                        //isEnding = false
                        
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
                            
                            Image(systemName: "house")
                            Text("Home")
                            
                            Spacer()
                        }
                    })
                    .buttonStyle(CustomButton())
                    
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 40)
                .opacity(zeroEdgeShowButton ? 1 : 0)
                .onAppear {
                    withAnimation(.easeIn(duration: 1).delay(6)) {
                        zeroEdgeShowButton = true
                    }
                }
                
            } else if edges.results.count == 2 || edges.results.count == 3 {
                
                Spacer()
                
                ForEach(edges.results) { currentEdge in
                    
                    VStack (alignment: .center) {
                        
                        // Choice 1
                        Button(action: {
                            
                            withAnimation(.easeIn(duration: 3)) {
                                currentNodeId = currentEdge.to_node_id
                            }
                            
                            // Value changes
                            energy += currentEdge.energy
                            mentality += currentEdge.mentality
                            food += currentEdge.food
                            
                            if energy > 10 {
                                energy = 10
                            } else if energy < 0 {
                                energy = 0
                            }
                            
                        }, label: {
                            HStack {
                                
                                Spacer()
                                
                                Text(try! AttributedString(markdown: currentEdge.prompt))
                                
                                Spacer()
                            }
                        })
                        .buttonStyle(CustomButton())
                        
                    }
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 6)
                
            } else if edges.results.count == 1 {
                
                ForEach(edges.results) { currentEdge in
                    
                    Button(action: {
                        
                        withAnimation(.easeIn(duration: 3)) {
                            currentNodeId = currentEdge.to_node_id
                        }
                        
                        // Value changes
                        energy += currentEdge.energy
                        mentality += currentEdge.mentality
                        food += currentEdge.food
                        
                        if energy > 10 {
                            energy = 10
                        } else if energy < 0 {
                            energy = 0
                        }
                        
                    }, label: {
                        VStack {
                            Spacer()
                            
                            HStack {
                                Spacer()
                                
                                Text("Next...")
                            }
                        }
                    })
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 6)
            }
            
        }
        .foregroundColor(.white)
        .onChange(of: edges.results.count) { currentNumberOfEdges in
            if currentNumberOfEdges == 0 {
                isEnding = true
            }
        }
        
    }
    
    // MARK: Initializer
    init(currentNodeId: Binding<Int>, energy: Binding<Int>, mentality: Binding<Int>, food: Binding<Int>, isEnding: Binding<Bool>, energyChange: Binding<Int>, mentalityChange: Binding<Int>, foodChange: Binding<Int>, lastEnergy: Binding<Int>, lastMentality: Binding<Int>, lastFood: Binding<Int>) {
        
        // Retrieve edges for the current node in the graph
        _edges = BlackbirdLiveModels({ db in
            try await Edge.read(from: db,
                                sqlWhere: "from_node_id = ?", "\(currentNodeId.wrappedValue)")
        })
        
        // Set the current node
        _currentNodeId = currentNodeId
        
        // Set the initial values
        _energy = energy
        _mentality = mentality
        _food = food
        _isEnding = isEnding
        _energyChange = energyChange
        _mentalityChange = mentalityChange
        _foodChange = foodChange
        _lastEnergy = lastEnergy
        _lastMentality = lastMentality
        _lastFood = lastFood
        
    }
}

// Preview provider
struct ChoicesView_Previews: PreviewProvider {
    static var previews: some View {
        ChoicesView(currentNodeId: .constant(2), energy: .constant(8), mentality: .constant(6), food: .constant(6), isEnding: .constant(true), energyChange: .constant(0), mentalityChange: .constant(0), foodChange: .constant(0), lastEnergy: .constant(8), lastMentality: .constant(6), lastFood: .constant(6))
        // Make the database available to all other view through the environment
            .environment(\.blackbirdDatabase, AppDatabase.instance)
    }
}
