//
//  PokemonCell.swift
//  PokemonApi
//
//  Created by Mihail Stevcev on 20/05/2024.
//

import UIKit
import Combine

class PokemonCell: UICollectionViewCell {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        return label
    }()
    
    private lazy var titleContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(self.nameLabel)
        
        self.nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.nameLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView  = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var subscriptions = Set<AnyCancellable>()
    
    var viewModel: PokemonViewModel? {
        didSet {
            if let pokemon = viewModel {
                pokemon.$name.sink { name in
                    DispatchQueue.main.async {
                        self.set(name)
                    }
                }
                .store(in: &subscriptions)
                
                pokemon.$image.sink { image in
                    DispatchQueue.main.async {
                        self.set(image)
                    }
                }
                .store(in: &subscriptions)
            }
            
        }
    }
    
    //MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.cornerRadius = 4.0
        self.contentView.clipsToBounds = true
        
        self.contentView.addSubview(self.imageView)
        
        self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor, multiplier: 1.0).isActive = true
        
        self.contentView.addSubview(self.titleContainer)
        
        self.titleContainer.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        self.titleContainer.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        self.titleContainer.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        self.titleContainer.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError(StringConstants.initCoderNotImplemented)
    }
    
    //MARK: Overrides
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageView.image = nil
    }
    
    //MARK: Interface
    
    func set(_ name: String?) {
        self.nameLabel.text = name
    }
    
    func set(_ image: UIImage?) {
        self.imageView.image = image
    }
}
