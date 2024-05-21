//
//  PokemonListController.swift
//  PokemonApi
//
//  Created by Mihail Stevcev on 20/05/2024.
//

import UIKit
import Combine

protocol PokemonListViewDelegate: AnyObject {
    func pokemon(listView: PokemonListView, didSelect index: Int)
    func pokemon(listVIew: PokemonListView, willDisplayLast cell: UICollectionViewCell)
}

protocol PokemonListViewDataSource: UICollectionViewDataSource {
    // This a facade protocol
}

class PokemonListView: UIView, UICollectionViewDelegateFlowLayout {
    
    weak var delegate: PokemonListViewDelegate?
    weak var dataSource: PokemonListViewDataSource? {
        didSet {
            self.collectionView.dataSource = self.dataSource
        }
    }
    
    private lazy var flowlayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10.0
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.flowlayout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        
        let cellIdentifier = String(describing: PokemonCell.self)
        view.register(PokemonCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        let footerViewIndetifier = String(describing: CollectionViewActivityFooter.self)
        view.register(CollectionViewActivityFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerViewIndetifier)
        
        return view
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.systemRed
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.style = .medium
        view.isHidden = true
        view.tintColor = UIColor.gray
        return view
    }()
    
    //MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        self.addSubview(self.errorLabel)
        self.errorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20.0).isActive = true
        self.errorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        self.errorLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.addSubview(self.collectionView)
        self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.addSubview(self.activityIndicator)
        self.activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError(StringConstants.initCoderNotImplemented)
    }
    
    //MARK: Interface
    
    func reloadData() {
        self.collectionView.reloadData()
    }
    
    func show(_ errorMessage: String?) {
        self.errorLabel.text = errorMessage
        self.errorLabel.isHidden = errorMessage == nil
        self.collectionView.isHidden = errorMessage != nil
    }
    
    func setActivityIndicator(hidden: Bool) {
        self.activityIndicator.isHidden = hidden
        if hidden {
            self.activityIndicator.stopAnimating()
        } else {
            self.activityIndicator.startAnimating()
        }
    }
    
    var bottomLoadingHidden: Bool = true {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    //MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width - 40) / 3.0
        return CGSize(width: size, height: size + 40.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.pokemon(listView: self, didSelect: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.bottomLoadingHidden {
            return CGSize(width: 0.0, height: 0.0)

        } else {
            return CGSize(width: collectionView.frame.width, height: 40.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastSection = collectionView.numberOfSections - 1
        let lastItem = collectionView.numberOfItems(inSection: lastSection) - 1
            
        if indexPath.section == lastSection && indexPath.item == lastItem {
            self.delegate?.pokemon(listVIew: self, willDisplayLast: cell)
        }
    }
    
}

protocol PokemonListControllerDelegate: AnyObject {
    func pokemonList(controller: PokemonListController, didSelect pokemon: PokemonViewModel)
}

class PokemonListController: UIViewController, PokemonListViewDataSource, PokemonListViewDelegate {
    
    private lazy var pokemonListView: PokemonListView = {
        let view = PokemonListView()
        view.dataSource = self
        view.delegate = self
        
        return view
    }()
    
    private var viewModel: PokemonListViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    weak var delegate: PokemonListControllerDelegate?

    //MARK: Initialization
    
    init(viewModel: PokemonListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.$datasource.sink { [weak self] pokemonViewModels in
            self?.pokemonListView.reloadData()
        }
        .store(in: &subscriptions)
        
        self.viewModel.$errorMessage.sink { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.pokemonListView.show(errorMessage)
            }
        }
        .store(in: &subscriptions)
        
        self.viewModel.$showLoading.sink { [weak self] showLoading in
            DispatchQueue.main.async {
                self?.pokemonListView.setActivityIndicator(hidden: !showLoading)
            }
        }
        .store(in: &subscriptions)
        
        self.viewModel.$showBottomLoading.sink { [weak self] showLoading in
            DispatchQueue.main.async {
                self?.pokemonListView.bottomLoadingHidden = !showLoading
            }
        }
        .store(in: &subscriptions)
    }
    
    required init?(coder: NSCoder) {
        fatalError(StringConstants.initCoderNotImplemented)
    }
    
    //MARK: View lifecycle
    
    override func loadView() {
        self.view = self.pokemonListView
    }
    
    //MARK: CollectionViewDatasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier = String(describing: PokemonCell.self)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PokemonCell
        
        let pokemonViewModel = self.viewModel.datasource[indexPath.row]
        cell.viewModel = pokemonViewModel
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let identifier = String(describing: CollectionViewActivityFooter.self)
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier, for: indexPath)
        
        return view
    }
    
    //MARK: PokemonListViewDelegate
    
    func pokemon(listView: PokemonListView, didSelect index: Int) {
        let pokemonViewModel = self.viewModel.datasource[index]
        self.delegate?.pokemonList(controller: self, didSelect: pokemonViewModel)
    }
    
    func pokemon(listVIew: PokemonListView, willDisplayLast cell: UICollectionViewCell) {
        self.viewModel.loadNextPage()
    }
}
