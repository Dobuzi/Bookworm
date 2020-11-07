//
//  DetailView.swift
//  Bookworm
//
//  Created by 김종원 on 2020/10/30.
//

import SwiftUI
import CoreData

struct DetailView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingDeleteAlert = false
    @State private var changingShadow = false
    @State private var reviewSizeRatio: CGFloat = 1.0
    
    let book: Book
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                ZStack(alignment: .topLeading) {
                    Image(self.book.genre ?? "Fantasy")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geo.size.width)
                    
                    Text(self.book.genre?.uppercased() ?? "FANTASY")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.5))
                        .clipShape(Capsule())
                        .offset(x: 5, y: 5)
                }
                HStack {
                    Spacer()
                    Text("Written by \(self.book.author ?? "Unknown author")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                }
                Spacer()
                Text(self.book.review ?? "No review")
                    .frame(width: geo.size.width * 0.8 * reviewSizeRatio, height: geo.size.height * 0.3 * reviewSizeRatio)
                    .padding()
                    .background(Color(red: 200, green: 200, blue: 200, opacity: 0.5))
                    .cornerRadius(15)
                    .shadow(radius: changingShadow ? 30 : 10)
                    .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                        withAnimation {
                            changingShadow.toggle()
                            if changingShadow {
                                reviewSizeRatio = 1.02
                            } else {
                                reviewSizeRatio = 1.00
                            }
                        }
                        
                    })
                Spacer()
                RatingView(rating: .constant(Int16(self.book.rating)))
                    .font(.title)
                
                Text(self.formatDate(date: self.book.date!))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
        .navigationBarTitle(Text(book.title ?? "Unknown Book"), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            self.showingDeleteAlert = true
        }) {
            Image(systemName: "trash")
        })
        .alert(isPresented: $showingDeleteAlert) {
            Alert(title: Text("Delete book"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete")) {
                self.deleteBook()
            }, secondaryButton: .cancel())
        }
    }
    
    func deleteBook() {
        viewContext.delete(book)
        
        try? self.viewContext.save()
        
        presentationMode.wrappedValue.dismiss()
    }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        
        return formatter.string(from: date)
    }
}

struct DetailView_Previews: PreviewProvider {
    static let viewContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let book = Book(context: viewContext)
        book.title = "Test Title"
        book.author = "Test author"
        book.genre = "Fantasy"
        book.rating = 4
        book.review = "This is a test book review"
        book.date = Date()
        
        return NavigationView {
            DetailView(book: book)
        }
    }
}
