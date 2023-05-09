//
//  ContentView.swift
//  useAsync&Await
//
//  Created by Dip Dutt on 13/3/23.
//

import SwiftUI


class asynawaitModel:ObservableObject {
    @Published var dataArray:[String] = []
    
    func addTittle1() {
        self.dataArray.append("tittle1.\(Thread.current)")
    }
    
    func addTittle2() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
            let tittle = "Tittle2.\(Thread.current)"
            DispatchQueue.main.async {
                self.dataArray.append(tittle)
            }
        }
    }
    
    func author1() async {
        let author = "Author.\(Thread())"
        self.dataArray.append(author)
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        let author2 = "Author2.\(Thread())"
        await MainActor.run {
            self.dataArray.append(author2)
        }
        
        let author3 = "Author3.\(Thread())"
        self.dataArray.append(author3)
        
         await addSomething()
        
    }
    
    
    func addSomething() async {
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        let Something1 = "Something 1.\(Thread())"
        await MainActor.run {
            self.dataArray.append(Something1)
        }
        
        let something2 = "something2.\(Thread())"
        self.dataArray.append(something2)
        
    }
}

struct ContentView: View {
    @StateObject var viewModel = asynawaitModel()
    var body: some View {
        List {
            ForEach(viewModel.dataArray, id: \.self) { data in
                Text(data)
            }
        }
        .task {
            await viewModel.author1()
        }
//        .onAppear {
//
//           Task {
//                 await viewModel.author1()
//            }
           //viewModel.addTittle1()
           //viewModel.addTittle2()
        }
    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
