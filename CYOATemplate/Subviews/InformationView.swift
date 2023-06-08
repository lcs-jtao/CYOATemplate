//
//  InformationView.swift
//  CYOATemplate
//
//  Created by Judy YU on 2023-06-03.
//

import Blackbird
import SwiftUI
import RetroText

struct InformationView: View {
    
    // MARK: Stored properties
    
    // The id of the node we are trying to view
    let currentNodeId: Int
    
    // Needed to query database
    @Environment(\.blackbirdDatabase) var db: Blackbird.Database?
    
    // The list of nodes retrieved
    @BlackbirdLiveModels var nodes: Blackbird.LiveResults<Node>
    
    @State var illustrationName: String = ""
    
    //@State var narrativeOpacity: CGFloat = 0
    
    @State var narrative: String = ""
    
    @State var finalNarrative: String = ""
    
    @Binding var speed: CGFloat
    
    @Binding var textAllShown: Bool
    
    // Day
    @State var numberOfDays: Int = 1
    
    // Values
    @Binding var energy: Int
    
    @Binding var mentality: Int
    
    @Binding var food: Int
    
    var body: some View {
        
        if let node = nodes.results.first {
            
            VStack(alignment: .leading, spacing: 15) {
                
                // Day & Location
                HStack {
                    
                    Text ("Day ") +
                    Text("\(node.day)")
                    
                    Spacer()
                    
                    Text(try! AttributedString(markdown: node.location,
                                               options: AttributedString.MarkdownParsingOptions(interpretedSyntax:
                                                    .inlineOnlyPreservingWhitespace)))
                    
                }
                .padding(.horizontal, 20)
                .onChange(of: node.location) { currentLocation in
                    switch currentLocation {
                    case "The Coast":
                        illustrationName = "Coast"
                    case "The Park":
                        illustrationName = "Park"
                    case "The Hospital":
                        illustrationName = "Hospital"
                    case "The Factory":
                        illustrationName = "Factory"
                    case "The Lake":
                        illustrationName = "Lake"
                    case "The Cabin":
                        illustrationName = "Cabin"
                    case "Adventure":
                        illustrationName = "Adventure"
                    default:
                        illustrationName = ""
                    }
                }
                .onChange(of: node.day) { currentDay in
                    
                    if currentDay != 1 {
                        
                        energy += 1
                        
                        // Max value for energy: 10
                        if energy > 10 {
                            energy = 10
                        }
                        
                        // No food results in energy - 1
                        if food > 0 {
                            food -= 1
                        } else {
                            energy -= 1
                        }
                        
                        // Poor mentality results in energy - 1
                        if mentality <= 2 {
                            energy -= 1
                        }
                    }
                    
                }
                
                // Illustration
                Image("Coast")
                    .resizable()
                    .scaledToFit()
                
                // Narrative
                Text(narrative)
                    .padding(.horizontal, 10)
                    .frame(maxWidth: .infinity, maxHeight:.infinity, alignment: .topLeading)
                    .onChange(of: node.narrative) { currentNarrative in
                        textAllShown = false
                        finalNarrative = currentNarrative
                        withAnimation {
                            typeWriter()
                        }
                    }
                    .onAppear {
                        if node.node_id == 1 {
                            finalNarrative = node.narrative
                            Task {
                                try await Task.sleep(for: Duration.seconds(1.5))
                                withAnimation {
                                    typeWriter()
                                }
                            }
                        }
                    }
                    .onChange(of: narrative) { currentNarrative in
                        if finalNarrative == currentNarrative {
                            textAllShown = true
                        }
                    }
                
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(.bottom, 10)
            .edgesIgnoringSafeArea(.horizontal)
            
        }
    }
    
    // MARK: Initializer
    init(currentNodeId: Int, energy: Binding<Int>, mentality: Binding<Int>, food: Binding<Int>, speed: Binding<CGFloat>, textAllShown: Binding<Bool>) {
        
        // Retrieve rows that describe nodes in the directed graph
        _nodes = BlackbirdLiveModels({ db in
            try await Node.read(from: db,
                                sqlWhere: "node_id = ?", "\(currentNodeId)")
        })
        
        // Set the node we are trying to view
        self.currentNodeId = currentNodeId
        
        // Set the initial values
        _energy = energy
        _mentality = mentality
        _food = food
        
        _speed = speed
        _textAllShown = textAllShown
    }
    
    
    // MARK: Functions
    func typeWriter(at position: Int = 0) {
        if position == 0 {
            narrative = ""
        }
        if position < finalNarrative.count {
            if finalNarrative[position] == "."{
                DispatchQueue.main.asyncAfter(deadline: .now() + speed * 5) {
                    narrative.append(finalNarrative[position])
                    typeWriter(at: position + 1)
                }
            } else if finalNarrative[position] == "," || finalNarrative[position] == ":"{
                DispatchQueue.main.asyncAfter(deadline: .now() + speed * 3) {
                    narrative.append(finalNarrative[position])
                    typeWriter(at: position + 1)
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + speed) {
                    narrative.append(finalNarrative[position])
                    typeWriter(at: position + 1)
                }
            }
        }
    }
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView(currentNodeId: 1, energy: .constant(8), mentality: .constant(6), food: .constant(4), speed: .constant(0.02), textAllShown: .constant(true))
        // Make the database available to all other view through the environment
            .environment(\.blackbirdDatabase, AppDatabase.instance)
    }
}

extension String {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
