//
//  SelectedImage.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 3/31/23.
//

import SwiftUI
import SDWebImageSwiftUI
import Introspect


struct SelectedImage: View {
    //var img: UIImage
    var post: PostModel
    @State private var tabBar: UITabBar?
    @State private var fieldsEditable:Bool=false
    @State var title:String=""
    @State var caption:String=""
    @State var postVisibility:Bool=false
    
    
    //Environment Object created to access global variables
    @EnvironmentObject private var app: AppVariables
    
    
    var body: some View {
        NavigationView{
            ZStack {
                Color.black.ignoresSafeArea(.all,edges: .all) // Black background
                
                // Fullscreen display of post image
                WebImage(url: URL(string : post.mediaUrl)!)
                    .resizable()
                    .scaledToFit()
                
                //If edit button has been clicked
                if fieldsEditable{
                    VStack{
                        
                        //Button to delete the post
                        Button(action: {
                            //Function call to delete post
                            PostService.deletePost(postId: post.postId, userId: post.ownerId){
                            deletedPost in
                            print("Successfully deleted post : ", deletedPost.title)
                        }
                            Home()
                        }, label: {
                            HStack{
                                Spacer()
                                Text("Delete 🗑️")
                                    .foregroundColor(.black)
                                    .fontWeight(.semibold)
                                    .padding(.vertical,10)
                                    .padding(.horizontal,20)
                                    .background(Color.red)
                                    .clipShape(Capsule())
                                
                                
                            }.padding()
                        })
                        
                        Spacer()

                        HStack{
                            //Field to edit title
                            TextField(post.title, text: $title)
                                .font(.body)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.white)
                                .padding(.horizontal, 50)
                        }
                        HStack{
                            //Field to edit caption
                            TextField(post.caption, text: $caption)
                                .font(.caption)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.white)
                                .padding(.horizontal, 50)
                        }
                        HStack{
                            //Toggle to modify visibility
                            Toggle(isOn: $postVisibility, label: {Text("Make Post Visible").foregroundColor(.white).background(AppThemeColor)
                                    .cornerRadius(20).padding(.horizontal, 20)
                                .padding(.vertical, 10)})
                        }.padding(.horizontal, 20)
                        HStack{
                            Spacer()
                            NavigationLink(destination: Home()){
                                //Button to save edits
                                Button(action:
                                        {
                                    //Function call to update post fields
                                    PostService.updatePost(userId:post.ownerId ,postId: post.postId, title: title, caption: caption, isPublic: postVisibility){
                                        updatedPost in
                                        print("Successfully updated post")
                                        //Home()
                                    }
                                    
                                    
                                }, label: {
                                    Text("Save")
                                        .foregroundColor(.white)
                                        .fontWeight(.semibold)
                                        .padding(.vertical,10)
                                        .padding(.horizontal,20)
                                        .background(AppThemeColor)
                                        .clipShape(Capsule())
                                })
                            }
                        }.padding()
                    }
                    
                }
                
                //If edit button has not been clicked
                
                else{
                    VStack{
                        //Edit button
                        Button(action:{fieldsEditable.toggle()
                            postVisibility=post.isPublic
                            title=post.title
                            caption=post.caption
                        }, label: {
                            HStack{
                                Spacer()
                                Text("Edit ✎")
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                                    .padding(.vertical,10)
                                    .padding(.horizontal,20)
                                    .background(AppThemeColor)
                                    .clipShape(Capsule())
                                
                                
                            }.padding()
                        })
                        Spacer()
                        HStack{
                            
                            //Title display
                            Text(post.title)
                                .font(.body)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.white)
                                .cornerRadius(20)
                                .padding(.horizontal, 50)
                            
                            Spacer()
                        }
                        HStack{
                            //Caption display
                            Text(post.caption)
                                .font(.caption)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.white)
                                .cornerRadius(20)
                                .padding(.horizontal, 30)
                            
                            Spacer()
                        }.padding()
                        
                    }
                }
            }
        }
        // Citation : https://stackoverflow.com/questions/58444689/swiftui-hide-tabbar-in-subview#comment128904398_72905241
        // To disable bottom bar when viewing an image fullscreen and enable once full screen view is closed
        .introspectTabBarController { UITabBarController in
            tabBar = UITabBarController.tabBar
            self.tabBar?.isHidden = true }
    }
}


