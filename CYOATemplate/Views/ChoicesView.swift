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
            
            //Spacer()
            
            if edges.results.count == 0 {
                
                // Zero edge (Endings)
                //Spacer()
                
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
                
            } else if edges.results.count == 2 || edges.results.count == 3 {
                
                //Spacer()
                
                ForEach(edges.results) { currentEdge in
                        
                        VStack (alignment: .center) {
                            
                            // Choice 1
                            Button(action: {
                                
                            }, label: {
                                HStack {
                                    
                                    Spacer()
                                    
                                    Text(try! AttributedString(markdown: currentEdge.prompt))
                                    
                                    Spacer()
                                }
                            })
                            .buttonStyle(CustomButton())
                            .onTapGesture {
                                currentNodeId = currentEdge.to_node_id
                            }
                            
                        }
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 6)
                
            } else if edges.results.count == 1 {
                
                //Spacer()
                
                //VStack (alignment: .center) {
                    HStack(alignment: .center, spacing: 15) {
                        Spacer()

                        Text("Next...")
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 6)
                //}
            }
            
        }
        .foregroundColor(.white)
        .background(.yellow)
        .onAppear {
            if edges.results.count == 0 {
                withAnimation(.easeIn(duration: 1).delay(3)) {
                    zeroEdgeShowButton = true
                }
            }
        }
        .onTapGesture {
            if edges.results.count == 1 {
                // Proceed to next page
                //currentNodeId = 96
            }
            print("tapped1")
        }
        
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
