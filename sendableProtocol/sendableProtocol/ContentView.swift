//
//  ContentView.swift
//  sendableProtocol
//
//  Created by Dip Dutt on 21/3/23.
//

import SwiftUI

actor dataManager {
    
    func updateDatabase(userInfo:myinfo) {
        
    }
    
}

struct myInfo:Sendable {
    var name:String
}

 final class myinfo: @unchecked Sendable {
    var name:String
     let lock = DispatchQueue(label: "myapp.name.myinfo")
    init(name: String) {
        self.name = name
        func updateName(Name:String) {
                lock.async {
                    self.name = Name
        }
    }
  }
}


class sendableViewModel:ObservableObject {
    let manager = dataManager()
    
    func updateCurrentUserInfo() async {
        let info = myinfo(name: "info")
         await manager.updateDatabase(userInfo: info)
    }
    
}

struct ContentView: View {
    @StateObject var viewModel = sendableViewModel()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .task {
             
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
