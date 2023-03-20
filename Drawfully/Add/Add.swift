//
//  Add.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 2/17/23.
// Referred to https://www.youtube.com/watch?v=8hvaniprctk

import SwiftUI
import AVFoundation

//importing firbase auth and core module
import FirebaseAuth
import FirebaseCore
import Firebase

//import package : https://github.com/sanzaru/SimpleToast
import SimpleToast
import DeviceKit

struct Add: View {
    
    //Environment Object created to access global variables
    @EnvironmentObject private var app: AppVariables
    var body: some View {

            //Text("Camera View here. Currently commented for testing in simulator")

                CameraView()
            
    }
}

struct Add_Previews: PreviewProvider {
    static var previews: some View {
        Add()
    }
}


// Referred to https://www.youtube.com/watch?v=8hvaniprctk
struct CameraView: View {
    
    //Environment Object created to access global variables
    @EnvironmentObject private var app: AppVariables
    
    @StateObject var camera=CameraModel()
    
    
    //Drawing properties to be written to firebase
    @State var caption : String=""
    @State var title : String=""
    @State var postVisibility: Bool = false
    
    //Tracking posting status
    @State var drawingPosted: Bool = false
    
    // Citation : https://www.youtube.com/watch?v=pC6qGSSh9bI
    private let toastOptions=SimpleToastOptions(
        alignment: .top,
        hideAfter: 3,
        backdrop: Color.black.opacity(0.2),
        animation: .default,
        modifierType: .slide
    )
    
    
    
