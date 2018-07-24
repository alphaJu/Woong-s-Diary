//
//  CollectionViewController.swift
//  customCalendar2
//
//  Created by 예주 on 2018. 7. 24..
//  Copyright © 2018년 Hanung Lee. All rights reserved.
//

import UIKit
import AnimatedCollectionViewLayout
import RealmSwift

private let reuseIdentifier = "MyCell"

class CollectionViewController: UICollectionViewController {
    
    var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    var date:String?
    var days: [String] = []
    var carImages = [String]()
    var animator: (LayoutAttributesAnimator, Bool, Int, Int)?
    var Test: Int = 0
    //    var direction: UICollectionViewScrollDirection = .horizontal
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        //      self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier) // 주석처리
        
        // Do any additional setup after loading the view.
        
        carImages = ["image1.jpg", "image2.jpg", "image3.jpg", "image1.jpg", "image2.jpg", "image3.jpg", "image1.jpg"]
        
        self.collectionView?.isPagingEnabled = false
        self.collectionView?.isScrollEnabled = true
        
        animator = (LinearCardAttributesAnimator(), false, 1, 1)
        
        if let layout = self.collectionView?.collectionViewLayout as? AnimatedCollectionViewLayout {
            layout.animator = animator?.0
        }
        
        if let layout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func didSwipeDown(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return carImages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        //        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        // Configure the cell
        
        if(Test < 7){
            
            let image = UIImage(named: "icon1")
            let image2 = UIImage(named: "detailbackground")
            cell.imageView.image = image
            cell.mainImageView.image = image2
            let realm = try! Realm()
            let predicate = NSPredicate(format: "date = %@",days[Test])
            let day = realm.objects(cellinfo.self).filter(predicate).first
            if(day?.filepath != nil){
                cell.imageView.image = load(fileName: (day!.filepath))
                cell.mainImageView.image = load(fileName: (day!.detail))
                print("testpoint: \(Test)")
                
            }
            
        }
        
        //        cell.today.text = (String)((Int)(date!)! + Test)
        Test += 1
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MyHeader", for: indexPath)
        return headerView
    }
    
    private func load(fileName: String) -> UIImage? {
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
    
    private func save(image: UIImage) -> String? {
        let fileName = date!
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        if let imageData = UIImageJPEGRepresentation(image, 1.0) {
            try? imageData.write(to: fileURL, options: .atomic)
            return fileName // ----> Save fileName
        }
        
        print("Error saving image")
        return nil
    }
    
    
    @IBAction func editPressed(_ sender: UIButton) {
        if(self.collectionView?.isScrollEnabled == true){
            self.collectionView?.isScrollEnabled = false
        }
        else{
            self.collectionView?.isScrollEnabled = true
        }
        
    }
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}

