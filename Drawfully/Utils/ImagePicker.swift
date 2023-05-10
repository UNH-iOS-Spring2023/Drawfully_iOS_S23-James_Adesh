//
//  ImagePicker.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 4/3/23.
//  Citation : https://youtu.be/crULPMS7Uxs
//  Citation : https://developer.apple.com/documentation/photokit/bringing_photos_picker_to_your_swiftui_app

import Foundation
import SwiftUI



struct ImagePicker: UIViewControllerRepresentable{
    
    //Image file
    @Binding var pickedImage:Image?
    
    // Boolean to hide and show Image Picker
    @Binding var showImagePicker: Bool
    
    // To store image data
    @Binding var imageData: Data
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        Coordinator(self)
    }
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
        var parent: ImagePicker
        
        init(_ parent: ImagePicker){
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let uiImage = info[.editedImage] as! UIImage
            parent.pickedImage = Image(uiImage: uiImage)
            
            //Converting to jpeg and compression to 50%
            if let mediaData = uiImage.jpegData(compressionQuality: 0.5){
                parent.imageData = mediaData
            }
            
            //Toggling off image picker after image is selected
            parent.showImagePicker=false
        }
    }
}
