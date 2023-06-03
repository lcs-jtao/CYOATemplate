//
//  NarrativesAndChoicesView.swift
//  CYOATemplate
//
//  Created by Judy YU on 2023-06-03.
//

import Blackbird
import SwiftUI

struct NarrativesAndChoicesView: View {
    
    // MARK: Stored properties
    
    // What node are we on?
    @State var currentNodeId: Int = 1
    
    // Needed to query database
    @Environment(\.blackbirdDatabase) var db: Blackbird.Database?
    
    // The list of nodes retrieved
    @BlackbirdLiveModels var nodes: Blackbird.LiveResults<Node>
    
    @State var narrative: String = "There are two possible destinations where you can find resources to help you survive, where should you go?\n\nNote: it is an important decision which will influence the story development."
    
    @State var choiceOne: String = "The Park"
    
    @State var choiceTwo: String = "The Hospital"
    
    @State var choiceThree: String = "Third Choice"
    
    @State var numberOfEdges: Int = 2
    
    @State var zeroEdgeShowButton = false
    
    var body: some View {
        if let node = nodes.results.first {
            
            VStack(alignment: .leading) {
                
                VStack(alignment: .leading) {
                    // Narrative
                    Text(try! AttributedString(markdown: node.narrative,
                                               options: AttributedString.MarkdownParsingOptions(interpretedSyntax:
                                                                                                      .inlineOnlyPreservingWhitespace)))
                        .padding(.horizontal, 10)
                    
                    Spacer()
                }
                //.background(.yellow)
                //.contentShape(Rectangle())
                .onTapGesture {
                    if numberOfEdges == 1 {
                       //Proceed to next edge
                        
                    }
                }
                .onAppear {
                    if numberOfEdges == 0 {
                        withAnimation(.easeIn(duration: 1).delay(3)) {
                            zeroEdgeShowButton = true
                        }
                    }
                }
                
                // Choices
                VStack {
                    
                    if numberOfEdges == 0 {
                            
                            // Zero edge (ending)
                            HStack (alignment: .center, spacing: 15) {
                                
                                // Restart
                                Button(action: {
                                    
                                }, label: {
                                    HStack {
                                        Spacer()
                                        
                                        Image(systemName: "arrow.counterclockwise")
                                        Text("Restart")
                                        
                                        Spacer()
                                    }
                                })
                                .buttonStyle(CustomButton())
                                
                                // Choice 2
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
                            //.background(.purple)
                        
                    } else if numberOfEdges == 2 {
                        
                        // Two choices (edges)
                        HStack {
                            
                            Spacer()
                            
                            VStack (alignment: .center, spacing: 20) {
                                
                                // Choice 1
                                Button(action: {
                                    
                                }, label: {
                                    HStack {
                                        
                                        Spacer()
                                        
                                        Text(choiceOne)
                                        
                                        Spacer()
                                    }
                                })
                                .buttonStyle(CustomButton())
                                
                                // Choice 2
                                Button(action: {
                                    
                                }, label: {
                                    HStack {
                                        Spacer()
                                        
                                        Text(choiceTwo)
                                        
                                        Spacer()
                                    }
                                })
                                .buttonStyle(CustomButton())
                            }
                        }
                        .padding(.horizontal, 40)
                        .padding(.vertical, 10)
                        
                    } else if numberOfEdges == 3 {
                        
                        // Three choices (edges)
                        HStack {
                            
                            Spacer()
                            
                            VStack (alignment: .center, spacing: 20) {
                                
                                // Choice 1
                                Button(action: {
                                    
                                }, label: {
                                    HStack {
                                        
                                        Spacer()
                                        
                                        Text(choiceOne)
                                        
                                        Spacer()
                                    }
                                })
                                .buttonStyle(CustomButton())
                                
                                // Choice 2
                                Button(action: {
                                    
                                }, label: {
                                    HStack {
                                        Spacer()
                                        
                                        Text(choiceTwo)
                                        
                                        Spacer()
                                    }
                                })
                                .buttonStyle(CustomButton())
                                
                                // Choice 3
                                Button(action: {
                                    
                                }, label: {
                                    HStack {
                                        Spacer()
                                        
                                        Text(choiceThree)
                                        
                                        Spacer()
                                    }
                                })
                                .buttonStyle(CustomButton())
                                
                            }
                        }
                        .padding(.horizontal, 40)
                        .padding(.vertical, 10)
                        
                    }
                }
                
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
struct NarrativesAndChoicesView_Previews: PreviewProvider {
    static var previews: some View {
        NarrativesAndChoicesView(currentNodeId: 1)
    }
}
