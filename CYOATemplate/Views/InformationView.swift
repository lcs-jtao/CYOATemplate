//
//  InformationView.swift
//  CYOATemplate
//
//  Created by Judy YU on 2023-06-03.
//

import Blackbird
import SwiftUI

struct InformationView: View {
    
    // MARK: Stored properties
    
    // The id of the node we are trying to view
    let currentNodeId: Int
    
    // Needed to query database
    @Environment(\.blackbirdDatabase) var db: Blackbird.Database?
    
    // The list of nodes retrieved
    @BlackbirdLiveModels var nodes: Blackbird.LiveResults<Node>
    
    @State var illustrationName: String = ""
    
    var body: some View {
        
        if let node = nodes.results.first {
            
            VStack(spacing: 15) {
                
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
                .onAppear {
                    switch node.location {
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
                
                // Illustration
                Image("Coast")
                    .resizable()
                    .scaledToFit()
                
                // Narrative
                Text(try! AttributedString(markdown: node.narrative,
                                           options: AttributedString.MarkdownParsingOptions(interpretedSyntax:
                                                .inlineOnlyPreservingWhitespace)))
                .padding(.horizontal, 10)
                
                //Spacer()
                
            }
            .padding(.bottom, 10)
            .edgesIgnoringSafeArea(.horizontal)
            .background(.blue)
            
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

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView(currentNodeId: 1)
        // Make the database available to all other view through the environment
            .environment(\.blackbirdDatabase, AppDatabase.instance)
    }
}
