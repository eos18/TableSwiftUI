//
//  ContentView.swift
//  TableSwiftUI
//
//  Created by English, Kate on 3/31/25.
//

import SwiftUI
import MapKit

let data = [
   Item(name: "Emma", author: "Jane Austen", desc: "Emma by Jane Austen follows Emma Woodhouse, a wealthy and self-assured young woman living in Highbury, England who takes pride in her matchmaking skills. However, her well-intended meddling often leads to misunderstandings and unexpected consequences.", lat: 51.5457996, long: -0.1027127, imageName: "emma"),
   Item(name: "Fahrenheit 451", author: "Ray Bradbury", desc: "Fahrenheit 451 by Ray Bradbury is set in a dystopian future where books are banned, and 'firemen' burn any that are found. The story follows Guy Montag, a fireman who begins questioning his role in a society that suppresses free thought and individuality.", lat: 41.881832, long: -87.623177, imageName: "fh"),
   Item(name: "Fried Green Tomatoes", author: "Fannie Flagg", desc: "Fried Green Tomatoes at the Whistle Stop Cafe by Fannie Flagg follows the lives of Ruth Jamison and Idgie Threadgoode, two women who run a café in the small town of Whistle Stop, Alabama. The novel intertwines their story with the present-day life of Evelyn Couch, a woman living in Birmingham, Alabama who befriends Ninny Threadgoode.", lat: 33.543682, long: -86.779633, imageName: "fgt"),
   Item(name: "A Tale of Two Cities", author: "Charles Dickens", desc: "A Tale of Two Cities by Charles Dickens is set during the French Revolution and contrasts the lives of people in Paris and London. It follows the story of Charles Darnay, a French aristocrat who renounces his family’s wealth, and Sydney Carton, a disillusioned English lawyer, who both find their fates intertwined in the turbulent political climate.", lat: 48.8575, long: 2.3514, imageName: "atotc"),
   Item(name: "Flowers in the Attic", author: "V.C. Andrews", desc: "Flowers in the Attic by V.C. Andrews is set in Charlottesville, Virginia and tells the dark tale of the Dollanganger children, who are locked away in an attic by their mother and grandfather after their father's death. While the children endure severe abuse and neglect while struggling to survive in isolation, their bond grows stronger.", lat: 38.033554, long: -78.507980, imageName: "flowers")
]
   struct Item: Identifiable {
       let id = UUID()
       let name: String
       let author: String
       let desc: String
       let lat: Double
       let long: Double
       let imageName: String
   }






struct ContentView: View {
    @State private var selectedAuthor: String? = nil
    @State private var showAuthorPicker = false
    
    var authors: [String] {
        Array(Set(data.map { $0.author })).sorted()
    }
    
    var filteredData: [Item] {
        if let selectedAuthor = selectedAuthor {
            return data.filter { $0.author == selectedAuthor }
        }
        return data
    }
    
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 36.031332, longitude: -35.156250), span: MKCoordinateSpan(latitudeDelta: 90, longitudeDelta: 90))
        
        var body: some View {
            NavigationView {
                VStack(spacing: 10) {
                    // Author Picker using Menu
                    Menu {
                        Button("All") {
                            selectedAuthor = nil
                        }
                        ForEach(authors, id: \.self) { author in
                            Button(author) {
                                selectedAuthor = author
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedAuthor ?? "Select Author")
                                .foregroundColor(.primary)
                                .font(.subheadline)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                        .padding(.horizontal)
                    }
                    
                    // Book List
                    List(filteredData, id: \.name) { item in
                        NavigationLink(destination: DetailView(item: item)) {
                            HStack(spacing: 15) {
                                Image(item.imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(item.name)
                                        .font(.headline)
                                    Text(item.author)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                            .padding(5)
                            
                        }
                    }
                    .listStyle(PlainListStyle()) // Makes the list look cleaner
                    
                    
                    Spacer()
                    
                    // Map View with Card-Like Styling
                    Map(coordinateRegion: $region, annotationItems: filteredData) { item in
                        MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long)) {
                            VStack {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.title)
                                Text(item.name)
                                    .font(.caption)
                                    .bold()
                                    .padding(4)
                                    .background(Color.white.opacity(0.8))
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                            }
                        }
                    }
                    .frame(height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(radius: 5)
                    .padding(.horizontal)
                }
                .navigationTitle("Classic Literature")
            }
        }
    }





struct DetailView: View {
    let item: Item
    @State private var region: MKCoordinateRegion
    
    init(item: Item) {
        self.item = item
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long),
            span: MKCoordinateSpan(latitudeDelta: 0.20, longitudeDelta: 0.20)
        ))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // Book Cover Image
                Image(item.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(radius: 5)
                    .padding(.horizontal)
                
                // Book Details
                VStack(alignment: .leading, spacing: 8) {
                    Text(item.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    Text("by \(item.author)")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    Divider()
                    
                    Text(item.desc)
                        .font(.body)
                        .foregroundColor(.primary)
                        .padding(.horizontal)
                }
                
                Divider()
                
                // Map View
                VStack(alignment: .leading, spacing: 8) {
                    Text("Location")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    Map(coordinateRegion: $region, annotationItems: [item]) { item in
                        MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long)) {
                            VStack {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.title)
                                Text(item.name)
                                    .font(.caption)
                                    .bold()
                                    .padding(4)
                                    .background(Color.white.opacity(0.8))
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                            }
                        }
                    }
                    .frame(height: 175)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(radius: 5)
                    .padding(.horizontal)
                }
                Spacer()
                
            } // End VStack
            .padding(.vertical)
        } // End ScrollView
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}




#Preview {
    ContentView()
}
