//
//  MainScreenViewModel.swift
//  PocketCloud
//
//  Created by Михаил Щербаков on 14.04.2023.
//

import SwiftUI
import Combine

class MainScreenViewModel: ObservableObject {
    
    @Published var currentDir: [FileNode] = []
    
    func fetchDir() {
        self.currentDir = generateMockFileNodes()
    }
    
}

//MARK: Mock data

func generateMockFileNodes() -> [FileNode] {
    return [
        .directory(nodeId: 1, parentId: 0, path: "/root", name: "Documents"),
        .file(nodeId: 2, parentId: 1, path: "/root/Documents", name: "file1", fileExtension: "txt"),
        .file(nodeId: 3, parentId: 1, path: "/root/Documents", name: "file2", fileExtension: "pdf"),
        .directory(nodeId: 4, parentId: 0, path: "/root", name: "Images"),
        .file(nodeId: 5, parentId: 4, path: "/root/Images", name: "image1", fileExtension: "png"),
        .file(nodeId: 6, parentId: 4, path: "/root/Images", name: "image2", fileExtension: "jpg")
    ]
}

