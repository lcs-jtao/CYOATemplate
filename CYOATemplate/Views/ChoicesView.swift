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
    @State var energy: Int = 8
    
    @State var mentality: Int = 8
    
    @State var food: Int = 4
    
    var body: some View {
        
        // Choices
        VStack {
            
            if edges.results.count == 0 {
                
                Spacer()
                
                // Zero edge (Endings)
                
                HStack (alignment: .center, spacing: 15) {
                    
                    // Restart
                    Button(action: {
                        
                        currentNodeId = 1
                        
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
                        
                    }, label: {
                        HStack {
                            Spacer()
                            
                            Image(systemName: "house")
                            Text("Back to Home")
                            
                            Spacer()
                        }
                    })
                    .buttonStyle(CustomButton())
                    
                }
                .padding(.horizontal, 5)
                .padding(.vertical, 10)
                .opacity(zeroEdgeShowButton ? 1 : 0)
                .onAppear {
                    //if edges.results.count == 0 {
                        withAnimation(.easeIn(duration: 1).delay(6)) {
                            zeroEdgeShowButton = true
                        }
                    //}
                }
                
            } else if edges.results.count == 2 || edges.results.count == 3 {
                
                Spacer()
                
                ForEach(edges.results) { currentEdge in
                        
                        VStack (alignment: .center) {
                            
                            // Choice 1
                            Button(action: {
                                
                                withAnimation(.easeIn(duration: 6)) {
                                    currentNodeId = currentEdge.to_node_id
                                }
                                
                                //currentNodeId = currentEdge.to_node_id
                                
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
                        
                        withAnimation(.easeIn(duration: 6)) {
                            currentNodeId = currentEdge.to_node_id
                        }
                        
                        //currentNodeId = currentEdge.to_node_id
                        
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
        
    }
    
    // MARK: Initializer
    init(currentNodeId: Binding<Int>) {
        
        // Retrieve edges for the current node in the graph
        _edges = BlackbirdLiveModels({ db in
            try await Edge.read(from: db,
                                sqlWhere: "from_node_id = ?", "\(currentNodeId.wrappedValue)")
        })
        
        // Set the current node
        _currentNodeId = currentNodeId
        
    }
}

// Preview provider
struct ChoicesView_Previews: PreviewProvider {
    static var previews: some View {
        ChoicesView(currentNodeId: .constant(2))
        // Make the database available to all other view through the environment
            .environment(\.blackbirdDatabase, AppDatabase.instance)
    }
}
