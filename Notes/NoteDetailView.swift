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
    var isEditingMode: Bool
    @Binding var isPresented: Bool
    @State var id: String
    @State var content: String
    @ObservedObject var notesViewModel: NotesViewModel
    @State private var isFocused = true
    @FocusState private var focusedField: Field?
    @Environment(\.dismiss) var dismiss
    
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
                                    if(content != "") {
                                        if(isEditingMode) {
                                            try await notesViewModel.updateNote(id: id, note: content)
                                            dismiss()
                                        } else {
                                            try await notesViewModel.addNote(note: content)
                                            self.isPresented.toggle()
                                        }
                                    }
                                } catch {
                                    
                                }
                            }
                        }
                    })
                })
        }
    }
}

struct NoteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NoteDetailView(isEditingMode: true, isPresented: .constant(true), id: "",  content: "Hello there", notesViewModel: NotesViewModel())
    }
}
