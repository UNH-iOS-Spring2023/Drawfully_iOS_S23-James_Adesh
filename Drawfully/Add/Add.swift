//
//  Add.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 2/17/23.
// Referred to https://www.youtube.com/watch?v=8hvaniprctk
//  Citation : The entire class is implemented with reference to the YouTube tutorial series - SwiftUI Instagram Clone with Firebase by iosMastery
//  Citation : https://youtu.be/GMxo8MA6Nnc?list=PLdBY1aYxSpPVI3wTlK1cKHNOoq4JA3X5-

import SwiftUI
import AVFoundation

//importing firbase auth and core module
import FirebaseAuth
import FirebaseCore
import Firebase
import FirebaseStorage
import FirebaseFirestore

//import package : https://github.com/sanzaru/SimpleToast
import SimpleToast
import DeviceKit

struct Add: View {
    @EnvironmentObject var session: SessionStore
    
    //Environment Object created to access global variables
    @EnvironmentObject private var app: AppVariables
    var body: some View {
        
        //Text("Camera View here. Currently commented for testing in simulator")
        
        CameraView().environmentObject(app).environmentObject(session)
        
    }
}

struct Add_Previews: PreviewProvider {
    static var previews: some View {
        Add()
    }
}


// Referred to https://www.youtube.com/watch?v=8hvaniprctk
struct CameraView: View {
    
    @EnvironmentObject var session: SessionStore
    //Environment Object created to access global variables
    @EnvironmentObject private var app: AppVariables
    
    @StateObject var camera=CameraModel()
    
    
    //Drawing properties to be written to firebase
    @State var caption : String=""
    @State var title : String=""
    @State var postVisibility: Bool = false
    @State var imageLink: String = ""
    
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
                                Image(systemName: "x.circle.fill").resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                   .foregroundColor(.white)
                            })
                            .padding(.trailing,10)
                        }
                    }
                    
                    Spacer()
                    HStack{
                        
                        if camera.isTaken{
                            //Save photo Button
                            Button(action:{if !camera.isSaved{camera.isSaved=true}}, label: {
                                Text(camera.isSaved ? "Saved" : "Save")
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                                    .padding(.vertical,10)
                                    .padding(.horizontal,20)
                                    .background(AppThemeColor)
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
                        
                        // NavigationLink(destination: Home()){
                        Button(action: WriteToFirebase, label: {
                            Text("Add to Drawings")
                        }).padding(10)
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding(10)
                            .background(AppThemeColor)
                            .clipShape(Capsule())
                    }.padding(10)
                    
                    Spacer()

                    
                    Image(uiImage: UIImage(data: camera.picData)!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        //.placeholder(Image("sample_drawing"))
                        .frame(height: 360)
                        //.scaledToFit()
                       
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(10)
                    
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

        
        //Add Post to firebase with all attributes - caption, title, isPublic
        PostService.uploadPost(caption: caption, title: title, isPublic: postVisibility, imageData: camera.picData,onSuccess:
            {
            // Citation : https://mammothinteractive.com/get-current-time-with-swiftui-hacking-swift-5-5-xcode-13-and-ios-15/
            let formatter = DateFormatter()
            formatter.dateFormat = "YY/MM/dd"
            let currentDateTime = Date()
            // Citation : https://developer.apple.com/documentation/foundation/date/formatstyle/timestyle
            // Citation : https://www.hackingwithswift.com/example-code/language/how-to-compare-dates
            let dateToday = formatter.string(from: currentDateTime)
            // get the last date the user posted
            let lastUploaded = self.session.session?.lastUpdated ?? formatter.string(from: currentDateTime.addingTimeInterval(-86400*2))

            
            //If user has not posted on the same day
            if (lastUploaded != dateToday){
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YY/MM/dd"
                let dateTodayDate = dateFormatter.date(from: dateToday)
                let lastUploadedDate = dateFormatter.date(from: lastUploaded) ?? Date.now
                let boolean = Calendar.current.isDateInToday(lastUploadedDate.addingTimeInterval(86400))
                let newDate = lastUploadedDate.addingTimeInterval(86400)
                
                print("Streak Debugging",dateTodayDate, lastUploadedDate, boolean, newDate)
                
                //If user has posted the previous day
                if (Calendar.current.isDateInToday(lastUploadedDate.addingTimeInterval(86400))){
                    FirebaseManager.shared.firestore.collection("users").document(uid).updateData(["streak" : FieldValue.increment(1.0)])
                    
                    self.session.session?.streak+=1
                    
                }
                //If user has not posted the previous day or the same day, reset streak to 1
                else{
                    FirebaseManager.shared.firestore.collection("users").document(uid).updateData(["streak" : 1])
                    self.session.session?.streak=1
                }
            }
            
            FirebaseManager.shared.firestore.collection("users").document(uid).updateData(["lastUpdated" : dateToday])
        })
        { errorMessage in
            print ("SavePostPhoto error : \(errorMessage)" )
        }
        drawingPosted=true

        
        
//  Resetting photo and camera view
        camera.isTaken=false
        camera.isSaved=false
        camera.picData=Data(count: 0)
        title=""
        caption=""
        
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

