//
//  Settings.swift
//  tanomeal
//
//  Created by 北野正樹 on 2022/08/20.
//

import SwiftUI

struct Settings: View {
    @State var toAuthenticate = false
    @State var isShowSignedOut = false
    var body: some View {
        ZStack {
            Color.yellow
                .ignoresSafeArea()
            VStack {
                NavigationLink(destination: Authenticate(), isActive: $toAuthenticate) {
                    EmptyView()
                }
                Button(action: {
                    toAuthenticate.toggle()
                    Logout().signOut()
                }) {
                    Text("ログアウト")
                        .bold()
                        .padding()
                        .frame(width: 300, height: 50)
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                        .cornerRadius(25)
                }.alert(isPresented: $isShowSignedOut) {
                    Alert(title: Text(""), message: Text("ログアウトしました"), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
