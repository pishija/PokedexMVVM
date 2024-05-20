//
//  PokemonListController.swift
//  PokemonApi
//
//  Created by Mihail Stevcev on 20/05/2024.
//

import UIKit

class PokemonListView: UIView {
    
    private lazy var flowlayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.flowlayout)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let cellIdentifier = String(describing: PokemonCell.self)
//        view.register(PokemonCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        view.register(PokemonCell.self, forCellWithReuseIdentifier: cellIdentifier)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.collectionView)
        self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PokemonCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(self.titleLabel)
        
        self.titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.titleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView  = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.imageView)
        
        self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.contentView.addSubview(self.titleContainer)
        
        self.titleContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.titleContainer.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        self.titleContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PokemonListController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var pokemons: [Pokemon] = [Pokemon(name: "testicals", url: URL(string: "https://www.asd.csm")!), Pokemon(name: "more testicals", url: URL(string: "https://www.asd.csm")!)]
    
    private lazy var pokemonListView: PokemonListView = {
        let view = PokemonListView()
        view.collectionView.delegate = self
        view.collectionView.dataSource = self
        
        return view
    }()
    
    override func loadView() {
        self.view = self.pokemonListView
    }
    
    private var request: APIRequest<PokemonsResource>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let resource = PokemonsResource()
        let request = APIRequest(resource: resource)
        
        request.execute { response, error in
            guard error == nil else {
                print("error \(error?.localizedDescription)")
                return
            }
            
            if let pokemons = response?.results {
                self.pokemons = pokemons
                self.pokemonListView.collectionView.reloadData()
            }
        }
        
        self.request = request
        
        
//        let
        
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        label.text = "Asdadad"
//        label.textColor = UIColor.white
        
//        self.view.addSubview(label)
        
        self.view.backgroundColor = UIColor.yellow
    }
    
    //MARK: CollectionViewDatasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier = String(describing: PokemonCell.self)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PokemonCell
        let pokemon = self.pokemons[indexPath.row]
        
        cell.titleLabel.text = pokemon.name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pokemon = self.pokemons[indexPath.row]
        let pokemonViewModel = PokemonViewModel(pokemon: pokemon)
        let controller = PokemonDetailsController(pokemon: pokemonViewModel)
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    
}


struct PokemonResponse<Data: Codable>: Codable {
    let count: Int
    let next: URL?
    let previous: URL?
    let results: Data?
}


public final class PokemonApiNetwork {
    
    fileprivate static let session: URLSession = {
        // Here you can adjust the session configuration by your likings
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration)
    }()
    
//    public static var apiKey: String?
}
