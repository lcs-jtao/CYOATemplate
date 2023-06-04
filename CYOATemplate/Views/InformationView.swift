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
    
    var body: some View {
        
        if let node = nodes.results.first {
            
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
                    .scaledToFill()
                
                // Narrative
                Text(try! AttributedString(markdown: node.narrative,
                                           options: AttributedString.MarkdownParsingOptions(interpretedSyntax:
                                                .inlineOnlyPreservingWhitespace)))
                .padding(.horizontal, 10)
                
            }
            .padding(.bottom, 10)
            .edgesIgnoringSafeArea(.horizontal)
            
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
