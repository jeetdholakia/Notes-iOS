//
//  NotesViewModel.swift
//  Notes
//
//  Created by Jeet Dholakia on 14/11/22.
//

import Foundation


class NotesViewModel: ObservableObject {
    
    @Published var notes = [Note]()
    
    @MainActor
    func fetchNotes() async throws{
        let notesUrlString = Constants.baseURL
        do {
            if let url = URL(string: notesUrlString) {
                let (data, response) = try await URLSession.shared.data(from: url)
                
                guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode <= 299 else {
                    print("Error with response")
                    return
                }
                let decoder = JSONDecoder()
                guard let notes = try? decoder.decode([Note].self, from: data) else {
                    print("Error with decoding")
                    return
                }
//                print(notes)
                self.notes = notes
            }
        } catch {
            throw error
        }
    }
    
    @MainActor
    func deleteNote(id: String) async throws{
        let notesUrlString = "\(Constants.baseURL)/\(id)"
        do {
            var request = URLRequest(url: URL(string: notesUrlString)!)
            request.httpMethod = "DELETE"
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode <= 299 else {
                print("Error with response")
                return
            }
            
            var selectedIndex = 0
            self.notes.enumerated().forEach { index, note in
                if(note.id == id) {
                    print("Matching note found!")
                    selectedIndex = index
                }
            }
            self.notes.remove(at: selectedIndex)
        } catch {
            throw error
        }
    }
}
