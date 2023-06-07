//
//  HomeView.swift
//  CYOATemplate
//
//  Created by Joyce Tao on 2023-06-05.
//

import SwiftUI

/* FONTS:
 Copyright 2020 The Palette Mosaic Project Authors (https://github.com/shibuyafont/Palette-mosaic-font-mono), all rights reserved.
 
 Copyright (c) 2011, wmk69 (wmk69@o2.pl),with Reserved Font Name NovaCut.

 Copyright 2020 The Darumadrop One Project Authors (https://github.com/ManiackersDesign/darumadrop) */

struct HomeView: View {
    
    // MARK: Stored properties
    @State var viewStatus = "main"
    
    @State var textColor = Color.white.opacity(0.9)
    
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
                    
                    AnimatedTextView()
                    
                    Text("TAP TO START")
                        .foregroundColor(textColor)
                        .font(.custom("DarumadropOne-Regular", size: 30))
                        //.shadow(radius: 10, x: 0, y: 20)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                                textColor = .white.opacity(0.7)
                            }
                        }
                    
                    HStack(spacing: 50) {
                        
                        // Summary button
                        Button(action: {
                            // Let the button animation show before switching to the next node
                            Task {
                                try await Task.sleep(for: Duration.seconds(0.15))
                                
                                viewStatus = "summary"
                            }

                        }, label: {
                            HStack {
                                Image(systemName: "square.and.pencil")
                                Text("Summary")
                            }
                        })
                        .buttonStyle(CustomButton())
                        
                    }
                    
                }
            }
            .onTapGesture {
                viewStatus = "game"
            }

        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
