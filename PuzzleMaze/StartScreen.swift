//
//  StartScreen.swift
//  PuzzleMaze
//
//  Created by Viktor Lott on 10/28/18.
//  Copyright © 2018 Viktor Lott. All rights reserved.
//

import UIKit

class StartScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    func setupView() {
        view.backgroundColor = rgb(42, 42, 42, 1)
    }
    func rgb(_ r: Float, _ g: Float, _ b: Float, _ a: Float) -> UIColor {
        return UIColor(red: CGFloat(r/255), green: CGFloat(g/255), blue: CGFloat(b/255), alpha: CGFloat(a))
    }
    
    @IBAction func startGame(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GameScreen") as! GameScreen
        self.present(vc, animated: true, completion: nil)
       
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
