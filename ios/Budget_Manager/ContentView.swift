//
//  ContentView.swift
//  Budget_Manager
//
//  Created by 이다영 on 2021/05/28.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @State var accounts = [Account]()
    @State var showAdd = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(accounts) { item in
                    HStack {
                        NavigationLink(destination: AccountDetailView(account: item)) {
                            Image(systemName: "banknote").foregroundColor(.green)
                            Text(item.name)
                            Spacer()
                            Text("\(item.balance)")
                        }
                    }
                }
            }.onAppear(perform: loadAccount)
            .navigationBarTitle("Accounts")
            .navigationBarItems(trailing: Button(action: {showAdd.toggle()}, label: {
                Image(systemName: "plus.circle")
            }))
            .listStyle(PlainListStyle())
            .sheet(isPresented: $showAdd, content: {
                AccountAddview(function: self.loadAccount)
            })
        }
    }
    
    func loadAccount() {
        
        guard let url = URL(string: "http://127.0.0.1:8000/api/account/") else {
            print("api is down")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Basic bGR5Olp6b3JhZW5n", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode([Account].self, from: data) {
                    DispatchQueue.main.async {
                        self.accounts = response
                    }
                    return
                }
            }
        }.resume()
    }
}

struct AccountAddview: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var function: () -> Void
    
    @State var name: String = ""
    @State var category: String = ""
    @State var description: String = ""
    @State var wealth_type: String = ""
    @State var balance: String = ""
    
    var categories = ["Asset", "Liabilities"]
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Account Name", text: $name)
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) {
                            Text($0)
                        }
                    }
                    TextField("Balance", text: $balance)
                    TextField("Wealth Type", text: $wealth_type)
                    TextField("Description", text: $description)
                }
            }.listStyle(GroupedListStyle())
            .navigationBarTitle("Add Account")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button(action: { postAccount() }, label: {
                Text("Save")
            }))
        }
    }
    
    func postAccount() {
        guard let url = URL(string: "http://127.0.0.1:8000/api/account/") else {
            print("api is down")
            return
        }
        
        let accountData = Account(id: 0, name: self.name, category: self.category, description: self.description, wealth_type: self.wealth_type, balance: Int(self.balance) ?? 0, created_at: "")
        
        guard let encoded = try? JSONEncoder().encode(accountData) else {
            print("failed to encode")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic bGR5Olp6b3JhZW5n", forHTTPHeaderField: "Authorization")
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode(Account.self, from: data) {
                    DispatchQueue.main.async {
                        self.function()
                        presentationMode.wrappedValue.dismiss()
                    }
                    return
                }
            }
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
//        ContentView(accounts: [Account(id: 0, name: "Stock", category: "Accet", description: "Blah", wealth_type: "Wealth Building", balance: 0, created_at: "")], showAdd: true)
    }
}
