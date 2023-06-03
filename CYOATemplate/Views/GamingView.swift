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
    @State var currentNodeId: Int = 1
    
    // Needed to query database
    @Environment(\.blackbirdDatabase) var db: Blackbird.Database?
    
    // The list of nodes retrieved
    @BlackbirdLiveModels var nodes: Blackbird.LiveResults<Node>
    
    @State private var showPopUp: Bool = false
    
    @State var location: String = "The Coast"
    
    @State var date: Int = 1
    
    @State var energy: Int = 7
    
    @State var mentality: Int = 8
    
    @State var food: Int = 4
    
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
    
    var illustrationName: String {
        if location.contains("Coast") {
            return "Coast"
        } else if location.contains("Park") {
            return "Park"
        } else if location.contains("Hospital") {
            return "Hospital"
        } else if location.contains("Factory") {
            return "Factory"
        } else if location.contains("Lake") {
            return "Lake"
        } else if location.contains("Cabin") {
            return "Cabin"
        } else if location.contains("Adventure") {
            return "Adventure"
        } else {
            return ""
        }
    }
    
    var body: some View {
        
        if let node = nodes.results.first {
            
            ZStack {
                
                // Background
                Color.black
                    .ignoresSafeArea(.all)
                
                VStack(alignment: .leading) {
                    
                    VStack(spacing: 15) {
                        
                        // Day & Location
                        HStack {
                            
                            Text("Day 1")
                            
                            Spacer()
                            
                            Text("The Coast")
                            
                        }
                        .padding(.horizontal, 20)
                        
                        // Illustration
                        Image("Coast")
                            .resizable()
                            .scaledToFit()
                        
                        NarrativesAndChoicesView()
                        
                    }
                    
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
                                
                                Image("Bread")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                
                                Text(": 4")
                                
                            }
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
                .padding(.bottom, 10)
                .edgesIgnoringSafeArea(.horizontal)
                .edgesIgnoringSafeArea(.bottom)
                .onChange(of: date) { newDate in
                    if energy <= 0 {
                        // Go to ending
                    }
                    energy += 1
                    food -= 1
                    if mentality <= 2 {
                        energy -= 1
                    }
                }
                
                SettingsView(show: $showPopUp)
            }
            .foregroundColor(.white)
            
        } else {
            Text("Node with id \(currentNodeId) not found; directed graph has a gap.")
        }
        
    }
    
    // MARK: Initializer
    init(currentNodeId: Int) {
        
        // Retrieve rows that describe nodes in the directed graph
        _nodes = BlackbirdLiveModels({ db in
            try await Node.read(from: db,
                                    sqlWhere: "node_id = ?", "\(currentNodeId)")
        })
        
        // Set the node we are trying to view
        self.currentNodeId = currentNodeId
        
    }
}

// Preview provider
struct GamingView_Previews: PreviewProvider {
    static var previews: some View {
        GamingView(currentNodeId: 1)
            // Make the database available to all other view through the environment
            .environment(\.blackbirdDatabase, AppDatabase.instance)
    }
}

