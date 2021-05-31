//
//  EditView.swift
//  Budget_Manager
//
//  Created by 이다영 on 2021/05/28.
//

import SwiftUI

struct EditView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var account: Account
    
    var categories = ["Asset", "Liabilities"]
    var wealth_types = ["Wealth Building", "Non-Wealth Building"]
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Account Name", text: $account.name)
                    Picker("Category", selection: $account.category) {
                        ForEach(categories, id: \.self) {
                            Text($0)
                        }
                    }
                    TextField("Balance", value: $account.balance, formatter: NumberFormatter())
                }
                TextField("Description", text: $account.description)
                Picker("Wealth Type", selection: $account.wealth_type) {
                    ForEach(wealth_types, id: \.self) {
                        Text($0)
                    }
                }
            }.listStyle(GroupedListStyle())
            .navigationTitle(Text("Edit Account"))
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button(action: { updateAccount() }, label: {
                Text("Save")
            }))
        }
    }
    
    func updateAccount() {
        guard let url = URL(string: "http://127.0.0.1:8000/api/account/\(self.account.id)/") else {
            print("api is invalid")
            fatalError()
        }
        
        let accountData = self.account
        
        guard let encoded = try? JSONEncoder().encode(accountData) else {
            print("Failed to encode order")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/JSON", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic bGR5Olp6b3JhZW5n", forHTTPHeaderField: "Authorization")
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode(Account.self, from: data) {
                    DispatchQueue.main.async {
                        presentationMode.wrappedValue.dismiss()
                    }
                    return
                }
            }
        }.resume()
    }
}

//struct EditView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditView()
//    }
//}
