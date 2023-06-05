//
//  HomeView.swift
//  CYOATemplate
//
//  Created by Joyce Tao on 2023-06-05.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        ZStack {
            
            Color.black
                .ignoresSafeArea(.all)
                
            VStack {

                Spacer()
                
                Image("Coast")
                    .resizable()
                    .frame(maxHeight: 300)
                    .padding(.horizontal)
                
                Spacer()
                
                HStack {
                    
                    Spacer()
                    
                    // Start button
                    NavigationLink(destination: GamingView()) {
                        Button(action: {
                            print("start game")
                        }, label: {
                            HStack {
                                Image(systemName: "house")
                                Text("Start")
                            }
                        })
                        .buttonStyle(CustomButton())
                    }
                    
                    Spacer()
                    
                    // Summary button
                    NavigationLink(destination: SummaryView()) {
                        Button(action: {
                            print("start game")
                        }, label: {
                            HStack {
                                Image(systemName: "house")
                                Text("Summary")
                            }
                        })
                        .buttonStyle(CustomButton())
                    }
                    
                    Spacer()
                    
                }
                
                Spacer()
                
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
