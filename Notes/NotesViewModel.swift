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
    
    @MainActor
    func addNote(note: String) async throws{
        let params = ["note" : note] as [String : Any]
        let notesUrlString = "\(Constants.baseURL)"
        do {
            var request = URLRequest(url: URL(string: notesUrlString)!)
            request.httpMethod = "POST"
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode <= 299 else {
                print("Error with response")
                return
            }
            
            let decoder = JSONDecoder()
            guard let note = try? decoder.decode(Note.self, from: data) else {
                print("Error with decoding")
                return
            }
            self.notes.append(note)
        } catch {
            throw error
        }
    }
    
    @MainActor
    func updateNote(id:String, note:String) async throws {
        let params = ["note" : note] as [String : Any]
        let url = URL(string: "\(Constants.baseURL)/\(id)")!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        }
        catch let error {
            print(error)
            throw error
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: request) { data, res, err in
            guard err == nil else { return }
            guard let data = data else { return }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                }
            }
            catch let error {
                print(error)
            }
        }
        
        task.resume()
        
        if let index = notes.firstIndex(where: {$0.id == id}) {
            notes[index].note = note
        }
    }
}
