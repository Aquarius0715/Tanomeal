//
//  ResetPassword.swift
//  tanomeal
//
//  Created by 北野正樹 on 2022/08/11.
//

import SwiftUI
import FirebaseAuth

struct ResetPassword: View {
    @State private var mailAddress = ""
    
    @State private var isShowAlert = false
    @State private var isError = false
    @State private var errorMessage = ""
    
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        ZStack {
            Color.yellow
                .ignoresSafeArea()
            HStack {
                Spacer().frame(width: 50)
                VStack {
                    Text("アカウントのメールアドレスを入力してください")
                    Text("メールアドレスが存在する場合、再設定用のメールが送信されます")
                    TextField("メールアドレス", text: $mailAddress).textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        if self.mailAddress.isEmpty {
                            self.errorMessage = "メールアドレスが入力されていません"
                            self.isError = true
                            self.isShowAlert = true
                        } else {
                            self.resetPassword()
                        }
                    }) {
                        Text("パスワードリセット")
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
                            return Alert(title: Text(""), message: Text("送信しました。\n受信ボックスを確認してください。"), dismissButton: .default(Text("OK")))
                        }
                    }
                }
                Spacer().frame(width: 50)
            }
        }
    }
    private func resetPassword() {
        Auth.auth().sendPasswordReset(withEmail: self.mailAddress) { error in
            if error  == nil {
                print("send password rest mail success")
                isShowAlert = true
                isError = false
            } else {
                isShowAlert = true
                isError = true
            }
        }
    }
}

struct ResetPassword_Previews: PreviewProvider {
    static var previews: some View {
        ResetPassword()
    }
}
