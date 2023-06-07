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
                        .foregroundColor(.white.opacity(0.8))
                        .font(.custom("DarumadropOne-Regular", fixedSize: 30))
                        //.shadow(radius: 10, x: 0, y: 20)
                    
                    HStack(spacing: 50) {
                        
                        // Summary button
                        Button(action: {
                            viewStatus = "summary"
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

        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
