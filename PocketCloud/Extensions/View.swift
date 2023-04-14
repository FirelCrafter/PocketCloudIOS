//
//  View.swift
//  PocketCloud
//
//  Created by Михаил Щербаков on 13.04.2023.
//

import SwiftUI

extension View {
    ///Makes view on left border
    func hLeading() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    ///Makes view on right border
    func hTrailing() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    ///Makes view on center
    func hCenter() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    ///Makes view on top border
    func vTop() -> some View {
        self
            .frame(maxHeight: .infinity, alignment: .top)
    }
    
    ///Makes view on bottom border
    func vBottom() -> some View {
        self
            .frame(maxHeight: .infinity, alignment: .bottom)
    }
    
    ///Makes view on cemter (vertical)
    func vCenter() -> some View {
        self
            .frame(maxHeight: .infinity, alignment: .center)
    }
    
    func getSafeArea() -> UIEdgeInsets {
        
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        
        return safeArea
        
    }
    
    /// Gets screen bouds
    func screenBounds() -> CGRect {
        return UIScreen.main.bounds
    }
}
