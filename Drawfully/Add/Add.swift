//
//  Add.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 2/17/23.
// Referred to https://www.youtube.com/watch?v=8hvaniprctk

import SwiftUI
import AVFoundation

struct Add: View {
    var body: some View {
        
        Text("Camera View here. Currently commented for testing in simulator")
        //CameraView()
        }
}

struct Add_Previews: PreviewProvider {
    static var previews: some View {
        Add()
    }
}


// Referred to https://www.youtube.com/watch?v=8hvaniprctk
struct CameraView: View {
    
    @StateObject var camera=CameraModel()
    
    var body: some View{
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
            
            let device = AVCaptureDevice.default(.builtInTripleCamera, for: .video, position: .back)
            
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
        
        self.isSaved=true

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

