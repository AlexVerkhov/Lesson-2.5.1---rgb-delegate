//
//  ViewController.swift
//  Lesson 2.2
//
//  Created by Алексей Верховых on 04.03.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var palete: UIView!
    
    @IBOutlet var redCountLabel: UILabel!
    @IBOutlet var greenCountLabel: UILabel!
    @IBOutlet var blueCountLabel: UILabel!
    
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        palete.layer.cornerRadius = 20
        updateColor()
    }

    @IBAction func redColorSliderUpdate() {
        updateColor()
    }
    
    @IBAction func greenColorSliderUpdate() {
        updateColor()
    }
    
    @IBAction func blueColorSliderUpdate() {
        updateColor()
    }
    
    func updateColor() {
        let redColor = redSlider.value
        let greenColor = greenSlider.value
        let blueColor = blueSlider.value
        
        redCountLabel.text = String(round(redColor * 100) / 100)
        greenCountLabel.text = String(round(greenColor * 100) / 100)
        blueCountLabel.text = String(round(blueColor * 100) / 100)
        
        palete.backgroundColor = UIColor(
            red: CGFloat(redColor),
            green: CGFloat(greenColor),
            blue: CGFloat(blueColor),
            alpha: 1
        )
    }
}
