//
//  PurchasePage.swift
//  tanomeal
//
//  Created by 北野正樹 on 2022/08/28.
//

import SwiftUI
import PassKit

struct OrderInfo {
    var name: String
    var count: Int
}

struct PurchasePage: View {
    
    let cartList: [Menu]
    let school: School
    let store: String
    let mailAddress: String
    
    private var orderInfos: [OrderInfo] = []
    private var data: [String : Int] = [:]
    private var price: Int = 0
    
    @State private var goConfirmOrder = false
    @State private var orderId = ""
    @State private var order: Order = Order(mailAddress: "", grade: 0, sex: "未選択", items: [:], orderDate: Date(), acceptDate: Date(), acceptFlag: false)
    
    init(cartList: [Menu], school: School, store: String, mailAddress: String) {
        self.cartList = cartList
        self.school = school
        self.store = store
        self.mailAddress = mailAddress
        for menu in cartList {
            price += menu.price
            if let orderInfoIndex = orderInfos.firstIndex(where: {$0.name == menu.name }) {
                orderInfos[orderInfoIndex].count += 1
                data[menu.name]! += 1
            } else {
                orderInfos.append(OrderInfo(name: menu.name, count: 1))
                data[menu.name] = 1
            }
        }
        UITableView.appearance().backgroundColor = .systemYellow
    }
    
    var body: some View {
        NavigationLink(destination: ConfirmOrder(school: school, mailAddress: mailAddress, orderId: orderId, order: Order(mailAddress: "", grade: 0, sex: "未選択", items: [:], orderDate: Date(), acceptDate: Date(), acceptFlag: false)), isActive: $goConfirmOrder) {
            EmptyView()
            
        }
        ZStack {
            Color.yellow.ignoresSafeArea()
            VStack {
                VStack {
                    Text("合計金額: \(price)円")
                        .bold()
                        .font(.system(size: 24))
                    Button(action: {
                        if !data.isEmpty {
                            DispatchQueue.global().async {
                                order = Order(mailAddress: mailAddress, grade: 0, sex: "未選択", items: data, orderDate: Date(), acceptDate: Date(), acceptFlag: false)
                                orderId = DatabaseManager().setOrder(order: order, store: store)
                            }
                            goConfirmOrder.toggle()
                        }
                    }, label: { EmptyView() })
                    .buttonStyle(PaymentButtonStyle())
                    Spacer().frame(height: 10)
                }
                List {
                    ForEach(0 ..< orderInfos.count, id: \.self) { index in
                        Text("\(orderInfos[index].name) \(orderInfos[index].count)個")
                    }
                }
            }
        }
        .navigationTitle("カート確認")
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                VStack {
                    Text("合計金額: \(price)円")
                        .bold()
                        .font(.system(size: 24))
                    Button(action: {
                        if !data.isEmpty {
                            DispatchQueue.global().async {
                                order = Order(mailAddress: mailAddress, grade: 0, sex: "未選択", items: data, orderDate: Date(), acceptDate: Date(), acceptFlag: false)
                                orderId = DatabaseManager().setOrder(order: order, store: store)
                            }
                            goConfirmOrder.toggle()
                        }
                    }, label: { EmptyView() })
                    .buttonStyle(PaymentButtonStyle())
                    Spacer().frame(height: 10)
                }
            }
        }
    }
}

struct PaymentButton: View {
    var body: some View {
        Button(action: {
            /* Your custom payment code here */
        }, label: { EmptyView() } )
            .buttonStyle(PaymentButtonStyle())
    }
}
struct PaymentButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        return PaymentButtonHelper()
    }
}
struct PaymentButtonHelper: View {
    var body: some View {
        PaymentButtonRepresentable()
            .frame(minWidth: 100, maxWidth: 400)
            .frame(height: 60)
            .frame(maxWidth: .infinity)
    }
}
extension PaymentButtonHelper {
    struct PaymentButtonRepresentable: UIViewRepresentable {
     
        var button: PKPaymentButton {
            let button = PKPaymentButton(paymentButtonType: .plain, paymentButtonStyle: .black)
            button.cornerRadius = 4.0
            return button
        }
     
        func makeUIView(context: Context) -> PKPaymentButton {
            return button
        }
        func updateUIView(_ uiView: PKPaymentButton, context: Context) { }
    }
}


struct PurchasePage_Previews: PreviewProvider {
    static var previews: some View {
        PurchasePage(cartList: [], school: School(name: "", domains: [], stores: []), store: "", mailAddress: "")
    }
}
