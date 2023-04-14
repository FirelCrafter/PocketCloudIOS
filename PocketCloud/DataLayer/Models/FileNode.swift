//
//  FileNode.swift
//  PocketCloud
//
//  Created by Михаил Щербаков on 14.04.2023.
//

import Foundation

enum FileNode: Identifiable, Equatable {
    var id: String {
        switch self {
        case .file(_, _, _, _, _):
            return UUID().uuidString
        case .directory(_, _, _, _):
            return UUID().uuidString
        }
    }
    case file(nodeId: Int, parentId: Int, path: String, name: String, fileExtension: String)
    case directory(nodeId: Int, parentId: Int, path: String, name: String)
}

