//
//  ViewController.swift
//  Meme 01
//
//  Created by Ghadah on 30/09/2019.
//  Copyright © 2019 Ghadah. All rights reserved.
//

import UIKit


class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

   
    
    @IBOutlet weak var shareBttnItem: UIBarButtonItem!
    @IBOutlet weak var topTxtField: UITextField!
    @IBOutlet weak var bottomTxtField: UITextField!
    
    @IBOutlet weak var imageViewer: UIImageView!
    
    
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var topToolbar: UIToolbar!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    var memedImage: UIImage!
    var originalImage: UIImage!
    
    func textFieldDidBeginEditing(){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        setTextFields(textInput: topTxtField, defaultText: "TOP")
        setTextFields(textInput: bottomTxtField, defaultText: "BOTTOM")
        shareBttnItem.isEnabled = false
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    func setTextFields(textInput: UITextField!, defaultText: String){
        
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth:  -3.0 ]
        textInput.text = defaultText
        textInput.defaultTextAttributes = memeTextAttributes
        textInput.delegate = self
        textInput.textAlignment = .center
    
    }
    @IBAction func imagePickerFromAlbum(_ sender: Any) {
        PickImage(sourceType: .photoLibrary)
   
    }
    @IBAction func imagePickerFromCamera(_ sender: Any) {
      PickImage(sourceType: .camera)
    }
    
    func PickImage(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageViewer.image = image
            shareBttnItem.isEnabled = true
            dismiss(animated: true, completion: nil)
        }
    
    }
  
    func save() {
        // Create the meme
        let topTxt = (topTxtField.text == "TOP") ? "" : topTxtField.text ?? ""
        let bottomTxt = (bottomTxtField.text == "BOTTOM") ? "" : bottomTxtField.text ?? ""
        guard let image = imageViewer.image else {return}
        let memedImage = generateMemedImage()
        
        let meme = Meme(topText: topTxt, bottomTxt: bottomTxt, originalImage: image, memedImage: memedImage)
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        dismiss(animated: true, completion: nil)
    }
    
    
    func share() {
        let memeToShare = generateMemedImage()
        let activity = UIActivityViewController(activityItems: [memeToShare], applicationActivities: nil)
        activity.completionWithItemsHandler = { (activity, completed, items, error) in
            
            if completed {
                self.save()
            }
        }
        present(activity, animated: true, completion:nil)
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        hide(true)
        
        // Render view to an image
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        hide(false)
        
        return memedImage
    }
    
    func hide(_ hide: Bool){
        topToolbar.isHidden = hide
        bottomToolbar.isHidden = hide
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTxtField.isFirstResponder{
             view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }

    @objc func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    


    
    func textFieldDidBeginEditing(_ textField: UITextField){
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
}
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        topTxtField.resignFirstResponder()
        bottomTxtField.resignFirstResponder()
        return true
    }
    
    @IBAction func sharreBttnWasPressed(_ sender: Any) {
      share()
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
       self.navigationController?.popToRootViewController(animated: true)
    }
}
