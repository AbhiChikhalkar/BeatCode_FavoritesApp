//
//  AddEditPersonView.swift
//  BeatCode
//
//  Created by Abhishek Chikhalkar on 01/07/25.
//


import SwiftUI

struct AddEditPersonView: View {
    @ObservedObject var viewModel: PeopleViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String
    @State private var details: String
    @State private var dob: Date
    @State private var sex: String
    @State private var contact: String
    @State private var experience: Int
    @State private var skills: String
    @State private var showingAlert = false
    @State private var errorMessage = ""
    
    private var editingPerson: Person?
    
    init(viewModel: PeopleViewModel) {
        self.viewModel = viewModel
        _name = State(initialValue: "")
        _details = State(initialValue: "")
        _dob = State(initialValue: Date())
        _sex = State(initialValue: "Male")
        _contact = State(initialValue: "")
        _experience = State(initialValue: 0)
        _skills = State(initialValue: "")
        self.editingPerson = nil
    }
    
    init(viewModel: PeopleViewModel, person: Person) {
        self.viewModel = viewModel
        _name = State(initialValue: person.name)
        _details = State(initialValue: person.details)
        _dob = State(initialValue: person.dob)
        _sex = State(initialValue: person.sex)
        _contact = State(initialValue: person.contact)
        _experience = State(initialValue: person.experience)
        _skills = State(initialValue: person.skills.joined(separator: ", "))
        self.editingPerson = person
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Basic Info") {
                    TextField("Name", text: $name)
                    TextField("Details", text: $details)
                    DatePicker("Date of Birth", selection: $dob, displayedComponents: .date)
                    Picker("Sex", selection: $sex) {
                        Text("Male").tag("Male")
                        Text("Female").tag("Female")
                        Text("Other").tag("Other")
                    }
                }
                
                Section("Professional Info") {
                    TextField("Contact", text: $contact)
                    Stepper("Experience: \(experience) years", value: $experience, in: 0...50)
                    TextField("Skills (comma separated)", text: $skills)
                }
                
                Section {
                    Button("Save") {
                        save()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .alert("Error", isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .navigationTitle(editingPerson == nil ? "Add Person" : "Edit Person")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
    
    private func save() {
        // Validate inputs
        if name.isEmpty {
            errorMessage = "Name cannot be empty"
            showingAlert = true
            return
        }
        
        if details.isEmpty {
            errorMessage = "Details cannot be empty"
            showingAlert = true
            return
        }
        
        let skillArray = skills.components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        
        if let editingPerson = editingPerson {
            viewModel.updatePerson(
                id: editingPerson.id,
                name: name,
                details: details,
                dob: dob,
                sex: sex,
                contact: contact,
                experience: experience,
                skills: skillArray
            )
        } else {
            viewModel.addPerson(
                name: name,
                details: details,
                dob: dob,
                sex: sex,
                contact: contact,
                experience: experience,
                skills: skillArray
            )
        }
        dismiss()
    }
}

struct AddEditPersonView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = PeopleViewModel()
        
        Group {
            AddEditPersonView(viewModel: viewModel)
            AddEditPersonView(viewModel: viewModel, person: viewModel.people[0])
        }
    }
}
