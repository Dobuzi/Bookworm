//
//  AddBookView.swift
//  Bookworm
//
//  Created by 김종원 on 2020/10/29.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating: Int16 = 3
    @State private var genre = ""
    @State private var review = ""
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section {
                    RatingView(rating: $rating)
                    TextField("Write a review", text: $review)
                }
                
                Section {
                    Button("Save") {
                        addBook()
                        
                    }
                }
            }
            .navigationBarTitle("Add Book")
        }
    }
    
    func addBook() {
        let newBook = Book(context: self.viewContext)
        
        newBook.title = self.title
        newBook.author = self.author
        newBook.genre = self.genre == "" ? "Fantasy" : self.genre
        
        newBook.rating = Int16(self.rating)
        newBook.review = self.review
        newBook.date = Date()
        
        try? self.viewContext.save()
        self.presentationMode.wrappedValue.dismiss()
    }
}
