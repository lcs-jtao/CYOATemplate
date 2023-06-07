//
//  EndingChecklistView.swift
//  CYOATemplate
//
//  Created by Joyce Tao on 2023-06-07.
//

import Blackbird
import SwiftUI

struct EndingChecklistView: View {
    
    // MARK: Stored Properties
    let endingType: Int
    
    @BlackbirdLiveQuery var visitedEndingNodeCount: Blackbird.LiveResults<Blackbird.Row>
    
    @BlackbirdLiveQuery var totalEndingNodeCount: Blackbird.LiveResults<Blackbird.Row>
    
    // MARK: Computed Properties
    var visitedEndingType1: Int {
        return visitedEndingNodeCount.results.first?["VisitedEndingCount1"]?.intValue ?? 0
    }
    
    var totalEndingType1: Int {
        return totalEndingNodeCount.results.first?["TotalEndingCount1"]?.intValue ?? 0
    }
    
    var body: some View {
        Text("\(visitedEndingType1) / \(totalEndingType1)")
    }
    
    // MARK: Initializers
    init(endingType: Int) {
        _visitedEndingNodeCount = BlackbirdLiveQuery(tableName: "Node", { db in
            try await db.query("SELECT COUNT(*) AS VisitedEndingCount1 FROM Node WHERE visits > 0 AND ending_type_id = \(endingType)")
        })
        _totalEndingNodeCount = BlackbirdLiveQuery(tableName: "Node", { db in
            try await db.query("SELECT COUNT(*) AS TotalEndingCount1 FROM Node WHERE ending_type_id = \(endingType)")
        })

        
        self.endingType = endingType
        
    }
    
}

struct EndingChecklistView_Previews: PreviewProvider {
    static var previews: some View {
        EndingChecklistView(endingType: 1)
    }
}
