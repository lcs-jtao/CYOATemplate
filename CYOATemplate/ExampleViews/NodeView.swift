//
//  NodeView.swift
//  CYOATemplate
//
//  Created by Russell Gordon on 2023-06-01.
//

import Blackbird
import SwiftUI

struct NodeView: View {
    
    // MARK: Stored properties
    
    // The id of the node we are trying to view
    let currentNodeId: Int

    // Needed to query database
    @Environment(\.blackbirdDatabase) var db: Blackbird.Database?
    
    // The list of nodes retrieved
    @BlackbirdLiveModels var nodes: Blackbird.LiveResults<Node>
    
    // MARK: Computed properties
    
    // The user interface
    var body: some View {
        if let node = nodes.results.first {

            VStack {
                
                Divider()
                
                Text("Node visited \(node.visits) times.")
                
                Divider()
                
                // Show a Text view, but render Markdown syntax, preserving newline characters
                // Text(node.narrative)
                Text(try! AttributedString(markdown: node.narrative,
                                           options: AttributedString.MarkdownParsingOptions(interpretedSyntax:
                                                                                                  .inlineOnlyPreservingWhitespace)))
                .onAppear { // Only works when it first appear
                    updateVisitCount(forNodeWithId: currentNodeId)
                    
                }
                .onChange(of: currentNodeId) { newNodeId in
                    updateVisitCount(forNodeWithId: newNodeId)
                    
                }
                
            }
            
        } else {
            Text("Node with id \(currentNodeId) not found; directed graph has a gap.")
        }
    }
    
    // MARK: Initializer
    
    // Function that runs once when the structure is created (runs synchronously)
    init(currentNodeId: Int) {
        
        // Retrieve rows that describe nodes in the directed graph
        // NOTE: There should only be one row for a given node_id
        //       since there is a UNIQUE constrant on the node_id column
        //       in the Node table
        _nodes = BlackbirdLiveModels({ db in
            try await Node.read(from: db,
                                    sqlWhere: "node_id = ?", "\(currentNodeId)")
        })
        
        // Set the node we are trying to view
        self.currentNodeId = currentNodeId
        
    }

    // MARK: Function(s)
    func updateVisitCount(forNodeWithId id: Int) {
        
        // Update visits count for this node (runs asynchronously)
        Task {
            try await db!.transaction { core in
                try core.query("UPDATE Node SET visits = Node.visits + 1 WHERE node_id = ?", id)
                // try core.query("UPDATE Node SET visits = ? Node.visits + 1 WHERE node_id = ?", 50, currentNodeId)
            }
            
        }
    }
    
}

struct NodeView_Previews: PreviewProvider {
    
    static var previews: some View {

        NodeView(currentNodeId: 1)
        // Make the database available to all other view through the environment
        .environment(\.blackbirdDatabase, AppDatabase.instance)

    }
}
