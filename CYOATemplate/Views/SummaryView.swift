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
    @Binding var viewStatus: String
    
    // How many nodes have been visited?
    @BlackbirdLiveQuery(tableName: "Node", { db in
        try await db.query("SELECT COUNT(*) AS VisitedNodeCount FROM Node WHERE visits > 0")
    }) var nodesVisitedStats
    
    // How many nodes are there in total?
    @BlackbirdLiveQuery(tableName: "Node", { db in
        try await db.query("SELECT COUNT(*) AS TotalNodeCount FROM Node")
    }) var totalNodesStats
    
    // How many endings have been visited?
    @BlackbirdLiveQuery(tableName: "Node", { db in
        try await db.query("SELECT COUNT(*) AS VisitedEndingCount FROM Node WHERE visits > 0 AND ending_type_id != ''")
    }) var endingsVisitedStats
    
    // How many endings are there in total?
    @BlackbirdLiveQuery(tableName: "Node", { db in
        try await db.query("SELECT COUNT(*) AS TotalEndingCount FROM Node WHERE ending_type_id != ''")
    }) var totalEndingsStats
    
    // MARK: Computed properties
    // The actual integer value for how many nodes have been visited
    var visitedNodes: Int {
        return nodesVisitedStats.results.first?["VisitedNodeCount"]?.intValue ?? 0
    }
    
    // The total number of nodes
    var totalNodes: Int {
        return totalNodesStats.results.first?["TotalNodeCount"]?.intValue ?? 0
    }
    
    var visitedEndings: Int {
        return endingsVisitedStats.results.first?["VisitedEndingCount"]?.intValue ?? 0
    }
    
    var totalEndings: Int {
        return totalEndingsStats.results.first?["TotalEndingCount"]?.intValue ?? 0
    }
    
    var body: some View {
        if viewStatus == "main" {
            HomeView()
        } else if viewStatus == "game" {
            GamingView(viewStatus: $viewStatus)
        }
        else {
            
            ZStack {
                
                Color.black
                    .ignoresSafeArea(.all)
                
                VStack(spacing: 90) {
                    Text("You have explored \(visitedNodes) out of \(totalNodes) nodes overall in this story!")
                        .font(.custom(
                                "AmericanTypewriter",
                                fixedSize: 25))
                    
                    VStack(spacing: 12) {
                        Text("Checklist for Endings")
                            .textCase(.uppercase)
                            .font(.custom(
                                    "AmericanTypewriter",
                                    fixedSize: 18))
                            .bold()
                        
                        EndingChecklistView(endingType: 1)
                        EndingChecklistView(endingType: 2)
                        EndingChecklistView(endingType: 3)
                        EndingChecklistView(endingType: 4)
                        EndingChecklistView(endingType: 5)
                        
                        Text("")
                        
                        Text("\(visitedEndings) out of \(totalEndings) endings are reached.")
                            .font(.custom(
                                    "AmericanTypewriter",
                                    fixedSize: 15))
                    }
                    .background(Color.gray.opacity(0.2))
                    .padding()
                    
                    Button(action: {
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
                .padding()
            }
            .foregroundColor(.white)
        }
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView(viewStatus: .constant(""))
    }
}