    var body: some View{
                
     
        //If save button is not clicked yet
        if(!camera.isSaved)
        {
            
            ZStack{
                //Camera view
                //Color(.black).ignoresSafeArea(.all,edges: .all)
                CameraPreview(camera: camera).ignoresSafeArea(.all,edges: .all)
                
                VStack{
                    
                    
                    if camera.isTaken{
                        HStack{
                            
                            Spacer()
                            
                            Button(action: camera.reTake, label:{
                                //Click to retake button
                                Image(systemName: "arrow.triangle.2.circlepath.camera")
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color.white)
                                    .clipShape(Circle())
                                
                            })
                            .padding(.trailing,10)
                        }
                    }
                    
                    Spacer()
                    HStack{
                        
                        if camera.isTaken{
                            //Save photo Button
                            Button(action:{if !camera.isSaved{camera.savePic()}}, label: {
                                Text(camera.isSaved ? "Saved" : "Save")
                                    .foregroundColor(.black)
                                    .fontWeight(.semibold)
                                    .padding(.vertical,10)
                                    .padding(.horizontal,20)
                                    .background(Color.white)
                                    .clipShape(Capsule())
                            })
                            .padding(.leading)
                            
                            
                            Spacer()
                        }
                        
                        else{
                            //Camera click button
                            Button(action: camera.takePic, label: {
                                ZStack{
                                    Circle()
                                        .fill(Color.white).frame(width: 70,height: 70)
                                    
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2)
                                        .frame(width: 75,height: 75)
                                    
                                }
                            }).padding()
                        }
                    }.frame(height: 120)
                }
            }.onAppear(perform: {
                
                camera.Check()
                
            })
            
            
        }
        
        //If save button on image has been clicked
        else{

                ZStack{
                    VStack{
                        
                        HStack{
                            Spacer()

                            //Button to write file with all properties to firebase
                            
                            NavigationLink(destination: Home()){
                                Button(action: WriteToFirebase, label: {
                                    Text("Add to Drawings")
                                }).padding(10)
                                    .foregroundColor(.black)
                                    .font(.headline)
                                    .padding(10)
                                    .background(Color.green)
                                    .clipShape(Capsule())
                            }
                          }.padding(10)
                        
                        Spacer()
                        
                        
                        //Async call to image that has just been uploaded to cloud storage
                        // Citation : https://developer.apple.com/documentation/swiftui/asyncimage
                        // Citation : https://serialcoder.dev/text-tutorials/swiftui/asyncimage-in-swiftui/
                        AsyncImage(url : camera.imageLink)
                        { image in
                            image
                                .resizable()
                                .frame(width: 360, height: 360)
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .padding(10)
                        } placeholder: {
                            Image("sample_drawing")
                                .resizable()
                                .frame(width: 360, height: 360)
                            .padding(10)                    }
                        
                        // Text Field to take Title input
                        TextField("Add Title Here!",text: $title)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .font(.headline)
                            .padding(10)
                        
                        
                        // Text Field to take Caption input
                        TextField("Add Caption Here!",text: $caption)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .font(.subheadline)
                            .padding(10)
                        
                        
                        
                        // Toggle to take Visibility input
                        Toggle(isOn: $postVisibility, label: {Text("Make Post Visible")}).padding(10)
                        
                        Spacer()
                    }
                    
                }
                // Citation : https://www.youtube.com/watch?v=pC6qGSSh9bI
                //Giving toast after upload is successful
                .simpleToast(isPresented: $drawingPosted, options: toastOptions, content: {
                    Text("Drawing successfully uploaded!")
                })
            

            }
        }
        
    //function to write post to database
    func WriteToFirebase()
    {

        // Citation : https://www.youtube.com/watch?v=yHngqpFpVZU&list=PL0dzCUj1L5JEN2aWYFCpqfTBeVHcGZjGw&index=7
        
        guard let uid=Auth.auth().currentUser?.uid else {return}
        let ref: DocumentReference? = nil
        
        //Citation : ChatGPT
        //Setting properties of drawing and writing to Firebase - Likes, Owner, Time, etc
        FirebaseManager.shared.firestore.collection("drawings").document(camera.imageName).setData(["Caption": caption,
                                                                      "Likes": 0,
                                                                      "Owner": uid,
                                                                      "Time Created":FieldValue.serverTimestamp(),
                                                                      "Title":title,
                                                                      "isPublic": postVisibility]){ err in
            if let err = err{
                print ("Error adding document: \(err)")
            }
            else{
                print("Document added with ID: \(String(describing: ref?.documentID))")
                drawingPosted=true
        
                let newDocRef = FirebaseManager.shared.firestore.collection("drawings").document(camera.imageName)
                
                //Adding to array of drawings for each user
                // Citation : ChatGPT
                FirebaseManager.shared.firestore.collection("users").document(uid).updateData(["drawings": FieldValue.arrayUnion([newDocRef])]){ err in
                    if let err = err{
                        print ("Error adding document reference: \(err)")
                    }
                    else{
                        //Switching to home tab again
                        app.selectedTab=0
                    }
                    
                }
                camera.isTaken=false
                camera.isSaved=false
                camera.imageLink=URL(string: "")
                camera.imageName=""
                camera.picData=Data(count: 0)
                title=""
                caption=""
                
                // TODO check if this updates streak using phone
                
                let storedDate = UserDefaults.standard.object(forKey: "lastDate") as? Date ?? Date.now

                if !Calendar.current.isDateInToday(storedDate){
                    FirebaseManager.shared.firestore.collection("users").document(uid).updateData(["streak" : FieldValue.increment(1.0)])
                    let date = Date.now
                    UserDefaults.standard.set(date, forKey: "lastDate")

                    print("updated streak")
                }
                
                
            }
            
        }
        
    }
    
}

// Camera Model...
// Referred to https://www.youtube.com/watch?v=8hvaniprctk
class CameraModel: NSObject ,ObservableObject, AVCapturePhotoCaptureDelegate{
    
    @Published var isTaken=false
    
    @Published var session = AVCaptureSession()
    
    @Published var alert=false
    
    @Published var preview : AVCaptureVideoPreviewLayer!
    
    // since we're going to read pic data...
    @Published var output = AVCapturePhotoOutput()
    
    @Published var isSaved = false
    
    @Published var picData = Data(count: 0)
    
