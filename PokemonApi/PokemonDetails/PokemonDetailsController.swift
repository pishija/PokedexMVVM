//
//  PokemonDetailsController.swift
//  PokemonApi
//
//  Created by Mihail Stevcev on 20/05/2024.
//

import UIKit
import Combine
import Observation

class PokemonDetailsView: UIView {
    
    let titleLabel: UILabel = {
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
        
        view.addSubview(self.titleLabel)
        
        self.titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        self.titleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(self.idLabel)
        
        self.idLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 3.0).isActive = true
        self.idLabel.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor).isActive = true
        self.idLabel.trailingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor).isActive = true
        self.idLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
//        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
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
        view.titleLabel.text = "Height"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let weightView: AttributeView = {
        let view = AttributeView()
        view.titleLabel.text = "Weight"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let orderView: AttributeView = {
        let view = AttributeView()
        view.titleLabel.text = "Order"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let experienceView: AttributeView = {
        let view = AttributeView()
        view.titleLabel.text = "Experience"
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
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.imageView)
        
        self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor, multiplier: 1.0).isActive = true
        
        self.addSubview(self.titleContainer)
        
        self.titleContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//        self.titleContainer.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        self.titleContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.titleContainer.bottomAnchor.constraint(equalTo: self.imageView.bottomAnchor).isActive = true
        
        self.addSubview(self.typesStack)
        self.typesStack.topAnchor.constraint(equalTo: self.titleContainer.bottomAnchor, constant: 12.0).isActive = true
        self.typesStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20.0).isActive = true
//        self.typesStack.trailingAnchor.constraint(greaterThanOrEqualTo: self.trailingAnchor, constant: -20.0).isActive = true
        self.typesStack.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        
        self.addSubview(self.attributesContainer)
        self.attributesContainer.topAnchor.constraint(equalTo: self.typesStack.bottomAnchor, constant: 24.0).isActive = true
        self.attributesContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20.0).isActive = true
        self.attributesContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20.0).isActive = true
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func add(type: String) {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.layer.cornerRadius = 3.0
        label.layer.borderWidth = 1.0
        label.text = String(format: "   %@   ", type)
        
        self.typesStack.addArrangedSubview(label)
    }
}

class PokemonDetailsController: UIViewController {
    
    private lazy var pokemonView: PokemonDetailsView = {
        let view = PokemonDetailsView()
        return view
    }()
    
    let pokemon: PokemonViewModel
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(pokemon: PokemonViewModel) {
        self.pokemon = pokemon
        super.init(nibName: nil, bundle: nil)
        
        self.pokemon.$name.sink { newName in
            self.pokemonView.titleLabel.text = newName
        }
        .store(in: &subscriptions)
        
        self.pokemon.$imageUrl.sink { imageUrl in
            if let url = imageUrl {
                DispatchQueue.global().async { [weak self] in
                    if let data = try? Data(contentsOf: url) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self?.pokemonView.imageView.image = image
                            }
                        }
                    }
                }
            }
        }
        .store(in: &subscriptions)
        
        self.pokemon.$id.sink { pokemonId in
            self.pokemonView.idLabel.text = pokemonId
        }
        .store(in: &subscriptions)
        
        self.pokemon.$types.sink { types in
            for type in types {
                self.pokemonView.add(type: type)
            }
        }
        .store(in: &subscriptions)
        
        self.pokemon.$height.sink { height in
            DispatchQueue.main.async {
                self.pokemonView.heightView.valueLabel.text = height
            }
        }
        .store(in: &subscriptions)
        
        self.pokemon.$weight.sink { weight in
            DispatchQueue.main.async {
                self.pokemonView.weightView.valueLabel.text = weight
            }
        }
        .store(in: &subscriptions)
        
        self.pokemon.$experience.sink { experience in
            self.pokemonView.experienceView.valueLabel.text = experience
        }
        .store(in: &subscriptions)
        
        self.pokemon.$order.sink { order in
            self.pokemonView.orderView.valueLabel.text = order
        }
        .store(in: &subscriptions)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View lifecycle
    
    override func loadView() {
        self.view = self.pokemonView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
//        self.view.backgroundColor = UIColor.yellow
        
//        self.pokemonView.titleLabel.text = self.pokemon.name
//        self.pokemon.setName()
    }
    
    
}


class PokemonViewModel: ObservableObject {
    
    let pokemon: Pokemon
    
    @Published var name: String = ""
    @Published var imageUrl: URL?
    @Published var id: String = ""
    @Published var types: [String] = []
    @Published var height: String = ""
    @Published var weight: String = ""
    @Published var order: String = ""
    @Published var experience: String = ""

    var pokemonDetails: PokemonDetails?
    
    private (set) var request: APIRequest<PokemonDetailsResource>?
    
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
        
        self.request = APIRequest(resource: PokemonDetailsResource(pokemon: pokemon))
        self.request?.execute(withCompletion: { pokemonDetails, error in
            guard error == nil else {
                
                return
            }
            
            guard pokemonDetails != nil else {
                
                return
            }
            self.pokemonDetails = pokemonDetails
            self.name = pokemonDetails!.name
            self.id = "Nº".appendingFormat("%.3d", pokemonDetails!.id)
            self.imageUrl = pokemonDetails?.sprites.front_default
            self.types = pokemonDetails!.types.map({ $0.type.name })
            self.height = String(format: "%0.1f m", pokemonDetails!.height / 10)
            self.weight = String(format: "%0.1f kg", pokemonDetails!.weight / 10)
            self.order = String(pokemonDetails!.order)
            self.experience = String(pokemonDetails!.base_experience)
        })
        
        
    }
    
    func setName() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.name = "12312313131"
        }
        
        
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
        fatalError("init(coder:) has not been implemented")
    }
}
