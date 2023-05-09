//
//  ContentView.swift
//  do,catch and try
//
//  Created by Dip Dutt on 6/3/23.
//

import SwiftUI

// do
// catch
// throws


class doCatchTryThrowManager {
    
    let istittle:Bool = true
    
    func showTitle() throws-> String {
        
//        if istittle {
//            return "New Text is here"
//        }
        //else {
            throw URLError(.badURL)
        //}
    }
    
    func showTitle2() throws-> String {
        
        if istittle {
            return "Final Text is here "
        }
        else {
            throw URLError(.badURL)
        }
    }
}



class doCatchTryThrowViewModel: ObservableObject  {
    
    @Published var title:String = "Old Text"
    let manager = doCatchTryThrowManager()
    
    
    func fetchNewTitle() {
        do {
            let newTitle =  try? manager.showTitle()
            if let newTitle = newTitle {
                self.title = newTitle
            }
            let newTitle2 =  try manager.showTitle2()
            self.title = newTitle2
            
            
        } catch {
            self.title = error.localizedDescription
        }
    }
    
}


struct ContentView: View {
    @StateObject var viewModel = doCatchTryThrowViewModel()
    var body: some View {
        VStack {
            Text(viewModel.title)
                .frame(width: 300, height: 300)
                .background(Color.yellow)
                .onTapGesture {
                    viewModel.fetchNewTitle()
                }
               
            
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
