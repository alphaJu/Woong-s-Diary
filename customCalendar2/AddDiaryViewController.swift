//
//  AddDiaryViewController.swift
//  customCalendar2
//
//  Created by Hanung Lee on 24/07/2018.
//  Copyright © 2018 Hanung Lee. All rights reserved.
//

import UIKit

class AddDiaryViewController: UIViewController {

    var date: String? //cell에서 얻어와야 함.
    
    @IBOutlet weak var date_written: UITextField!
    
    @IBOutlet weak var segButton: UISegmentedControl!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    
    var lastPoint = CGPoint.zero // CGPoint.zeroPoint
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var black: CGFloat = 0.0
    var brushWidth: CGFloat = 3.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    var widthForErase: CGFloat = 15.0
    var widthForBrush: CGFloat = 3.0
    
    
    let colors: [(CGFloat, CGFloat, CGFloat)] = [
        (1.0, 0, 0),
        (0, 1.0, 0),
        (0, 0, 1.0),
        (0, 0, 0),
        (1.0, 1.0, 1.0)
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //date_written.text = Time
        
        let date_now_string = NSDate().description
        let index = date_now_string.index(date_now_string.startIndex, offsetBy: 16)
        date_written.text = String(date_now_string[..<index])
        
        self.view.backgroundColor = UIColor.darkGray
        
        self.textView.backgroundColor = UIColor.black.withAlphaComponent(0)
        
        segButton.selectedSegmentIndex = 0
        textView.isUserInteractionEnabled = true
        mainImageView.isUserInteractionEnabled = false
        tempImageView.isUserInteractionEnabled = false
        
        mainImageView.image = UIImage(named: "icon2")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
    
    @IBAction func save(_ sender: UIButton) {
        self.dismiss(animated: true)
        //db등록
    }
    @IBAction func indexChanged(_ sender: Any) {
        if segButton.selectedSegmentIndex == 0 {
            textView.isUserInteractionEnabled = true
            mainImageView.isUserInteractionEnabled = false
            tempImageView.isUserInteractionEnabled = false
        }else{
            textView.isUserInteractionEnabled = false
            mainImageView.isUserInteractionEnabled = true
            tempImageView.isUserInteractionEnabled = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: tempImageView)
        }
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        //1
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: mainImageView.frame.size.width, height: mainImageView.frame.size.height))
        
        
        //2
        context?.move(to: fromPoint)
        context?.addLine(to: toPoint)
        
        //3
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushWidth)
        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        
        //4
        context?.strokePath()
        
        //5
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //6
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: tempImageView)
            drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)
            
            //7
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            // draw a single point
            drawLineFrom(fromPoint: lastPoint, toPoint: lastPoint)
        }
        
        // Merge tempImageView into mainImageView
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.draw(in: CGRect(x: 0, y: 0, width: mainImageView.frame.size.width, height: mainImageView.frame.size.height), blendMode: CGBlendMode.normal, alpha: 1.0)
        tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: mainImageView.frame.size.width, height: mainImageView.frame.size.height), blendMode: CGBlendMode.normal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tempImageView.image = nil
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let settingsViewController = segue.destination as! SettingsViewController
        settingsViewController.delegate = self as! SettingsViewControllerDelegate
        settingsViewController.brush = brushWidth
        settingsViewController.opacity = opacity
        
        settingsViewController.red = red
        settingsViewController.green = green
        settingsViewController.blue = blue
    }*/
    
    //MARK: Actions
    
    @IBAction func reset(_ sender: Any) {
        mainImageView.image = UIImage(named: "icon1")
    }
    
    @IBAction func pencilPressed(_ sender: UIButton) {
        //1
        var index = sender.tag
        if index < 0 || index >= colors.count {
            index = 0
        }
        
        //2
        (red, green, blue) = colors[index]
        
        //3
        if index == colors.count - 1 {
            opacity = 1.0
            brushWidth = widthForErase
        }else {
            brushWidth = widthForBrush
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let settingsViewController = segue.destination as! SettingsViewController
        settingsViewController.delegate = self
        settingsViewController.brush = brushWidth
        settingsViewController.opacity = opacity
        
        settingsViewController.red = red
        settingsViewController.green = green
        settingsViewController.blue = blue
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
    
    extension AddDiaryViewController: SettingsViewControllerDelegate {
        func settingsViewControllerFinished(settingsViewController: SettingsViewController) {
            print("extension add diary")
            self.brushWidth = settingsViewController.brush
            //self.widthForBrush = self.brushWidth
            
            self.opacity = settingsViewController.opacity
            
            self.red = settingsViewController.red
            self.green = settingsViewController.green
            self.blue = settingsViewController.blue
        }

    }

