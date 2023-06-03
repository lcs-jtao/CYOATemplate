//
//  NarrativesAndChoicesView.swift
//  CYOATemplate
//
//  Created by Judy YU on 2023-06-03.
//

import SwiftUI

struct NarrativesAndChoicesView: View {
    
    // MARK: Stored properties
    @State var narrative: String = "There are two possible destinations where you can find resources to help you survive, where should you go?\n\nNote: it is an important decision which will influence the story development."
    
    @State var choiceOne: String = "The Park"
    
    @State var choiceTwo: String = "The Hospital"
    
    @State var choiceThree: String = "Third Choice"
    
    @State var numberOfEdges: Int = 2
    
    @State var zeroEdgeShowButton = false
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            VStack(alignment: .leading) {
                // Narrative
                Text(narrative)
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
    }
}

// Preview provider
struct NarrativesAndChoicesView_Previews: PreviewProvider {
    static var previews: some View {
        NarrativesAndChoicesView()
    }
}
