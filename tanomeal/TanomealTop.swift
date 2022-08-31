//
//  TanomealTop.swift
//  tanomeal
//
//  Created by 北野正樹 on 2022/08/09.
//

import SwiftUI
import FirebaseAuth

struct TanomealTop: View {
    @State var isShowSignedOut = false
    @State var toSettings = false
    @State var toSelectShop = false
    
    let school: School
    let mailAddress: String
    
    @State var shops: [Shop] = []
        
    var body: some View {
        NavigationView {
            ZStack {
                Color.yellow
                    .ignoresSafeArea()
                VStack {
                    NavigationLink(destination: Settings(), isActive: $toSettings) {
                        EmptyView()
                    }
                    NavigationLink(destination: SelectShop(school: school, shops: shops, mailAddress: mailAddress), isActive: $toSelectShop) {
                        EmptyView()
                    }
                    Button(action: {
                        DispatchQueue.global().async {
                            self.shops = DatabaseManager().getShops(school: school)
                        }
                        toSelectShop.toggle()
                    }) {
                        Text("注文する")
                            .bold()
                            .padding()
                            .frame(width: 300, height: 50)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                            .cornerRadius(25)
                    }
                    Button(action: {
                        DispatchQueue.global().async {
                            self.shops = DatabaseManager().getShops(school: school)
                        }
                        toSelectShop.toggle()
                    }) {
                        Text("注文を確認する(未実装)")
                            .bold()
                            .padding()
                            .frame(width: 300, height: 50)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                            .cornerRadius(25)
                    }
                    Button(action: {
                        toSettings.toggle()
                    }) {
                        Text("設定")
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

struct TanomealTop_Previews: PreviewProvider {
    static var previews: some View {
        TanomealTop(school: School(name: "", domains: [], stores: []), mailAddress: "")
    }
}
