//
//  TreeRow.swift
//  PocketCloud
//
//  Created by Михаил Щербаков on 14.04.2023.
//

import SwiftUI

struct TreeRow: View {
    let type: FileNode
    var body: some View {
        VStack {
            rowInner()
            Divider()
        }
        .frame(maxWidth: screenBounds().width - 32, maxHeight: screenBounds().height/20)
    }
    
    @ViewBuilder
    func rowInner() -> some View {
        switch type {
        case .file(let nodeId, let parentId, let path, let name, let fileExtension):
            HStack {
               Image("File")
                    .resizable()
                    .scaledToFit()
                Text("\(name).\(fileExtension)")
                
            }
            .hLeading()
            .padding(.leading)
        case .directory(let nodeId, let parentId, let path, let name):
            HStack {
                Image("Directory")
                    .resizable()
                    .scaledToFit()
                Text(name)
            }
            .hLeading()
            .padding(.leading)
        }
    }
}

struct TreeRow_Previews: PreviewProvider {
    static var previews: some View {
        TreeRow(type: .file(nodeId: 0, parentId: 0, path: "", name: "Text", fileExtension: "txt"))
            .previewLayout(.sizeThatFits)
    }
}
