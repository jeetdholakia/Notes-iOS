//
//  NoteDetailView.swift
//  Notes
//
//  Created by Jeet Dholakia on 20/11/22.
//

import SwiftUI

enum Field: Int, Hashable {
    case textEditor
}

struct NoteDetailView: View {
    @Binding var isPresented: Bool
    @ObservedObject var notesViewModel: NotesViewModel
    @State private var content = "Hello, note"
    @State private var isFocused = true
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $content)
                    .padding(.all)
                    .focused($focusedField, equals: .textEditor)
                    
            }.onAppear {
                focusedField = .textEditor
            }
            .navigationTitle("Notes")
                .toolbar(content: {
                    ToolbarItem(content: {
                        Button("Done") {
                            Task {
                                do {
                                    try await notesViewModel.addNote(note: content)
                                } catch {
                                    
                                }
                            }
                           
                            self.isPresented.toggle()
                        }
                    })
                })
        }
    }
}

struct NoteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NoteDetailView(isPresented: .constant(true), notesViewModel: NotesViewModel())
    }
}
