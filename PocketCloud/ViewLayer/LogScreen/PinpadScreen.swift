//
//  PinpadScreen.swift
//  PocketCloud
//
//  Created by Михаил Щербаков on 14.04.2023.
//

import SwiftUI

struct PinCodeButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                Circle()
                    .fill(configuration.isPressed ? Color.black : Color.clear)
            )
            .foregroundColor(configuration.isPressed ? Color.white : Color.black)
    }
}

extension View {
    func withPerssableStyle() -> some View {
        self.buttonStyle(PinCodeButtonStyle())
    }
}

struct PinpadScreen: View {
    private let pinItems: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "faceid", "0", "delete.left"]
    @State private var password = ""
    @State private var loaderVisible: Bool = false
    @State private var vm = PinpadScreenViewModel()
    @State private var errorMsg = ""
    @State private var wrongPassword = false
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            VStack {
                
                Text("Pocket Cloud")
                    .font(.title).bold()
                    .padding(.bottom, screenBounds().height/7)
                
                Text("Enter PIN")
                    .font(.title3).bold()
                
                HStack(spacing: 22) {
                    ForEach(0..<4, id: \.self) { index in
                        
                    }
                }
                
                Text(errorMsg)
                    .fontWeight(.heavy)
                    .foregroundColor(.red)
                    .padding(.vertical, 20)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 15) {
                    ForEach(pinItems, id: \.self) { item in
                        PinButton(value: item)
                    }
                }
                
            }
            .vTop()
        }
    }
    
    @ViewBuilder
    private func PinButton(value: String) -> some View {
        
        Button {
            if value == "delete.left" {
                if password.count > 0 {
                    password.removeLast()
                }
            } else if value == "faceid" {
                vm.requestBiometricUnlock { (result: Result<String, AuthentificationError>) in
                    switch result {
                    case .success(let pincode):
                        password = pincode
                        loaderVisible.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            loaderVisible.toggle()
                            UserDefaults.standard.set(false, forKey: "locked")
                            vm.navigateToMainScreen()
                        }
                    case .failure(let error):
                        errorMsg = errorMessage(msg: error.localizedDescription)
                    }
                }
            } else {
                if password.count != 4 {
                    
                    password.append(value)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation {
                            if password.count == 4 {
                                guard let pinCodeData = pinCodeData else {return}
                                if password == String(data: pinCodeData, encoding: .utf8) {
                                    loaderVisible.toggle()
                                } else {
                                     errorMsg = errorMessage(msg: "Bad confirmation code")
                                }
                            }
                        }
                    }
                }
            }
        } label: {
            if Int(value) == nil {
                if value == "faceid" {
                    Image(systemName: vm.biometricType() == .face ? value : "touchid")
                        .font(.system(size: 35))
                } else {
                    Image(systemName: value)
                        .font(.system(size: 35))
                }
            } else {
                ZStack {
                    Circle()
                        .stroke(Color.black, lineWidth: 2)
                        .frame(width: 60, height: 60)
                    Text(value)
                        .font(.system(size: 24).bold())
                }
                
            }
            
        }
        .withPerssableStyle()
        
        
    }
    
    private func limitText(_ upper: Int) {
        if password.count > upper {
            password = String(password.prefix(upper))
        }
    }
    
    private func errorMessage(msg: String) -> String {
        wrongPassword = true
        return msg
    }
    
}

struct PinpadScreen_Previews: PreviewProvider {
    static var previews: some View {
        PinpadScreen()
    }
}