    // Citation : https://matteomanferdini.com/swift-url-components/
    // To store image url
    @Published var imageLink = URL(string: "")
    
    // To store image name
    @Published var imageName = ""

    
    
    func Check(){
        // first checking camera has got permission or not
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            //Setting Up Session
            setUp()
            return
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video){
                (status) in
                
                if status{
                    self.setUp()
                }
            }
            
        case .denied:
            self.alert.toggle()
            return
            
        default:
            return
            
        }
        
    }

    
    func setUp(){
        
        // setting up camera
        
        do {
            // setting configs...
            self.session.beginConfiguration()
            
            
            //Using DeviceKit to get device info
            print("Device name app running on:")
            print(Device.current)
            
            
            //Choosing best avaiable device
            // Citation : https://developer.apple.com/documentation/avfoundation/capture_setup/choosing_a_capture_device
            // Citation : ChatGPT
            // Get all the available capture devices.
            let captureDevices = AVCaptureDevice.DiscoverySession(
                deviceTypes: [.builtInTripleCamera,.builtInDualCamera, .builtInWideAngleCamera, .builtInTelephotoCamera],
                mediaType: .video, position: .back).devices
            
            // Choose the device with the highest resolution.
            let device = captureDevices.max(by: { $0.activeFormat.videoMaxZoomFactor < $1.activeFormat.videoMaxZoomFactor })
            
            let input = try AVCaptureDeviceInput(device: device!)
            
            // checking and adding to session
            
            if self.session.canAddInput(input){
                self.session.addInput(input)
            }
            
            // same for output
            
            if self.session.canAddOutput(self.output){
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()
            
            
            
            
        }
        catch {
            print(error.localizedDescription)
        }
        
    }
    
    func takePic(){
        
        DispatchQueue.global(qos: .background).async{
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate:self)
            DispatchQueue.main.async { Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (timer) in self.session.stopRunning() } }
            DispatchQueue.main.async {
                withAnimation {
                    self.isTaken.toggle()
                }
            }
            //self.session.stopRunning()
        }
    }
    
    
    func reTake(){
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
            
            DispatchQueue.main.async {
                withAnimation {
                    //self.isTaken.toggle()
                    self.isTaken=false
                }
                self.isSaved=false
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?)
    {
        if error != nil{
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else {return}
        
        self.picData = imageData
    }
    
    func savePic(){
        
        let image = UIImage(data: self.picData)!
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        WriteToFirestore()
        
        self.isSaved.toggle()
        
        
    }
    
    func WriteToFirestore()
    {
        //Generate random universally unique value
        // Citation : https://developer.apple.com/documentation/foundation/nsuuid
        // Citation : https://stackoverflow.com/questions/24428250/generate-a-uuid-on-ios-from-swift
        let uuid = UUID().uuidString
        
        // Fetching current user uid
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{
            return}
        
        //Creating storage reference
        // Citation : https://firebase.google.com/docs/storage/ios/upload-files
        // Citation : https://www.youtube.com/watch?v=5inXE5d2MUM&t=939s
        
        let ref=FirebaseManager.shared.storage.reference(withPath: "drawings/\(uid)/\(uuid)")
        
        
        guard let imageData=UIImage(data: self.picData)!.jpegData(compressionQuality: 1.0) else
        {
            print("Could not convert file")
            return }
        
        ref.putData(imageData, metadata: nil){
            metadata, err in
            if let err=err{
                print("Data store failed \(err)")
                return
            }
            
            ref.downloadURL{
                url, err in
                if let err=err{
                    print("Failed to retrieve download url \(err)")
                    return
                }
                
                //Storing image url and name to write to firebase
                self.imageLink=url
                self.imageName=uuid
                print("Retrieved download url \(String(describing: url))")
            }
        }
    }
    
}


// setting view for preview...
// Referred to https://www.youtube.com/watch?v=8hvaniprctk

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var camera : CameraModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        camera.preview=AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame=view.frame
        
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        camera.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

