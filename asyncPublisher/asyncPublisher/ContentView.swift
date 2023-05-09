//
//  ContentView.swift
//  asyncPublisher
//
//  Created by Dip Dutt on 22/3/23.
//

import SwiftUI
import Combine

class asynPublisherDataManager {
    @Published var myData:[String] = []
    
    func addData() async {
        myData.append("Apple")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Orange")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Cherry")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Banana")
        
    }
    
}


class asynPublisherViewModel:ObservableObject {
    @Published var dataArray:[String] = []
    let manager = asynPublisherDataManager()
    var cancellable = Set<AnyCancellable>()
    
    init() {
        showdata()
    }
    
    func showdata() {
        
       Task {
           for await value in manager.$myData.values {
               await MainActor.run(body: {
                   dataArray = value
               })
           }
        }
//        manager.$myData
//            .sink { Array in
//                self.dataArray = Array
//            }
//            .store(in: &cancellable)
        
    }
    
    func start()async {
         await manager.addData()
    }
}

struct ContentView: View {
    @StateObject var viewModel = asynPublisherViewModel()
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray, id: \.self) { data in
                    Text(data)
                        .font(.headline)
                }
                
            }
            .task {
                 await viewModel.start()
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
