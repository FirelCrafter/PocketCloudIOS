//
//  ContentView.swift
//  PocketCloud
//
//  Created by Михаил Щербаков on 13.04.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.mainTheme.background.ignoresSafeArea()
            VStack {
                Text("Pocket cloud")
                    .hLeading()
                    .font(.title2)
                    .padding(.leading)
                
                Header()
            }
            .vTop()
            .padding(.vertical)
            
        }
    }
    
    @ViewBuilder
    func Header() -> some View {
        HStack {
            Text("Statistics").bold().hLeading().padding(.leading)
            HStack {
                StatCircle(title: .files(files: 0))
                StatCircle(title: .folders(folders: 0)).padding(.horizontal)
                StatCircle(title: .memory(current: 1024, total: 4096)).padding(.trailing)
            }
            
        }
        .hCenter()
        .frame(width: screenBounds().width - 32, height: screenBounds().height/8)
        .background(
            Color.white
                .cornerRadius(12)
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
