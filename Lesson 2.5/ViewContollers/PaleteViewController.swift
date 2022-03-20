//
//  PaleteViewController.swift
//  Lesson 2.5
//
//  Created by Алексей Верховых on 19.03.2022.
//

import UIKit

class PaleteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "setColorSegue" else { return }
        // 1. Правильно ли сносить в данном кейсе "..as?" таким образом?
        // 2. Когда нет необходимости объявлять класс для NavigationController, как понял,
        //    остается использовать его стандартный класс
        guard let setColorNavigationController = segue.destination
            as? UINavigationController else { return }
        guard let setColorViewController = setColorNavigationController.topViewController
            as? SetColorViewController else { return }
        setColorViewController.currentColor = view.backgroundColor
        setColorViewController.delegate = self
    }
    
    @IBAction func setColorButtonPressed() {
        performSegue(withIdentifier: "setColorSegue", sender: self)
    }
}

extension PaleteViewController: setColorViewControllerDelegate {
    func setNewColor(_ color: UIColor) {
        view.backgroundColor = color
    }
}
