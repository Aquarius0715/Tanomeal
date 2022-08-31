//
//  SelectShop.swift
//  tanomeal
//
//  Created by 北野正樹 on 2022/08/25.
//

import SwiftUI

struct SelectShop: View {
    let school: School
    let shops: [Shop]
    let mailAddress: String
    
    @State private var toOrderPage = false
    
    init(school: School, shops: [Shop], mailAddress: String) {
        self.school = school
        self.shops = shops
        self.mailAddress = mailAddress
        UITableView.appearance().backgroundColor = .systemYellow
    }
    
    var body: some View {
        List {
            ForEach(0 ..< school.stores.count, id: \.self) {index in
                HStack {
                    Text(shops[index].name)
                    NavigationLink(destination: OrderPage(shop: shops[index], school: school, store: school.stores[index], mailAddress: mailAddress)) {
                        EmptyView()
                    }
                    .navigationTitle("店舗一覧")
                }
            }
            .contentShape(Rectangle())
        }
    }
}

struct SelectShop_Previews: PreviewProvider {
    static var previews: some View {
        SelectShop(school: School(name: "", domains: [], stores: []), shops: [], mailAddress: "")
    }
}
