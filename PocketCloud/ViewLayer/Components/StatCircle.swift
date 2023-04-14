//
//  StatCircle.swift
//  PocketCloud
//
//  Created by Михаил Щербаков on 14.04.2023.
//

import SwiftUI

struct StatCircle: View {
    enum TitleType {
        case memory(current:Int, total:Int)
        case files(files:Int)
        case folders(folders:Int)
    }
    
    let title: TitleType
    @State private var drawingCircle: Bool = false
    
    var body: some View {
        makeCircle()
    }
    
    @ViewBuilder
    func makeCircle() -> some View {
        switch title {
        case .memory(let current, let total):
            ZStack {
                Circle()
                    .trim(from: 0, to: 1)
                    .rotation(.degrees(90))
                    .stroke(Color.gray, lineWidth: 12)
                    .frame(width: screenBounds().width/9)
                Circle()
                    .trim(from: 0, to: drawingCircle ? Double(Double(current)/Double(total)) : 0)
                    .rotation(.degrees(90))
                    .stroke(Color.orange, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .frame(width: screenBounds().width/9)
                    .animation(.easeOut(duration: 1), value: drawingCircle)
                    .onAppear{drawingCircle.toggle()}
                Text("MB")
                    .font(.caption)
                    .foregroundColor(Color.gray)
                Text("\(total-current)")
                    .font(.caption)
                    .foregroundColor(Color.gray)
                    .padding(.top, 80)
            }
        case .files(let files):
            ZStack {
                Circle()
                    .rotation(.degrees(164))
                    .stroke(Color.orange, lineWidth: 12)
                    .frame(width: screenBounds().width/9)
                Text("\(files)")
                    .font(.caption)
                    .foregroundColor(Color.gray)
                
                Text("files")
                    .font(.caption)
                    .foregroundColor(Color.gray)
                    .padding(.top, 80)
            }
        case .folders(let folders):
            ZStack {
                Circle()
                    .rotation(.degrees(164))
                    .stroke(Color.orange, lineWidth: 12)
                    .frame(width: screenBounds().width/9)
                Text("\(folders)")
                    .font(.caption)
                    .foregroundColor(Color.gray)
                Text("folders")
                    .font(.caption)
                    .foregroundColor(Color.gray)
                    .padding(.top, 80)
            }
        }
    }
}

struct StatCircle_Previews: PreviewProvider {
    static var previews: some View {
        StatCircle(title: .memory(current: 1024, total: 4096))
            .previewLayout(.sizeThatFits)
    }
}
