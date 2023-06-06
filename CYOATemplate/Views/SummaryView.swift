//
//  SummaryView.swift
//  CYOATemplate
//
//  Created by Joyce Tao on 2023-06-05.
//

import Blackbird
import SwiftUI

struct SummaryView: View {
    
    // MARK: Stored properties
    // How many nodes have been visited?
    @BlackbirdLiveQuery(tableName: "Node", { db in
        try await db.query("SELECT COUNT(*) AS VisitedNodeCount FROM Node WHERE Node.visits > 0")
    }) var nodesVisitedStats
    
    // How many nodes are there in total?
    @BlackbirdLiveQuery(tableName: "Node", { db in
        try await db.query("SELECT COUNT(*) AS TotalNodeCount FROM Node")
    }) var totalNodesStats
    
    // MARK: Computed properties
    // The actual integer value for how many nodes have been visited
    var visitedNodes: Int {
        return nodesVisitedStats.results.first?["VisitedNodeCount"]?.intValue ?? 0
    }
    
    // The total number of nodes
    var totalNodes: Int {
        return totalNodesStats.results.first?["TotalNodeCount"]?.intValue ?? 0
    }
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea(.all)
            
            VStack {
                Text("You have explored \(visitedNodes) nodes out of \(totalNodes) nodes overall in this story!")
                    .padding()
            }
        }
        .foregroundColor(.white)
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
    }
}
