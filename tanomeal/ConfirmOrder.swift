//
//  ConfirmOrder.swift
//  tanomeal
//
//  Created by 北野正樹 on 2022/08/29.
//

import SwiftUI

struct ConfirmOrder: View {
    let school: School
    let mailAddress: String
    let orderId: String
    let order: Order
    
    @State private var goTanomealTop = false
    
    init(school: School, mailAddress: String, orderId: String, order: Order) {
        self.school = school
        self.mailAddress = mailAddress
        self.orderId = orderId
        self.order = order
    }
    
    var body: some View {
        NavigationLink(destination: TanomealTop(school: school, mailAddress: mailAddress), isActive: $goTanomealTop) {
            EmptyView()
        }
        ZStack {
            Color.yellow.ignoresSafeArea()
            VStack {
                Text(order.orderDate.description)
                Text(mailAddress.description)
                Image(uiImage: makeQRImage(orderId))
                Text("必ずQRコードをスクリーンショットしてください。")
                Button(action: {
                    goTanomealTop.toggle()
                }) {
                    Text("トップへ戻る")
                        .bold()
                        .padding()
                        .frame(width: 300, height: 50)
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                        .cornerRadius(25)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func makeQRImage(_ input: String) -> UIImage {
        let inputData = input.data(using: .utf8)!
        // NOTE:誤り訂正レベルはとりあえず「Q」を指定
        let qrFilter = CIFilter(name: "CIQRCodeGenerator",
                          parameters: ["inputMessage": inputData,
                                       "inputCorrectionLevel": "Q"])
        let ciImage = qrFilter!.outputImage!
        // NOTE: 元のCIImageは小さいので任意のサイズに拡大
        let sizeTransform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledCiImage = ciImage.transformed(by: sizeTransform)
        // NOTE: CIImageをそのまま変換するとImageで表示されないため一度CGImageに変換してからUIImageに変換する
        let context = CIContext()
        let qrCgImage = context.createCGImage(scaledCiImage, from: scaledCiImage.extent)!
        return UIImage(cgImage: qrCgImage)
    }
}

struct ConfirmOrder_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmOrder(school: School(name: "", domains: [], stores: []), mailAddress: "", orderId: "", order: Order(mailAddress: "", grade: 0, sex: "未選択", items: [:], orderDate: Date(), acceptDate: Date(), acceptFlag: false))
    }
}
