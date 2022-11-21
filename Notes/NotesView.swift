//
//  ContentView.swift
//  Notes
//
//  Created by Jeet Dholakia on 13/11/22.
//

import SwiftUI

struct NotesView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Hello")
            }.navigationTitle("Notes")
                .toolbar(content: {
                    ToolbarItem(content: {
                        Button("Add") {
                            print("Add button pressed")
                        }
                    })
                })
        }
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView()
    }
}
