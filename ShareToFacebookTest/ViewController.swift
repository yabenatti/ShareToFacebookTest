//
//  ViewController.swift
//  ShareToFacebookTest
//
//  Created by Yasmin Benatti on 28/08/17.
//  Copyright © 2017 Yasmin Benatti. All rights reserved.
//

import UIKit
import FacebookShare

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTapShareLink(_ sender: Any) {
        let content = LinkShareContent(url: URL(string: "https://developers.facebook.com")!)
        do {
            try ShareDialog.show(from: self, content: content)
        } catch {
            print("Error opening share dialog")
        }
    }

    @IBAction func didTapSharePhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePicker = UIImagePickerController()
            print("Photo capture")
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)

        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let photo = Photo(image: image, userGenerated: true)
            let content = PhotoShareContent(photos: [photo])
            showShareDialog(content)
        }
    }
    
    func showShareDialog<C: ContentProtocol>(_ content: C, mode: ShareDialogMode = .automatic) {
        let dialog = ShareDialog(content: content)
        dialog.presentingViewController = self
        dialog.mode = mode
        do {
            try dialog.show()
        } catch (let error) {
            let alertController = UIAlertController(title: "Invalid share content", message: "Failed to present share dialog with error \(error)", preferredStyle: .alert)
            present(alertController, animated: true, completion: nil)
        }
    }

}

