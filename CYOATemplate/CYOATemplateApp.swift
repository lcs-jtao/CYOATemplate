//
//  CYOATemplateApp.swift
//  CYOATemplate
//
//  Created by Russell Gordon on 2023-05-29.
//

import RetroText
import SwiftUI

@main
struct CYOATemplateApp: App {
    
    init() {
        RetroText.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                // Make the database available to all other view through the environment
                .environment(\.blackbirdDatabase, AppDatabase.instance)

        }
    }
}
