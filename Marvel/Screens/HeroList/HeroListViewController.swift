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
    
    /// Footer spinner
    private let spinner = UIActivityIndicatorView.make(started: true)
    
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
        table.dataSource = self
        table.separatorStyle = .none
        table.setEmptyViewText()
        table.backgroundView?.isHidden = false
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
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Marvel Heros"
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didSelectSearch))
        searchButton.accessibilityIdentifier = "trailingSearchButton"
        navigationItem.rightBarButtonItem = searchButton
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func setupBindings() {
        viewModel.heroes
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] newHeroes in
                guard let self = self, !newHeroes.isEmpty else { return }
                let offsetStart = self.heros.count
                self.tableView.setEmptyViewIfNeededFor(count: self.heros.count)
                self.heros.append(contentsOf: newHeroes)
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: newHeroes.enumerated().map({ IndexPath(row: offsetStart + $0.offset, section: 0)}), with: .automatic)
                self.tableView.endUpdates()
            }).store(in: &bag)
        spinner.visibilityBindedTo(viewModel, storedIn: &bag)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.isReachingEnd(aboveEnd: UIScreen.main.bounds.height) else { return }
          viewModel.loadNextPageIfPossible()
    }
    
    @objc private func didSelectSearch() {
        viewModel.didSelectSearch()
    }
}

extension HeroListViewController: UITableViewDataSource, UITableViewDelegate {
    
    /// Get a reference to the selected hero card view within the cell
    /// - Returns: The hero card view
    func getSelectedHeroCard() -> HeroCardView? {
        guard let indexPath = tableView.indexPathForSelectedRow,
              let cell = tableView.cellForRow(at: indexPath) as? HeroCell else { return nil }
        
        return cell.cardView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        spinner.wrapAndPin(top: UIConstants.spacingDouble, bottom: -UIConstants.spacingDouble)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let hero = heros[safe: indexPath.row] else { return }
        viewModel.didSelectHero(hero)
    }
    
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
