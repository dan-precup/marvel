//
//  HeroDetailsViewController.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 06/02/2022.
//

import Combine
import UIKit
import AVKit

final class HeroDetailsViewController: UIViewController {
    
    private struct Constants {
        static let heroNameSize: CGFloat = 30
    }
    
    /// Local cell container
    private var cells = [HeroDetailsCells]()

    /// The view model
    private let viewModel: HeroDetailsViewModelImpl
    
    /// Footer spinner
    private let spinner = UIActivityIndicatorView.make(started: true)

    private var bag = Set<AnyCancellable>()
    private var videoLooper: AVPlayerLooper?
    private let videoView = UIView()

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
        table.showsVerticalScrollIndicator = false
        table.contentInsetAdjustmentBehavior = .never
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.didFinishLoading()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let videoURL = Bundle.main.url(forResource: "bgVideo", withExtension: "mp4") else { return }
        let asset = AVAsset(url: videoURL)
        let item = AVPlayerItem(asset: asset)
        let player = AVQueuePlayer(playerItem: item)
        videoLooper = AVPlayerLooper(player: player, templateItem: item)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = videoView.bounds
        playerLayer.videoGravity = .resizeAspectFill
        videoView.layer.addSublayer(playerLayer)
        player.volume = 0
        player.play()
    }
    

    private func setupUI() {
        view.backgroundColor = .systemBackground
        videoView.addAndPinAsSubview(of: view)
        UIView().background(.black.withAlphaComponent(0.8))
            .addAndPinAsSubview(of: view)
        tableView
            .background(.clear)
            .wrapAndPin(padding: UIConstants.spacingDouble)
            .addAndPinAsSubview(of: view)
            .rounded(radius: UIConstants.radiusLarge)
            .background(.systemGroupedBackground)
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
//        viewModel.loadNextPageIfPossible()
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
        case .imageAndName(let thumbURL, let heroName):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: nameImageCellId, for: indexPath) as? HeroDetailsNameImageCell
            else { return UITableViewCell() }
            cell.setData(imageURL: thumbURL, name: heroName)
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
