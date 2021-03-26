//
//  UserCVCell.swift
//  KosmosAssignment
//
//  Created by Hitesh on 25/03/21.
//

import UIKit

class UserCVCell: UICollectionViewCell {
    
    @IBOutlet private weak var imgProfile:UIImageView!
    @IBOutlet private weak var lblName:UILabel!
    @IBOutlet private weak var lblEmail:UILabel!
    
    static let reusableIdentifier = "UserCVCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "UserCVCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgProfile.layer.cornerRadius = imgProfile.bounds.height/2
        imgProfile.layer.borderWidth = 3
        imgProfile.layer.borderColor = UIColor.link.cgColor
        imgProfile.clipsToBounds = true
    }
    func configureCell(user:User) {
        lblName.text = user.firstName + " " + (user.lastName ?? "")
        lblEmail.text = user.email
        imgProfile.image = UIImage(systemName: "person.circle.fill")
        guard let avatar = user.avatar, let url = URL(string: avatar)  else { return }
        imgProfile.loadImage(url: url)
    }
}
