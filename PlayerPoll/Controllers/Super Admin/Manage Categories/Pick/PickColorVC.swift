//
//  PickCOlorVC.swift
//  PlayerPoll
//
//  Created by mac on 24/12/21.
//

import UIKit
import ChromaColorPicker
class PickColorVC: UIViewController, ChromaColorPickerDelegate {
    //MARK:- IBOutlets
    
    @IBOutlet weak var sliderHolderView: UIView!
    
    @IBOutlet weak var pickerHolderView: UIView!
    //MARK:- Variable Declarations
    var pickedColor:((UIColor)->Void)?
    var colorPicker:ChromaColorPicker?
    var selectedColor:UIColor?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Configuring UI Method(s)
    func configureUI(){
        colorPicker = ChromaColorPicker(frame: CGRect(x: 0, y: 0, width: pickerHolderView.frame.width, height: pickerHolderView.frame.height))
        colorPicker?.delegate = self
        let homeHandle = ChromaColorHandle(color: .blue)
        let imageView = UIImageView(image: #imageLiteral(resourceName: "color-picker").withRenderingMode(.alwaysTemplate))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        homeHandle.accessoryView = imageView
        homeHandle.accessoryViewEdgeInsets = UIEdgeInsets(top: 2, left: 4, bottom: 4, right: 4)
        colorPicker?.addHandle(homeHandle)
        pickerHolderView.addSubview(colorPicker!)
    }
   
    //MARK:- Validation Method(s)
    
    
    //MARK:- Service Call Method(s)
    
    
    //MARK:- IBAction Method(s)
    @IBAction func pickBtnAtion(_ sender: PPColorPickerButton) {
        guard let color = self.selectedColor else {return}
        pickedColor?(color)
    }
    
    func colorPickerHandleDidChange(_ colorPicker: ChromaColorPicker, handle: ChromaColorHandle, to color: UIColor) {
        selectedColor = color
    }
    
}
