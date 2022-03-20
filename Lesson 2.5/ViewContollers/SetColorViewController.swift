//
//  ViewController.swift
//  Lesson 2.2
//
//  Created by Алексей Верховых on 04.03.2022.
//

import UIKit

class SetColorViewController: UIViewController {

    @IBOutlet var colorView: UIView!
    
    @IBOutlet var colorLabels: [UILabel]!
    @IBOutlet var colorSliders: [UISlider]!
    @IBOutlet var colorTextFields: [UITextField]!
    
    var currentColor: UIColor!
    var delegate: setColorViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorView.layer.cornerRadius = 20
        setColorSliders(by: colorToRGB(currentColor))
        
        for indexElement in 0..<colorSliders.count {
            colorChangedBySliderOrTextField(sender: colorSliders[indexElement], isInit: true)
            addTextFieldToolBar(textField: colorTextFields[indexElement])
        }
        
        updateColorView()
    }
    
    
    @IBAction func buttonClosePressed() {
        dismiss(animated: true)
    }
    
    
    @IBAction func buttonSavePressed() {
        view.endEditing(true)
        delegate.setNewColor(currentColor)
        dismiss(animated: true)
    }
    
    
    // заметил, что если isInit по умолчанию сделать равным true, то
    // при запуске функции при активации элементов интерфейса
    // isInit по умолчанию всегда будет равен false - почему так?
    //
    // мне пришлось для этого приравнять его false по умолчанию
    // и как было бы правильно в данной ситуации?
    
    
    @IBAction func colorChangedBySliderOrTextField(sender: Any?, isInit: Bool = false) {
        if let colorSlider = sender as? UISlider {
            setColorLabel(by: colorSlider.value, for: colorSlider.tag)
            setColorTextField(by: colorSlider.value, for: colorSlider.tag)
        } else if let colorTextField = sender as? UITextField {
            var colorValue = Float(colorTextField.text ?? "0.0") ?? 0.5
            var newColorValue: Float = -1.0
            
            if colorValue < 0 {
                newColorValue = 0
            } else if colorValue > 1 {
                newColorValue = 1
            }
            
            if newColorValue != -1.0 && colorValue != newColorValue {
                colorValue = newColorValue
                colorTextField.text = String(format: "%0.2f", colorValue)
            }
            
            setColorSlider(
                by: roundFloat(colorValue),
                for: colorTextField.tag)
            
            if let colorTextValue = colorTextField.text, colorTextValue.count > 4 {
                colorTextField.text = String(format: "%0.2f", colorValue)
            }
        } else {
            return
        }
        
        if !isInit { updateColorView() }
    }
    
    
    func roundFloat(_ value: Float) -> Float {
        round(value * 100) / 100
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super .touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}


// MARK: - Color Functions
extension SetColorViewController {
   
    func setColorLabel(by value: Float, for element: Int) {
        colorLabels[element].text = String(format: "%0.2f", value)
    }
    
    
    func setColorTextField(by value: Float, for element: Int) {
        colorTextFields[element].text = String(roundFloat(value))
    }
    
    
    func setColorSlider(by value: Float, for element: Int) {
        colorSliders[element].value = roundFloat(value)
    }
    

    func setColorSliders(by rgbColors: [Float]) {
        for sliderIndex in 0..<colorSliders.count {
            colorSliders[sliderIndex].value = rgbColors[sliderIndex]
        }
    }
    
    
    func updateColorView() {
        currentColor = UIColor(
            red: CGFloat(colorSliders[0].value),
            green: CGFloat(colorSliders[1].value),
            blue: CGFloat(colorSliders[2].value),
            alpha: 1)
        colorView.backgroundColor = currentColor
    }
    
    
    func colorToRGB(_ color: UIColor) -> [Float] {
        var redColorValue: CGFloat = 0
        var greenColorValue: CGFloat = 0
        var blueColorValue: CGFloat = 0
        var alphaColorValue: CGFloat = 0
        
        color.getRed(&redColorValue, green: &greenColorValue, blue: &blueColorValue, alpha: &alphaColorValue)
        return [Float(redColorValue), Float(greenColorValue), Float(blueColorValue)]
    }
}


// MARK: - TextField Delegate
extension SetColorViewController: UITextFieldDelegate {
    func addTextFieldToolBar(textField: UITextField) {
        let toolBar = UIToolbar()
        let doneButton = UIBarButtonItem(
            title: textField.tag < 2 ? "Next" : "Done",
            style: .plain,
            target: self,
            action: #selector(textFieldNextButtonPressed(sender: )))
        doneButton.tag = textField.tag
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(textFieldCancelButtonPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.sizeToFit()
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }

    // Как я понял, для того, чтобы работать с селектором, необходимо объявлять
    // функции как objective-c, так как
    // использовать без @objc не получилось. Без селектора также не получилось
    
    @objc func textFieldCancelButtonPressed() {
        view.endEditing(true)
    }
    
    
    @objc func textFieldNextButtonPressed(sender: UIBarButtonItem?) {
        guard let barButtonTapped = sender else { return }
        
        if barButtonTapped.tag < 2 {
            colorTextFields[barButtonTapped.tag].endEditing(true)
            colorTextFields[barButtonTapped.tag + 1].becomeFirstResponder()
        } else {
            colorTextFields[barButtonTapped.tag].endEditing(true)
        }
    }
}


// MARK: - Protocol Delegate
protocol setColorViewControllerDelegate {
    func setNewColor(_ color: UIColor)
}
