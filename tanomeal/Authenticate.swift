//
//  Authenticate.swift
//  tanomeal
//
//  Created by 北野正樹 on 2022/08/08.
//

import SwiftUI

struct Authenticate: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.yellow
                    .ignoresSafeArea()
                VStack {
                    Text("たのみ〜るへようこそ！")
                        .bold()
                        .font(.largeTitle)
                    NavigationLink(destination: Login()) {
                        Text("ログイン")
                            .bold()
                            .padding()
                            .frame(width: 300, height: 50)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                            .cornerRadius(25)
                    }
                    NavigationLink(destination: Resister()) {
                        Text("登録")
                            .bold()
                            .padding()
                            .frame(width: 300, height: 50)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                            .cornerRadius(25)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct Autenticate_Previews: PreviewProvider {
    static var previews: some View {
        Authenticate()
    }
}
