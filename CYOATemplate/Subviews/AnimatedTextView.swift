//
//  AnimatedTextView.swift
//  CYOATemplate
//
//  Created by Judy YU on 2023-06-07.
//

import SwiftUI

struct AnimatedTextView: View {
    
    // MARK: Stored Properties
    @State var color = Color.white.opacity(0.8)
    
    @State var size = 100.0
    
    @State var blurOpacity = 0.6
    
    @State var blurSize = 60.0
    
    var body: some View {
        ZStack {
            
            Ellipse()
                .foregroundColor(.white.opacity(blurOpacity))
                .frame(width: 290, height: 230)
                .blur(radius: blurSize)
            
            VStack {
                Text("RAD")
                Text("ZONE")
                Text("Survival Island")
                    .font(.custom("PaletteMosaic-Regular", fixedSize: 20))
                    .tracking(4)
            }
            .font(.custom("PaletteMosaic-Regular", fixedSize: size))
            .foregroundColor(color)
            .shadow(color: .black, radius: 50)
            
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                size = 100.1
                color = .white.opacity(0.5)
                blurOpacity = 0.4
                blurSize = 57.0
            }
        }
        
    }
}

struct AnimatedStartView: View {
    
    // MARK: Stored Properties
    @State var textColor = Color.white.opacity(0.9)
    
    @State var blurOpacity = 0.7
    
    var body: some View {
        ZStack {
            
            Ellipse()
                .foregroundColor(.white.opacity(blurOpacity))
                .frame(width: 250, height: 6)
                .blur(radius: 6)
            
            Text("- TAP TO START -")
                .foregroundColor(textColor)
                .font(.custom("novacut", fixedSize: 25))
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                textColor = .white.opacity(0.7)
                blurOpacity = 0.5
            }
        }
    }
}
