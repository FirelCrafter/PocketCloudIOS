//
//  MainScreen.swift
//  PocketCloud
//
//  Created by Михаил Щербаков on 14.04.2023.
//

import SwiftUI

struct MainScreen: View {
    
    @StateObject private var vm = MainScreenViewModel()
    
    var body: some View {
        ZStack {
            Color.mainTheme.background.ignoresSafeArea()
            VStack {
                Text("Pocket cloud")
                    .hLeading()
                    .font(.title2)
                    .padding(.leading)
                
                Header()
                
                FileTree(vm.currentDir)
            }
            .vTop()
            .padding(.vertical)
            
        }
        .onAppear{vm.fetchDir()}
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
    
    @ViewBuilder
    func FileTree(_ list: [FileNode]) -> some View {
        VStack {
            Text("File tree")
                .font(.title2)
                .hLeading()
            Text("/root")
                .hLeading()
                .padding(.leading)
            ScrollView {
                ForEach(list) { item in
                    TreeRow(type: item)
                }
            }
            .padding(.top)
            .background(
                Rectangle()
                    .fill(Color.white)
                    .cornerRadius(12)
            )
        }
        .vTop()
        .frame(width: screenBounds().width - 32, height: screenBounds().height/1.5)
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
