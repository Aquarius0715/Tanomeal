//
//  Authenticate.swift
//  tanomeal
//
//  Created by 北野正樹 on 2022/08/08.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct Resister: View {
    @State private var mailAddress = ""
    @State private var password = ""
    @State private var passwordConfirm = ""
    
    @State private var isShowAlert = false
    @State private var isError = false
    @State private var errorMessage = ""

    @State private var isActiveAuthenticate = false
    
    @State private var schoolDoc: [QueryDocumentSnapshot]? = nil
    
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        ZStack {
            Color.yellow
                .ignoresSafeArea()
            HStack {
                Spacer().frame(width: 50)
                VStack {
                    Text("高専機構または各高専のアドレス")
                    TextField("メールアドレス", text: $mailAddress)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                    Text("パスワードは６文字以上")
                    SecureField("パスワード", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                    Text("確認のためもう一度入力")
                    SecureField("パスワード確認", text: $passwordConfirm)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                    Button(action: {
                        DispatchQueue.global().async {
                            if self.mailAddress.isEmpty {
                                self.errorMessage = "メールアドレスが入力されていません"
                                self.isError = true
                                self.isShowAlert = true
                            } else if self.password.isEmpty {
                                self.errorMessage = "パスワードが入力されていません"
                                self.isError = true
                                self.isShowAlert = true
                            } else if self.passwordConfirm.isEmpty {
                                self.errorMessage = "確認パスワードが入力されていません"
                                self.isError = true
                                self.isShowAlert = true
                            } else if DatabaseManager().isAllowDomain(domain: TanomealUtilities().getDomain(mailAddress: mailAddress)) == false {
                                self.errorMessage = "高専機構・各高専のメールアドレスを使用してください"
                                self.isError = true
                                self.isShowAlert = true
                            } else {
                                self.signUp()
                            }
                        }
                    }) {
                        Text("ユーザー登録")
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
                        } else {
                            self.presentation.wrappedValue.dismiss()
                            return Alert(title: Text(""), message: Text("登録しました"), dismissButton: .default(Text("OK")))
                        }
                    }
                }
                Spacer().frame(width: 50)
            }
        }
    }
    private func signUp() {
        Auth.auth().createUser(withEmail: self.mailAddress, password: self.password) { authResult, error in
            if let error = error as NSError?, let errorCode = AuthErrorCode.Code(rawValue: error.code) {
                switch errorCode {
                case .invalidEmail:
                    self.errorMessage = "メールアドレスの形式が正しくありません"
                case .emailAlreadyInUse:
                    self.errorMessage = "このメールアドレスは既に登録されています"
                case .weakPassword:
                    self.errorMessage = "パスワードは６文字以上で入力してください"
                default:
                    self.errorMessage = error.domain
                }
                self.isError = true
                self.isShowAlert = true
            }
            if let user = authResult?.user {
                self.isError = false
                self.isShowAlert = true
                user.sendEmailVerification(completion: { error in
                    if error == nil {
                        print("sned mail success.")
                    }
                })
            }
        }
    }
}

struct Resister_Previews: PreviewProvider {
    static var previews: some View {
        Resister()
    }
}
