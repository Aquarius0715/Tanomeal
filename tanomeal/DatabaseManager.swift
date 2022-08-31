//
//  DatabaseManager.swift
//  tanomeal
//
//  Created by 北野正樹 on 2022/08/13.
//

import Foundation
import FirebaseFirestore

struct SchoolRegacy {
    var name: String
    var domains: [String]
}

struct School {
    var name: String
    var domains: [String]
    var stores: [String]
}

struct ShopLegacy {
    var name: String
    var menu: [MenuLegacy]
}

struct Shop {
    var name: String
    var menu: [Menu]
}

struct MenuLegacy {
    var name: String
    var price: Int
}

struct Menu {
    var name: String
    var price: Int
    var enable: Bool
}

struct Order {
    var mailAddress: String
    var grade: Int
    var sex: String
    var items: [String : Int]
    var orderDate: Date
    var acceptDate: Date
    var acceptFlag: Bool
}

struct DatabaseManager {
    let db = Firestore.firestore()
    func isAllowDomain(domain: String) -> Bool {
        let semaphore = DispatchSemaphore(value: 0)
        var isAllowDomain: Bool = false
        db.collection("test-schools")
            .whereField("domain", arrayContains: domain)
            .getDocuments(source: .default) { (QuerySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                }
                if QuerySnapshot?.isEmpty == true {
                    isAllowDomain = false
                } else {
                    isAllowDomain = true
                }
                semaphore.signal()
            }
        semaphore.wait()
        return isAllowDomain
    }
    func isAllowDomainLegacy(domain: String) -> Bool {
        let semaphore = DispatchSemaphore(value: 0)
        var isAllowDomain: Bool = false
        db.collection("schools")
        .whereField("domain", arrayContains: domain)
        .getDocuments(source: .default) { (QuerySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            }
            if QuerySnapshot?.isEmpty == true {
                isAllowDomain = false
            } else {
                isAllowDomain = true
            }
            semaphore.signal()
        }
        semaphore.wait()
        return isAllowDomain
    }
    func getSchool(domain: String) -> School {
        let semaphore = DispatchSemaphore(value: 0)
        var school: School = School(name: "", domains: [], stores: [])
        db.collection("test-schools")
            .whereField("domain", arrayContains: domain)
            .getDocuments(source: .default) { (QuerySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    if let docs = QuerySnapshot?.documents {
                        for doc in docs {
                            guard let domains: [String] = doc.get("domain") as? [String],
                                  let name: String = doc.get("name") as? String,
                                  let stores: [String] = doc.get("stores") as? [String] else {
                                continue
                            }
                            school = School(name: name, domains: domains, stores: stores)
                        }
                    }
                }
                semaphore.signal()
            }
        semaphore.wait()
        print(school)
        return school
    }
    func getSchoolLegacy(domain: String) -> SchoolRegacy {
        let semaphore = DispatchSemaphore(value: 0)
        var school: SchoolRegacy = SchoolRegacy(name: "", domains: [])
        db.collection("schools")
        .whereField("domain", arrayContains: domain)
        .getDocuments(source: .default) { (QuerySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                if let documents = QuerySnapshot?.documents {
                    for document in documents {
                        guard let domains: [String] = document.get("domain") as? [String] else {
                            continue
                        }
                        guard let name = document.get("name") as? String else {
                            continue
                        }
                        school = SchoolRegacy(name: name, domains: domains)
                    }
                }
            }
            semaphore.signal()
        }
        semaphore.wait()
        return school
    }
    func getShops(school: School) -> [Shop] {
        let semaphore = DispatchSemaphore(value: 0)
        var shops: [Shop] = []
        for store in school.stores {
            var menus: [Menu] = []
            db.collection("\(store)/menus")
                .getDocuments(source: .default) { (QuerySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        if let docs = QuerySnapshot?.documents {
                            for doc in docs {
                                guard let name: String = doc.documentID as String?,
                                      let price: Int = doc.get("price") as? Int,
                                      let enable: Bool = doc.get("enable") as? Bool else {
                                    print("cannot cast value1")
                                    continue
                                }
                                let menu = Menu(name: name, price: price, enable: enable)
                                menus.append(menu)
                            }
                        }
                    }
                    semaphore.signal()
                }
            semaphore.wait()
            db.collection("test-stores")
                .getDocuments(source: .default) { (QuerySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        if let docs = QuerySnapshot?.documents {
                            for doc in docs {
                                guard let name: String = doc.get("name") as? String else {
                                    print("cannot cast value2")
                                    continue
                                }
                                let shop = Shop(name: name, menu: menus)
                                shops.append(shop)
                            }
                        }
                    }
                    semaphore.signal()
                }
            semaphore.wait()
        }
        print(shops)
        return shops
    }
    func getShopsLegacy(school: SchoolRegacy) -> [ShopLegacy] {
        let semaphore = DispatchSemaphore(value: 0)
        var shops: [ShopLegacy] = []
        db.collection("schools")
            .whereField("name", isEqualTo: school.name)
            .getDocuments(source: .default) { (QuerySnapshot, error) in
            if let docs1 = QuerySnapshot?.documents {
                for doc1 in docs1 {
                    db.collection("schools").document(doc1.documentID)
                        .collection("stores")
                        .getDocuments(source: .default) { QuerySnapshot, error in
                        if let docs2 = QuerySnapshot?.documents {
                            for doc2 in docs2 {
                                guard let menuDicList: [[String : Any]] = doc2.get("menu") as? [[String : Any]] else {
                                    continue
                                }
                                print(menuDicList)
                                var menus: [MenuLegacy] = []
                                for menuDic in menuDicList {
                                    guard let name = menuDic["name"] as? String,
                                          let price = menuDic["price"] as? Int else {
                                        continue
                                    }
                                    let menu = MenuLegacy(name: name, price: price)
                                    menus.append(menu)
                                }
                                guard let name = doc2.get("name") as? String else {
                                    continue
                                }
                                let shop = ShopLegacy(name: name, menu: menus)
                                shops.append(shop)
                            }
                        }
                    }
                }
            }
            semaphore.signal()
        }
        semaphore.wait()
        return shops
    }
    func getOrders(mailAddress: String, currentDate: Date, school: School) -> [Order] {
        let semaphore = DispatchSemaphore(value: 0)
        var ordersList: [Order] = []
        for store in school.stores {
            db.collection("\(store)/orders")
                .getDocuments(source: .default) { (QuerySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        if let docs = QuerySnapshot?.documents {
                            for doc in docs {
                                guard let id: String = doc.documentID as String?,
                                      let items: [String : Int] = doc.get("items") as? [String : Int],
                                      let orderDate: Date = doc.get("order_date") as? Date else {
                                        continue
                                }
                                ordersList.append(Order(mailAddress: id, grade: 0, sex: "未選択", items: items, orderDate: orderDate, acceptDate: orderDate, acceptFlag: false))
                            }
                        }
                    }
                }
            }
        semaphore.signal()
        semaphore.wait()
        return ordersList;
        }

    func setOrder(order: Order, store: String) -> String {
        let semaphore = DispatchSemaphore(value: 0)
        let ref = db.collection("\(store)/orders")
            .addDocument(data: [
                "mail_address" : order.mailAddress,
                "grade" : order.grade,
                "sex" : order.sex,
                "items" : order.items,
                "order_date" : order.orderDate,
                "accept_date" : order.acceptDate,
                "accept_flag" : order.acceptFlag
            ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            }
            semaphore.signal()
        }
        semaphore.wait()
            return ref.documentID
    }
}

