//
//  HomeView.swift
//  CYOATemplate
//
//  Created by Joyce Tao on 2023-06-05.
//

import SwiftUI

struct HomeView: View {
    
    // MARK: Stored properties
    @State var viewStatus = "main"
    
    var body: some View {
        if viewStatus == "game" {
            GamingView()
        } else if viewStatus == "summary" {
            SummaryView()
        } else {
            ZStack {
                
                Color.black
                    .ignoresSafeArea(.all)
                    
                VStack(spacing: 100) {
                    
                    Image("Coast")
                        .resizable()
                        .frame(maxHeight: 300)
                        .padding(.horizontal)
                    
                    HStack(spacing: 50) {
                        
                        // Start button
                        Button(action: {
                            viewStatus = "game"
                        }, label: {
                            HStack {
                                Image(systemName: "house")
                                Text("Start")
                            }
                        })
                        .buttonStyle(CustomButton())
                        
                        // Summary button
                        Button(action: {
                            viewStatus = "summary"
                        }, label: {
                            HStack {
                                Image(systemName: "house")
                                Text("Summary")
                            }
                        })
                        .buttonStyle(CustomButton())
                        
                    }
                    
                }
            }

        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
