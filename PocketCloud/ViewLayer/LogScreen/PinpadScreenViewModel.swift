//
//  PinpadScreenViewModel.swift
//  PocketCloud
//
//  Created by Михаил Щербаков on 14.04.2023.
//

import SwiftUI
import Combine
import Foundation
import LocalAuthentication
import SwiftKeychainWrapper

enum BiometricType {
    case none
    case face
    case touch
    case credentialsNotSaved
}

enum AuthentificationError: Error, LocalizedError, Identifiable {
    case invalidPin
    case deniedAccess
    case noFaceIDEnroller
    case noFingerprintEnrolled
    case biometricError
    case credentialsNotSaved
    
    var id: String {
        self.localizedDescription
    }
    
    var errorDescription: String? {
        switch self {
        case .invalidPin:
            return NSLocalizedString("Bad confirmation code", comment: "")
        case .deniedAccess:
            return NSLocalizedString("You have denied access. Please go to the settings app and locate this application to turn Face ID on", comment: "")
        case .noFaceIDEnroller:
            return NSLocalizedString("You have not registered Face ID yet", comment: "")
        case .noFingerprintEnrolled:
            return NSLocalizedString("You have not registered fingerprint yet", comment: "")
        case .biometricError:
            return NSLocalizedString("Your face or fingerprint were not recognized", comment: "")
        case .credentialsNotSaved:
            return NSLocalizedString("Your credentials not saved", comment: "")
        }
    }
}

class PinpadScreenViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    
    /// Lock Screen
    @AppStorage("locked") private var locked: Bool = false
    @Published var isAuthorized: Bool = false
    @Published var loading: Bool = false
    
    @KeyChain(key: "pin", account: "PinCode") var pinCodeData
    
    init() {
        
    }
    
    //MARK: Biometrics
    
    func unlock() {
        withAnimation {
            UserDefaults.standard.set(false, forKey: "locked")
            // KeychainStorage.saveCredentials(Credentials) <-- for save credentials in keychain
        }
    }
    
    func lock() {
        UserDefaults.standard.set(true, forKey: "locked")
    }
    
    func biometricType() -> BiometricType {
        let authContext = LAContext()
        let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch authContext.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touch
        case .faceID:
            return .face
        @unknown default:
            return .none
        }
    }
    
    func requestBiometricUnlock(completion: @escaping (Result<String, AuthentificationError>) -> Void) {

        guard let pincodeData = pinCodeData else {
            completion(.failure(.credentialsNotSaved))
            return
        }
        let context = LAContext()
        var error: NSError?
        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        if let error = error {
            switch error.code {
            case -6:
                completion(.failure(.deniedAccess))
            case -7:
                if context.biometryType == .faceID {
                    completion(.failure(.noFaceIDEnroller))
                } else {
                    completion(.failure(.noFingerprintEnrolled))
                }
            default:
                completion(.failure(.biometricError))
            }
            return
        }
        if canEvaluate {
            if context.biometryType != .none {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Need to access pin") { success, error in
                    DispatchQueue.main.async {
                        if error != nil {
                            completion(.failure(.biometricError))
                        } else {
                            completion(.success(String(data: pincodeData, encoding: .utf8) ?? ""))
                        }
                    }
                }
            }
        }

    }
}

