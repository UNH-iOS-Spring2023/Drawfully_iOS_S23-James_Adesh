//
//  Community.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 2/17/23.
//

import SwiftUI
import FirebaseAuth

struct Community: View {
    
    @State private var postImage: Image?
    @State private var pickedImage: Image?
    @State private var showingActionSheet = false
    @State private var showingImagePicker = false
    @State private var imageData: Data = Data ()
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var error:String = ""
    @State private var showingAlert = false
    @State private var alertTitle: String = "Oh No!"
    @State private var text = ""
    
    @EnvironmentObject var session: SessionStore
    
    @StateObject var profileService = ProfileService()
    
    
    var body: some View {
        
        //Will write code for Community Tab View here
        VStack {
            
            HStack{
                Text("Community").font(.title).fontWeight(.bold).padding(.trailing, 42.0).multilineTextAlignment(.center)
                Spacer()
                Image(systemName: "magnifyingglass")
            }.padding()
            ScrollView{
//                VStack{
//                    ForEach(self.profileService.posts, id:\.postId){
//                        (post) in
//
//                        PostCardImage(post: post)
//                        PostCard(post: post)
//
//                    }
//                }
            }
            .onAppear{
                if (self.session.session != nil)
                {
                    self.profileService.loadUserPosts(userId: Auth.auth().currentUser!.uid)
                }
            }
        }
        
    }
}

struct Community_Previews: PreviewProvider {
    static var previews: some View {
        Community()
    }
}
