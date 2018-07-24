//
//  DiaryPhotoCell.swift
//  customCalendar2
//
//  Created by Hanung Lee on 25/07/2018.
//  Copyright © 2018 Hanung Lee. All rights reserved.
//

import UIKit

class DiaryPhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imageName: String! {
        //imageName이 설정되었을 때 호출되는 함수
        didSet{
            //   photoImageView.image = UIImage(named:)
        }
    }
    
}
