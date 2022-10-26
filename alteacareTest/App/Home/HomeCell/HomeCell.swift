//
//  HomeCell.swift
//  alteacareTest
//
//  Created by Edit sanrio Putra on 26/10/22.
//

import UIKit

class HomeCell : UICollectionViewCell {
    
    static let identifier = "HomeCell"
    
    var backgroundLayer: UIView = {
        let bgView = UIView()
        bgView.clipsToBounds = true
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.backgroundColor = .gray
        return bgView
    }()
    
    var containerImage: UIView = {
        let container = UIView()
        container.backgroundColor = .white
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    var profileImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var doctorName: UILabel = {
        let name = UILabel()
        name.font = .systemFont(ofSize: 12)
        name.numberOfLines = 0
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    var hospitalName: UILabel = {
        let name = UILabel()
        name.font = .systemFont(ofSize: 12)
        name.numberOfLines = 0
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    var specializationName: UILabel = {
        let name = UILabel()
        name.font = .systemFont(ofSize: 12)
        name.numberOfLines = 0
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    var aboutDoctor: UILabel = {
        let name = UILabel()
        name.font = .systemFont(ofSize: 14)
        name.numberOfLines = 0
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()

    var priceLabel: UILabel = {
        let name = UILabel()
        name.font = .systemFont(ofSize: 12)
        name.numberOfLines = 0
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    override func layoutSubviews() {
        //background constraint
        contentView.addSubview(backgroundLayer)
        backgroundLayer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        backgroundLayer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        backgroundLayer.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        backgroundLayer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        //photo container constraint
        backgroundLayer.addSubview(containerImage)
        containerImage.leadingAnchor.constraint(equalTo: backgroundLayer.leadingAnchor).isActive = true
        containerImage.topAnchor.constraint(equalTo: backgroundLayer.topAnchor).isActive = true
        containerImage.bottomAnchor.constraint(equalTo: backgroundLayer.bottomAnchor).isActive = true
        containerImage.widthAnchor.constraint(equalToConstant: 120).isActive = true
        containerImage.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        //photo constraint
        containerImage.addSubview(profileImage)
        profileImage.leadingAnchor.constraint(equalTo: containerImage.leadingAnchor).isActive = true
        profileImage.topAnchor.constraint(equalTo: containerImage.topAnchor).isActive = true
        profileImage.bottomAnchor.constraint(equalTo: containerImage.bottomAnchor).isActive = true
        profileImage.trailingAnchor.constraint(equalTo: containerImage.trailingAnchor).isActive = true
        
        //doctor name constraint
        backgroundLayer.addSubview(doctorName)
        doctorName.topAnchor.constraint(equalTo: backgroundLayer.topAnchor, constant: 24).isActive = true
        doctorName.leadingAnchor.constraint(equalTo: containerImage.trailingAnchor, constant: 8).isActive = true
        doctorName.trailingAnchor.constraint(equalTo: backgroundLayer.trailingAnchor,constant: -16).isActive = true
        
        //hospital name constraint
        backgroundLayer.addSubview(hospitalName)
        hospitalName.topAnchor.constraint(equalTo: doctorName.bottomAnchor, constant: 6).isActive = true
        hospitalName.leadingAnchor.constraint(equalTo: doctorName.leadingAnchor).isActive = true
        hospitalName.trailingAnchor.constraint(equalTo: doctorName.trailingAnchor).isActive = true
        
        //specialization name constraint
        backgroundLayer.addSubview(specializationName)
        specializationName.topAnchor.constraint(equalTo: hospitalName.bottomAnchor, constant: 6).isActive = true
        specializationName.leadingAnchor.constraint(equalTo: doctorName.leadingAnchor).isActive = true
        specializationName.trailingAnchor.constraint(equalTo: doctorName.trailingAnchor).isActive = true
        
        //about constraint
        backgroundLayer.addSubview(aboutDoctor)
        aboutDoctor.topAnchor.constraint(equalTo: specializationName.bottomAnchor, constant: 10).isActive = true
        aboutDoctor.leadingAnchor.constraint(equalTo: doctorName.leadingAnchor).isActive = true
        aboutDoctor.trailingAnchor.constraint(equalTo: doctorName.trailingAnchor).isActive = true
        
        //price constraint
        backgroundLayer.addSubview(priceLabel)
//        priceLabel.topAnchor.constraint(equalTo: aboutDoctor.bottomAnchor,constant: 6).isActive = true
        priceLabel.bottomAnchor.constraint(equalTo: backgroundLayer.bottomAnchor, constant: -8).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: backgroundLayer.trailingAnchor, constant: -8).isActive = true
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var home: HomeItemDto? {
              didSet {
                   guard let home = home else { return }
                  profileImage.sd_setImage(with: URL(string: home.photo.formats.small), placeholderImage: nil)
                  doctorName.text = home.name
                  for hospitalList in home.hospital {
                      hospitalName.text = hospitalList.name
                  }
                  specializationName.text = home.specialization.name
                  aboutDoctor.text = home.about
                  aboutDoctor.attributedText = aboutDoctor.text?.htmlToAttributedString
                  priceLabel.text = home.price.formatted
              }
         }
    
    
}

