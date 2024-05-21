//
//  PokemonDetailsView.swift
//  PokemonApi
//
//  Created by Mihail Stevcev on 21/05/2024.
//

import UIKit

class PokemonDetailsView: UIView {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    
    let idLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        return label
    }()
    
    private lazy var titleContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(self.nameLabel)
        
        self.nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0).isActive = true
        self.nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0).isActive = true
        self.nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        view.addSubview(self.idLabel)
        
        self.idLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 3.0).isActive = true
        self.idLabel.leadingAnchor.constraint(equalTo: self.nameLabel.leadingAnchor).isActive = true
        self.idLabel.trailingAnchor.constraint(equalTo: self.nameLabel.trailingAnchor).isActive = true
        self.idLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
                
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView  = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let typesStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .fill
        view.spacing = 6.0
        view.distribution = .fill
        return view
    }()
    
    let heightView: AttributeView = {
        let view = AttributeView()
        view.titleLabel.text = NSLocalizedString("Height", comment: "")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let weightView: AttributeView = {
        let view = AttributeView()
        view.titleLabel.text = NSLocalizedString("Weight", comment: "")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let orderView: AttributeView = {
        let view = AttributeView()
        view.titleLabel.text = NSLocalizedString("Order", comment: "")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let experienceView: AttributeView = {
        let view = AttributeView()
        view.titleLabel.text = NSLocalizedString("Experience", comment: "")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var attributesContainer = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self.heightView)
        
        
        heightView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        heightView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        view.addSubview(self.weightView)
        weightView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        weightView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        weightView.leadingAnchor.constraint(equalTo: heightView.trailingAnchor, constant: 20.0).isActive = true
        weightView.widthAnchor.constraint(equalTo: heightView.widthAnchor).isActive = true
        
        view.addSubview(self.orderView)
        orderView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        orderView.topAnchor.constraint(equalTo: heightView.bottomAnchor, constant: 10.0).isActive = true
        orderView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(self.experienceView)
        experienceView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        experienceView.topAnchor.constraint(equalTo: orderView.topAnchor).isActive = true
        experienceView.leadingAnchor.constraint(equalTo: orderView.trailingAnchor, constant: 20.0).isActive = true
        experienceView.widthAnchor.constraint(equalTo: orderView.widthAnchor).isActive = true
        experienceView.bottomAnchor.constraint(equalTo: orderView.bottomAnchor).isActive = true
        
        return view
    }()
    
    //MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        self.addSubview(self.imageView)
        
        self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor, multiplier: 1.0).isActive = true
        
        self.addSubview(self.titleContainer)
        
        self.titleContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.titleContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.titleContainer.topAnchor.constraint(equalTo: self.imageView.bottomAnchor).isActive = true
        
        self.addSubview(self.typesStack)
        self.typesStack.topAnchor.constraint(equalTo: self.titleContainer.bottomAnchor, constant: 12.0).isActive = true
        self.typesStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20.0).isActive = true
        self.typesStack.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        
        self.addSubview(self.attributesContainer)
        self.attributesContainer.topAnchor.constraint(equalTo: self.typesStack.bottomAnchor, constant: 24.0).isActive = true
        self.attributesContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20.0).isActive = true
        self.attributesContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20.0).isActive = true
    
    }
    
    required init?(coder: NSCoder) {
        fatalError(StringConstants.initCoderNotImplemented)
    }
    
    //MARK: Interface
    
    func add(type: String) {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.layer.cornerRadius = 3.0
        label.layer.borderWidth = 1.0
        label.text = String(format: "   %@   ", type)
        
        self.typesStack.addArrangedSubview(label)
    }
}

class AttributeView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.borderWidth = 1.0
        label.layer.cornerRadius = 4.0
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.titleLabel)
        
        self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        self.addSubview(self.valueLabel)
        
        self.valueLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.valueLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 4.0).isActive = true
        self.valueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.valueLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError(StringConstants.initCoderNotImplemented)
    }
}
