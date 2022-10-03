//
//  NewEventColorViewController.swift
//  Deadline
//
//  Created by Wang Uiroz on 2022/9/27.
//

import UIKit

protocol NewEventColorViewControllerDelegate {
    func tappedColorViewSaveButton(position: Int, data: [ToDoCategory])
}

class NewEventColorViewController: UIViewController {
    
    var delegate: NewEventColorViewControllerDelegate?
    
    var categoryData = [ToDoCategory]()
    var categoryPosition: Int?
    
    @IBOutlet var categoryPopUpButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    
    @IBOutlet var categoryTextField: UITextField!
    @IBOutlet var colorView: UIView!
    @IBOutlet var redTextField: UITextField!
    @IBOutlet var greenTextField: UITextField!
    @IBOutlet var blueTextField: UITextField!
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    @IBAction func SliderToTextField(_ sender: UISlider) {
        switch sender.tag {
        case 1:
            redTextField.text = String(format: "%.0f", redSlider.value)
        case 2:
            greenTextField.text = String(format: "%.0f", greenSlider.value)
        case 3:
            blueTextField.text = String(format: "%.0f", blueSlider.value)
        default:
            print("new event color view controller slider tag error")
        }
        colorView.backgroundColor = UIColor(red: CGFloat(redSlider.value)/255,
                                            green: CGFloat(greenSlider.value)/255,
                                            blue: CGFloat(blueSlider.value)/255,
                                            alpha: 1.0)
        categoryData[categoryPosition!].signR = CGFloat(redSlider.value)
        categoryData[categoryPosition!].signG = CGFloat(greenSlider.value)
        categoryData[categoryPosition!].signB = CGFloat(blueSlider.value)
    }
    
    @IBAction func tappedSaveButton(_ sender: UIButton) {
        if let position = categoryPosition,
           let text = categoryTextField.text {
            categoryData[position].categoryName = text
        }
        delegate?.tappedColorViewSaveButton(position: categoryPosition!, data: categoryData)
        dismiss(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        customSlider()
        customPopupButton()
        updateAnyThing()
        
        redTextField.addTarget(self, action: #selector(textFieldToSlider(_:)), for: .editingChanged)
        greenTextField.addTarget(self, action: #selector(textFieldToSlider(_:)), for: .editingChanged)
        blueTextField.addTarget(self, action: #selector(textFieldToSlider(_:)), for: .editingChanged)
        
    }
    
    private func updateAnyThing() {
        if let position = categoryPosition {
            categoryTextField.text = categoryData[position].categoryName
            redSlider.value = Float(categoryData[position].signR)
            greenSlider.value = Float(categoryData[position].signG)
            blueSlider.value = Float(categoryData[position].signB)
            colorView.backgroundColor = UIColor(red: categoryData[position].signR/255,
                                                     green: categoryData[position].signG/255,
                                                     blue: categoryData[position].signB/255,
                                                     alpha: 1.0)
        }
        redTextField.text = String(format: "%.0f", redSlider.value)
        greenTextField.text = String(format: "%.0f", greenSlider.value)
        blueTextField.text = String(format: "%.0f", blueSlider.value)
    }
    
    private func customSlider() {
        redSlider.maximumValue = 255.0
        redSlider.minimumValue = 0.0
        greenSlider.maximumValue = 255.0
        greenSlider.minimumValue = 0.0
        blueSlider.maximumValue = 255.0
        blueSlider.minimumValue = 0.0
    }
    
    private func customPopupButton() {
        let categorySelectActions: [UIAction] = {
            var actions = [UIAction]()
            for i in 0..<categoryData.count + 1 {
                if i < categoryData.count {
                    let action = UIAction(title: "\(categoryData[i].categoryName)",state: (i==categoryPosition) ? .on : .off , handler: { action in
                        self.categoryPosition = i
                        self.updateAnyThing()
                    })
                    actions.append(action)
                } else {
                    let action = UIAction(title: "New Category", handler: { action in
                        self.categoryData.append(ToDoCategory(categoryName: "New", index: 0, signR: 255.0, signG: 0.0, signB: 0.0))
                        self.categoryPosition = i
                        self.updateAnyThing()
                        self.customPopupButton()
                    })
                    actions.append(action)
                }
            }
            return actions
        }()
        categoryPopUpButton.menu = UIMenu(children: categorySelectActions)
    }
    
    @objc func textFieldToSlider(_ sender: UITextField) {
        switch sender.tag {
        case 1:
            if let text = sender.text {
                print(text)
                redSlider.value = Float(text) ?? 0
                if let value = Float(text),
                   value > 255 {
                    redSlider.value = 255
                    redTextField.text = "255"
                }
            }
        case 2:
            if let text = sender.text {
                print(text)
                greenSlider.value = Float(text) ?? 0
                if let value = Float(text),
                   value > 255 {
                    greenSlider.value = 255
                    greenTextField.text = "255"
                }
            }
        case 3:
            if let text = sender.text {
                print(text)
                blueSlider.value = Float(text) ?? 0
                if let value = Float(text),
                   value > 255 {
                    blueSlider.value = 255
                    blueTextField.text = "255"
                }
            }
        default:
            break
        }
    }

}
