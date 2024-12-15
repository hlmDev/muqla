//
//  muqlaApp.swift
//  muqla
//
//  Created by Ahlam Majed on 10/12/2024.
//

import SwiftUI
import AuthenticationServices
import CloudKit

struct LoginView: View {
    @State private var isLoggedIn = false // لتحديد حالة تسجيل الدخول
    
    var body: some View {
        if isLoggedIn {
            MainTabView() // الانتقال إلى الشاشة الرئيسية بعد تسجيل الدخول
        } else {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all) // خلفية سوداء
                
                VStack {
                    // زر Skip في الأعلى
                    HStack {
                        Spacer()
                        Button(action: {
                            isLoggedIn = true // تخطي تسجيل الدخول
                        }) {
                            Text("Skip")
                                .foregroundColor(.white)
                        }
                        .padding()
                    }
                    
                    Spacer()
                    
                    // الشعار كصورة
                    Image("Logo") // اسم الصورة التي ستضيفها في المشروع
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200) // تعديل الحجم حسب الحاجة
                        .padding(.bottom, 50)
                    
                    // زر تسجيل الدخول باستخدام Apple
                    SignInWithAppleButton(.signIn, onRequest: configureSignIn, onCompletion: handleSignIn)
                        .signInWithAppleButtonStyle(.white)
                        .frame(height: 50)
                        .padding(.horizontal, 40)
                    
                    Spacer()
                }
            }
        }
    }
    
    // إعداد طلب تسجيل الدخول
    func configureSignIn(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }
    
    // معالجة النتيجة بعد تسجيل الدخول
    func handleSignIn(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                let userId = appleIDCredential.user
                let fullName = appleIDCredential.fullName
                let email = appleIDCredential.email
                
                print("User ID: \(userId)")
                print("Full Name: \(fullName?.givenName ?? "N/A") \(fullName?.familyName ?? "N/A")")
                print("Email: \(email ?? "N/A")")
                
                // تخزين بيانات المستخدم في CloudKit
                saveUserToCloudKit(userId: userId, fullName: fullName, email: email)
                
                // تسجيل الدخول بنجاح
                isLoggedIn = true
            }
        case .failure(let error):
            print("Error: \(error.localizedDescription)")
        }
    }
    
    // حفظ بيانات المستخدم في CloudKit
    func saveUserToCloudKit(userId: String, fullName: PersonNameComponents?, email: String?) {
        let container = CKContainer(identifier: "iCloud.a.muqla")
        let privateDatabase = container.privateCloudDatabase
        
        let userRecord = CKRecord(recordType: "User")
        userRecord["userId"] = userId
        userRecord["fullName"] = "\(fullName?.givenName ?? "") \(fullName?.familyName ?? "")"
        userRecord["email"] = email ?? ""
        
        privateDatabase.save(userRecord) { record, error in
            if let error = error {
                print("Error saving user data to CloudKit: \(error.localizedDescription)")
            } else {
                print("User data saved successfully to CloudKit")
            }
        }
    }
    
    func checkiCloudStatus() {
        let container = CKContainer(identifier: "iCloud.a.muqla")
        container.accountStatus { status, error in
            DispatchQueue.main.async {
                switch status {
                case .available:
                    print("iCloud is available")
                case .noAccount:
                    print("No iCloud account found")
                case .restricted:
                    print("iCloud is restricted")
                case .couldNotDetermine:
                    print("Could not determine iCloud status")
                case .temporarilyUnavailable:
                    print("iCloud temporarily unavailable")
                @unknown default:
                    print("Unknown iCloud status")
                }
            }
        }
    }
    
    // Main Tab View
    struct MainTabView: View {
        var body: some View {
            TabView {
                Text("Home Screen")
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                Text("Profile Screen")
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
            }
        }
    }
}
    // إعداد التطبيق
    
    #Preview {
        LoginView()
        // .preferredColorScheme(.dark)
    }

