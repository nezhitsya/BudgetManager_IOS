//
//  AccountDetailView.swift
//  Budget_Manager
//
//  Created by 이다영 on 2021/05/28.
//

import SwiftUI

struct AccountDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var account: Account
    @State var showEdit = false
    
    var body: some View {
        List {
            HStack {
                Text("Balance")
                Spacer()
                Text("$ \(account.balance)")
            }
            
            Section {
                Text("Category : \(account.category)")
                Text("Description : \(account.description)")
                Text("Wealth Description : \(account.wealth_type)")
            }
            
            Section {
                Button(action: { self.deleteAccount() }, label: {
                    HStack {
                        Image(systemName: "trash")
                        Text("Delete")
                    }
                })
            }
        }.listStyle(GroupedListStyle())
        .navigationTitle(account.name)
        .navigationBarItems(trailing: Button(action: { self.showEdit.toggle() }, label: {
            Text("Edit").sheet(isPresented: $showEdit, content: {
                EditView(account: $account)
            })
        }))
    }
    
    func deleteAccount() {
        guard let url = URL(string: "http://127.0.0.1:8000/api/account/\(self.account.id)/") else {
            print("api is down")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Basic 7fc7fa9170e13197ce5f9ded49dd12dd9e538eb6=", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    print("\(data)")
                    self.presentationMode.wrappedValue.dismiss()
                }
                return
            }
        }.resume()
    }
}

struct AccountDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AccountDetailView(account: Account(id: 0, name: "Stock", category: "Accet", description: "Blah", wealth_type: "Wealth Building", balance: 0, created_at: ""))
    }
}
