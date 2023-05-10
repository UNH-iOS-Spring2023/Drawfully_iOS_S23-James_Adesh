//
//  UserSearch.swift
//  Drawfully
//
//  Created by James on 5/7/23.
//
// Reference for User Search Field: https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-a-search-bar-to-filter-your-data


import SwiftUI

struct UserSearch: View {
    
    // string to filter with
    @State private var search: String = ""
    
    // user queries
    @EnvironmentObject var informationArr: SearchQueries
    
    var body: some View {
        let header = HStack{
            Spacer()
            
            Text("Search Users")
                .font(.title)
                .fontWeight(.bold)
                .padding(.trailing, 0.0)
                .multilineTextAlignment(.center)
                .foregroundColor(AppTextColor)
                    
            Spacer()
        }
            .padding()
            .background(AppThemeColor)
        
        // create the list of all users referenced by the search bar, with filters applied
        var usersList: [User] {
            if search.isEmpty{
                return informationArr.users
            } else {
                return informationArr.users.filter{item in
                    item.username.localizedCaseInsensitiveContains(search) } //if any part matches the current text in search, display it
            }
        }
        
       // After searching, show related Users with the option to navigate to their homepage
        let userSearch = List {
                ForEach(usersList, id: \.self.username) { user in
                    NavigationLink{
                        UserView(user: user) // Navigates to selected User's homepage
                    } label: {
                        Text(user.username)
                    }
                }
        }
            
        // TODO fix the search bar not appearing until scrolling up
        VStack{
            userSearch
                .navigationTitle("Search Users")
                .searchable(text: $search)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never) // make this area searchable
        }
        .refreshable {
            informationArr.firebaseUserQuery()
        }
    }
}

struct UserSearch_Previews: PreviewProvider {
    static var previews: some View {
        UserSearch()
            .environmentObject(SearchQueries())
    }
}
