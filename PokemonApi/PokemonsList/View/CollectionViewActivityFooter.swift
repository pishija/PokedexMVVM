//
//  CollectionViewActivityFooter.swift
//  PokemonApi
//
//  Created by Mihail Stevcev on 21/05/2024.
//

import UIKit

class CollectionViewActivityFooter: UICollectionReusableView {
    
    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.tintColor = UIColor.gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        
        self.activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError(StringConstants.initCoderNotImplemented)
    }
    
}
