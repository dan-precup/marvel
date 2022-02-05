//
//  HeroListViewController.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 03/02/2022.
//

import UIKit
import Combine

final class HeroListViewController: UIViewController {
    
    /// The view model
    private let viewModel: HeroListViewModel
    
    /// Heros storage
    private var heros = [Hero]()
    
    /// Cancellable bag
    private var bag = Set<AnyCancellable>()
    
    /// Cell identitfier
    private let heroCellId = "heroCell"
    
    /// The tableview
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(HeroCell.self, forCellReuseIdentifier: heroCellId)
        table.delegate = self
        table.showsVerticalScrollIndicator = false
        table.contentInsetAdjustmentBehavior = .never
        table.dataSource = self
        table.separatorStyle = .none
        table.isPagingEnabled = true
        table.setEmptyViewText()
        return table
    }()
        
    /// Chevron image
    private let chevronImage = UIImageView.withSystemName("chevron.compact.down")
    
    /// Time progressbar
    private let progressBar = UIProgressView()
    
    /// Search button
    private let searchButton = UIButton()
    
    init(viewModel: HeroListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.didFinishLoading()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        tableView.addAndPinAsSubview(of: view)
        navigationController?.setNavigationBarHidden(true, animated: false)
        searchButton
            .tinted(.white)
            .dimensions(width: 20, height: 20)
            .setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        
        let progressWrapper = progressBar
            .rounded()
            .height(10)
            .wrapAndCenterKeepingDimensions()
            
        
        [progressWrapper, searchButton]
            .hStack(spacing: UIConstants.spacing)
            .constrained()
            .addAsSubview(of: view)
            .top(toSafeAreaOf: view, constant: UIConstants.spacing)
            .leading(to: view, constant: UIConstants.spacingDouble)
            .trailing(to: view, constant: -UIConstants.spacingDouble)
    }
    
    private func setupBindings() {
        viewModel.heroes
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] newHeroes in
                self?.heros.append(contentsOf: newHeroes)
                self?.tableView.reloadData()
            }).store(in: &bag)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.isReachingEnd(aboveEnd: UIScreen.main.bounds.height) else { return }
          viewModel.loadNextPageIfPossible()
    }
}

extension HeroListViewController: UITableViewDelegate {
    
}

extension HeroListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        heros.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let hero = heros[safe: indexPath.row],
                let cell = tableView.dequeueReusableCell(withIdentifier: heroCellId, for: indexPath) as? HeroCell
        else { return UITableViewCell() }
        cell.setHero(hero)
        return cell
    }
}
