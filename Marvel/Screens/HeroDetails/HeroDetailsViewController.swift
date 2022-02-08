//
//  HeroDetailsViewController.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 06/02/2022.
//

import Combine
import UIKit

final class HeroDetailsViewController: UIViewController {
    
    private struct Constants {
        static let heroNameSize: CGFloat = 30
        static let topConstraintForCloseButton: CGFloat = 50
    }
    
    /// Local cell container
    private var cells = [HeroDetailsCells]()

    /// The view model
    private let viewModel: HeroDetailsViewModelImpl
    
    /// Footer spinner
    private let spinner = UIActivityIndicatorView.make(started: true)

    private var bag = Set<AnyCancellable>()
    
    private let closeButton = UIButton()

    /// Cell ids
    private let statsCellId = "statsCellId"
    private let nameImageCellId = "nameImageCellId"
    private let sectionTitleCellId = "sectionTitleCellId"
    private let largeTextCellId = "largeTextCellId"
    private let comicCellId = "comicCellId"

    /// The tableview
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(HeroDetailsStatsCell.self, forCellReuseIdentifier: statsCellId)
        table.register(HeroDetailsNameImageCell.self, forCellReuseIdentifier: nameImageCellId)
        table.register(SectionTitleCell.self, forCellReuseIdentifier: sectionTitleCellId)
        table.register(LargeTextCell.self, forCellReuseIdentifier: largeTextCellId)
        table.register(HeroDetailsComicCell.self, forCellReuseIdentifier: comicCellId)
        table.delegate = self
        table.contentInsetAdjustmentBehavior = .never
        table.showsVerticalScrollIndicator = false
        table.dataSource = self
        table.separatorStyle = .none
        table.setEmptyViewText()
        return table
    }()
    
    init(viewModel: HeroDetailsViewModelImpl) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.didFinishLoading()
    }

    private func setupUI() {
        view.backgroundColor = .clear
        tableView
            .background(.systemGroupedBackground)
            .addAndPinAsSubview(of: view)
        closeButton
            .identifier("closeButton")
            .constrained()
            .addAsSubview(of: view)
            .top(to: view, constant: Constants.topConstraintForCloseButton)
            .trailing(to: view, constant: -UIConstants.spacingTripe)
            .tinted(.white)
            .setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        closeButton.addTarget(self, action: #selector(didSelectCloseButton), for: .touchUpInside)
        closeButton.isHidden = !isBeingPresented
    }
    
    private func setupBindings() {
        viewModel.cells.receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] newCells in
                self?.cells = newCells
                self?.tableView.reloadData()
            }).store(in: &bag)
        spinner.visibilityBindedTo(viewModel, storedIn: &bag)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.isReachingEnd() else { return }
        viewModel.loadNextPageIfPossible()
    }
    
    
    @objc private func didSelectCloseButton() {
        dismiss(animated: true, completion: nil)
    }
}

extension HeroDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        spinner.wrapAndPin(top: UIConstants.spacingDouble, bottom: -UIConstants.spacingDouble)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellType = cells[safe: indexPath.row] else { return UITableViewCell() }
        switch cellType {
        case .imageAndName(let hero):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: nameImageCellId, for: indexPath) as? HeroDetailsNameImageCell
            else { return UITableViewCell() }
            cell.setHero(hero)
            return cell
        case .stats(let hero):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: statsCellId, for: indexPath) as? HeroDetailsStatsCell
            else { return UITableViewCell() }
            cell.setHero(hero)
            return cell
        case .description(let description):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: largeTextCellId, for: indexPath) as? LargeTextCell
            else { return UITableViewCell() }
            cell.setText(description)
            return cell
        case .title(let title):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: sectionTitleCellId, for: indexPath) as? SectionTitleCell
            else { return UITableViewCell() }
            cell.setTitle(title)
            return cell
        case .comic(let comic):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: comicCellId, for: indexPath) as? HeroDetailsComicCell
            else { return UITableViewCell() }
            cell.setComic(comic)
            return cell
        }
    }
    
    
}
