//
//  Login.swift
//  tanomeal
//
//  Created by 北野正樹 on 2022/08/08.
//

import SwiftUI
import FirebaseAuth

struct Login: View {
    @State private var mailAddress = ""
    @State private var password = ""
    
    @State private var isShowAlert = false
    @State private var isEmailVerifid = false
    @State private var isError = false
    @State private var errorMessage = ""
    
    @State private var goTanomealTop = false
    @State private var goResister = false
    @State private var goResetPassword = false
    
    @Environment(\.presentationMode) var presentation
    
    @State private var school: School = School(name: "", domains: [], stores: [])
    
    var body: some View {
        ZStack {
            Color.yellow
                .ignoresSafeArea()
            HStack {
                Spacer().frame(width: 50)
                VStack(spacing: 16) {
                    NavigationLink(destination: TanomealTop(school: school, mailAddress: mailAddress), isActive: $goTanomealTop) {
                        EmptyView()
                    }
                    NavigationLink(destination: Resister(), isActive: $goResister) {
                        EmptyView()
                    }
                    NavigationLink(destination: ResetPassword(), isActive: $goResetPassword) {
                        EmptyView()
                    }
                    TextField("メールアドレス", text: $mailAddress).textFieldStyle(RoundedBorderTextFieldStyle())
                    SecureField("パスワード", text: $password).textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        self.errorMessage = ""
                        if self.mailAddress.isEmpty {
                            self.errorMessage = "メールアドレスが入力されていません"
                            self.isError = true
                            self.isShowAlert = true
                        } else if self.password.isEmpty {
                            self.errorMessage = "パスワードが入力されていません"
                            self.isError = true
                            self.isShowAlert = true
                        } else {
                            self.signIn()
                        }
                    }) {
                        Text("ログイン")
                            .bold()
                            .padding()
                            .frame(width: 300, height: 50)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                            .cornerRadius(25)
                    }
                    .alert(isPresented: $isShowAlert) {
                        if self.isError {
                            return Alert(title: Text(""), message: Text(self.errorMessage), dismissButton: .destructive(Text("OK"))
                            )
                        } else if !self.isEmailVerifid {
                            return Alert(title: Text(""), message: Text("メールアドレスの確認がされていません"),
                                         dismissButton: .destructive(Text("OK"))
                            )
                        } else {
                            return Alert(title: Text(""), message: Text("ログインしました"), dismissButton: .default(Text("OK")))
                        }
                    }
                    Text("登録していませんか？")
                    Button(action: {
                        goResister.toggle()
                    }) {
                        Text("登録")
                            .bold()
                            .padding()
                            .frame(width: 300, height: 50)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                            .cornerRadius(25)
                    }
                    Text("パスワードを忘れましたか？")
                    Button(action: {
                        goResetPassword.toggle()
                    }) {
                        Text("パスワード再設定")
                            .bold()
                            .padding()
                            .frame(width: 300, height: 50)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                            .cornerRadius(25)
                    }
                }
                Spacer().frame(width: 50)
            }
        }
    }
    private func signIn() {
        Auth.auth().signIn(withEmail: self.mailAddress, password: self.password) { authResult, error in
            if authResult?.user != nil {
                //self.isShowAlert = true
                self.isError = false
                if let user = authResult?.user {
                    if user.isEmailVerified {
                        DispatchQueue.global().async {
                            self.school = DatabaseManager().getSchool(domain: TanomealUtilities().getDomain(mailAddress: mailAddress))
                        }
                        self.goTanomealTop.toggle()
                        isEmailVerifid = true
                    } else {
                        isEmailVerifid = false
                        isShowAlert = true;
                    }
                }
            } else {
                self.isShowAlert = true
                self.isError = true
                if let error = error as NSError?, let errorCode = AuthErrorCode.Code(rawValue: error.code) {
                    switch errorCode {
                    case .invalidEmail:
                        self.errorMessage = "メールアドレスの形式が正しくありません"
                    case .userNotFound, .wrongPassword:
                        self.errorMessage = "メールアドレス、またはパスワードが間違っています"
                    case .userDisabled:
                        self.errorMessage = "このユーザーアカウントは無効化されています"
                    default:
                        self.errorMessage = error.domain
                    }
                    self.isError = true
                    self.isShowAlert = true
                }
            }
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
