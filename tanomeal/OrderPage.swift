//
//  OrderPage.swift
//  tanomeal
//
//  Created by 北野正樹 on 2022/08/27.
//

import SwiftUI

struct OrderPage: View {
    let shop: Shop
    let school: School
    let store: String
    let mailAddress: String
    
    init(shop: Shop, school: School, store: String, mailAddress: String) {
        self.shop = shop;
        self.school = school
        self.store = store
        self.mailAddress = mailAddress
        UITableView.appearance().backgroundColor = .systemYellow
    }
    
    @State private var goPurchasePage = false
        
    @State private var cart: [Menu] = []
    
    var body: some View {
        NavigationLink(destination: PurchasePage(cartList: cart, school: school, store: store, mailAddress: mailAddress), isActive: $goPurchasePage) {
            EmptyView()
        }
        ZStack {
            Color.yellow
                .ignoresSafeArea()
            VStack {
                Text(" add to cart <- swipe -> remove from cart ")
                Button(action: {
                    goPurchasePage.toggle()
                }) {
                    HStack {
                        Text("カート ")
                        Image(systemName: "cart.fill")
                        Text(" \(cart.count)個のアイテム")
                    }
                }
                List {
                    let menus = shop.menu
                    ForEach(0 ..< menus.count, id: \.self) { index in
                        if menus[index].enable {
                            HStack {
                                Image("NoImage")
                                    .resizable()
                                    .frame(width: 128, height: 128)
                                Text("\(menus[index].name) \(menus[index].price)円")
                            }
                            .swipeActions(edge: .trailing) {
                                Button(action: {
                                    if let cartIndex = cart.firstIndex(where: { $0.name == menus[index].name }) {
                                        cart.remove(at: cartIndex)
                                    }
                                }) {
                                    Image(systemName: "cart.fill.badge.minus")
                                }
                                .tint(.red)
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    cart.append(menus[index])
                                } label: {
                                    Image(systemName: "cart.fill.badge.plus")
                                }.tint(.green)
                            }
                        }
                    }
                }
            }
            .navigationTitle(shop.name)
            .toolbar {
                ToolbarItem(placement: .bottomBar){
                    Button(action: {
                        goPurchasePage.toggle()
                    }) {
                        HStack {
                            Text("カート ")
                            Image(systemName: "cart.fill")
                            Text(" \(cart.count)個のアイテム")
                        }
                    }
                }
            }
        }
    }
}

struct OrderPage_Previews: PreviewProvider {
    static var previews: some View {
        OrderPage(shop: Shop(name: "", menu: []), school: School(name: "", domains: [], stores: []), store: "", mailAddress: "")
    }
}
