//
//  ContentView.swift
//  Notes
//
//  Created by Jeet Dholakia on 13/11/22.
//

import SwiftUI

struct NotesView: View {
    
    @StateObject var notesViewModel = NotesViewModel()
    @State private var showingAlert = false
    @State private var selectedNoteId = "0"
    
    var body: some View {
        NavigationView {
            VStack {
                List(notesViewModel.notes, id: \.self.id) { note in
                    Text(note.note)
                        .swipeActions(content: {
                            Button("Delete") {
                                showingAlert.toggle()
                                selectedNoteId = note.id
                            }
                        })
                }.confirmationDialog("Select a color", isPresented: $showingAlert, titleVisibility: .visible) {
                    Button("Delete") {
                        Task {
                            do {
                                try await notesViewModel.deleteNote(id: selectedNoteId)
                            } catch {
                                
                            }
                        }
                    }
                    Button("Cancel") {
                        
                    }
                }
            }.navigationTitle("Notes")
                .toolbar(content: {
                    ToolbarItem(content: {
                        Button("Add") {
                            print("Add button pressed")
                        }
                    })
                })
        }.task {
            do {
                try await notesViewModel.fetchNotes()
            } catch {
                
            }
        }
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView()
    }
}
