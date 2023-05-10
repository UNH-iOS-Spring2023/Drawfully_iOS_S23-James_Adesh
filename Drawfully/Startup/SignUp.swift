//
//  SignUp.swift
//  Drawfully
//
//  Created by James on 2/26/23.
// Citation : ImagePicker : https://www.youtube.com/watch?v=MjHUPgGPVwA&list=PLdBY1aYxSpPVI3wTlK1cKHNOoq4JA3X5-&index=3

import SwiftUI

//importing firbase auth and core module
import FirebaseAuth
import FirebaseCore
import Firebase

//import package : https://github.com/sanzaru/SimpleToast
import SimpleToast

struct SignUp: View {
    
    // inputs
    @State var username: String = ""
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var password: String=""
    @State var email: String=""
    @State var userIsLoggedIn: Bool=false
    @State var statusMessage: String=""
    
    //Boolean to trigger toast
    @State var error:Bool=false
    @State var errorMsg:String=""
    
    // prfile image inputs
    @State var profileImage : Image?
    @State var pickedImage : Image?
    
    @State var showingActionSheet = false
    @State var showingImagePicker = false
    @State var userLoginStatus: User?

    @StateObject var searchFirebase =  SearchQueries()
    
    @State var imageData: Data = Data()
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    // user session
    @EnvironmentObject var session: SessionStore
    
    // Citation : https://www.youtube.com/watch?v=pC6qGSSh9bI
    private let toastOptions=SimpleToastOptions(
        alignment: .top,
        hideAfter: 3,
        backdrop: Color.black.opacity(0.2),
        animation: .default,
        modifierType: .slide
    )
    
    //loading up and displaying picked profile image
    func loadImage(){
        guard let inputImage = pickedImage else {return}
        profileImage = inputImage
    }
    
    //Clearing all fields on SignUp form after successful signup and login
    func clear(){
        self.username = ""
        self.firstName = ""
        self.lastName = ""
        self.password=""
        self.email=""
        self.imageData=Data()
        self.profileImage=Image(systemName: "person.circle.fill" )
        
    }
    
    // Citation : https://www.youtube.com/watch?v=6b2WAePdiqA
    // Citation : https://firebase.google.com/docs/auth/ios/start
    // Sign up in firebase
    func register(){
        if (username.isEmpty || password.isEmpty || firstName.isEmpty || email.isEmpty){
            //Triggering toast display
            error.toggle()
        }
        else{
            // Citation : https://www.youtube.com/watch?v=aOM_MmZm9Q4&list=PLdBY1aYxSpPVI3wTlK1cKHNOoq4JA3X5-&index=8&t=1290s
            AuthService.signUp(fname: firstName, lname: lastName, username: username, email: email, password: password, imageData: imageData, onSuccess: {
                (user) in
                self.clear()
                print("Signed up user successfully \(String(describing: session.session))")
                
                
                //Updating auth status
                self.session.session = User(uid: user.uid,
                                           email: email,
                                       profileImageUrl:user.profileImageUrl,
                                            username:username,
                                            lastUpdated: user.lastUpdated,
                                       //searchName:user.searchName,
                                       streak:user.streak,
                                            firstName: firstName,
                                            lastName: lastName)
                
                session.listen()
                //Setting state to logged in
                self.session.loggedIn=true
            }){
                (errorMessage) in
                print("Error \(errorMessage)")
                self.errorMsg=errorMessage
                return
            }
        }
    }
    
    // Citation : https://developer.apple.com/forums/thread/667742
    // Citation : https://www.youtube.com/watch?v=6b2WAePdiqA
    // Switching views as per log in status
    var body: some View{
        if session.session != nil{
            
            BottomBar(AnyView(Home().environmentObject(session)),
                      AnyView(Community().environmentObject(session).environmentObject(searchFirebase)),
                      AnyView(Add().environmentObject(session)),
                      AnyView(Search().environmentObject(searchFirebase)),
                      AnyView(Settings().environmentObject(session))
            )
            .environmentObject(AppVariables())
        }
        else{
            content
        }
    }
    
    var content: some View {
        
        NavigationView {
            ZStack{
                Color.mint.ignoresSafeArea()
                
                VStack(alignment: .center, spacing: 0){
                    //Added logo display
                    Image("logo")
                        .resizable()
                        .frame(width: 75, height: 75, alignment: .top)
                    
                    // header
                    VStack{
                        Text("Sign Up")
                            .font(
                                .system(size: 40)
                            )
                            .bold()
                            .shadow(color: .gray, radius: 1)
                            .padding()
                        
                        // User inputs for account creation
                        Group{
                            if profileImage != nil {
                                profileImage!.resizable()
                                    .clipShape(Circle())
                                    .frame(width: 100, height: 100)
                                    .padding(20)
                                    .onTapGesture {
                                        self.showingActionSheet = true
                                    }
                            }
                            else
                            {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .clipShape(Circle())
                                    .frame(width: 100, height: 100)
                                    .padding(20)
                                    .onTapGesture {
                                        self.showingActionSheet = true
                                    }
                            }
                        }
                        
                        TextField("First Name", text: $firstName)
                            .padding(5)
                        TextField("Last Name", text: $lastName)
                            .padding(5)
                        
                        TextField("Email", text: $email).textInputAutocapitalization(.never).padding(5)
                        
                        TextField("Username", text: $username).textInputAutocapitalization(.never).padding(5)
                        
                        //Added password field
                        SecureField("Password",text:$password).padding(5)
                        
                        Button(action: register){
                            Text("Submit")
                                .padding(1)
                        }
                        .padding()
                    }
                    .overlay(
                        // Background
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.white, lineWidth: 4)
                    ).background(.white)
                        .padding(40)
                        .multilineTextAlignment(.center)
                        .disableAutocorrection(true)
                    Text(statusMessage).padding()
                }
                .padding(.bottom)
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage){
                ImagePicker(pickedImage: self.$pickedImage, showImagePicker: $showingImagePicker, imageData: $imageData)
            }
            // Picking a photo from images
            .actionSheet(isPresented: $showingActionSheet){
                ActionSheet(title: Text(""), buttons: [.default(Text("Choose a Photo")){
                    self.sourceType = .photoLibrary
                    self.showingImagePicker = true
                },
                                                       .default(Text("Take a Photo")){
                                                           self.sourceType = .camera
                                                           self.showingImagePicker=true
                                                       },
                                                       .cancel()
                                                      ])
            }
        }
        // Citation : https://www.youtube.com/watch?v=pC6qGSSh9bI
        .simpleToast(isPresented: $error, options: toastOptions, content: {
            Text("All fields not completed!")
        })
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}
