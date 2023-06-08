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
            GamingView(viewStatus: $viewStatus)
        } else if viewStatus == "summary" {
            SummaryView(viewStatus: $viewStatus)
        } else {
            ZStack {
                
                Color.black
                    .ignoresSafeArea(.all)
                
                VStack(spacing: 100) {
                    
                    Spacer()
                    
                    AnimatedTextView()
                    
                    AnimatedStartView()
                    
                    ZStack(alignment: .topLeading) {
                        
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.gray.opacity(0.4))
                            .frame(width: 130, height: 43)
                            .blur(radius: 10)
                        
                        // Summary button
                        Button(action: {
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
                        .shadow(radius: 20)
                    }
                }
                .padding(.bottom, 70)
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
