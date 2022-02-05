//
//  SearchViewController.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 05/02/2022.
//

import Foundation

import UIKit
import Combine

final class SearchViewController: UIViewController {
    private var bag = Set<AnyCancellable>()
    
    /// Footer spinner
    private let spinner = UIActivityIndicatorView.make(started: true)
    
    /// The view model
    private let viewModel: SearchViewModel
    
    /// Blured backgound
    private let blurBackground = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
    
    /// The searcg textfield
    private let searchTextfield = UITextField()
    
    /// Cell id
    private let searchCellResultId = "searchCellResultId"
    
    /// Search results container
    private var searchResults = [SearchResult]()
    
    /// The close button
    private let closeButton = UIButton()
    /// The tableview
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(SearchResultCell.self, forCellReuseIdentifier: searchCellResultId)
        table.delegate = self
        table.showsVerticalScrollIndicator = false
        table.dataSource = self
        table.separatorStyle = .none
        table.setEmptyViewText()
        return table
    }()
        
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: UIConstants.animationDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.blurBackground.alpha = 1
            self.searchTextfield.transform = .identity
            self.closeButton.transform = .identity
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    /// Setup the UI
    private func setupUI() {
        blurBackground.addAndPinAsSubview(of: view)
            .opacity(0)
        setupSearchTextField()
        tableView
            .background(.clear)
            .constrained()
            .addAsSubview(of: view)
            .topToBottom(of: searchTextfield, constant: UIConstants.spacingDouble)
            .pinHorizontaly(to: view, padding: UIConstants.spacingDouble)
            .bottom(toSafeAreaOf: view, constant: -UIConstants.spacing)
        
        spinner.color = .white
        
        closeButton
            .constrained()
            .addAsSubview(of: view)
            .topTrailingCorner(to: view, top: 0, trailing: -UIConstants.spacingTripe)
            .tinted(.white)
            .setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        closeButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        closeButton.addTarget(self, action: #selector(didSelectCloseButton), for: .touchUpInside)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.isReachingEnd() else { return }
        viewModel.loadNextPageIfPossible()
    }
    
    /// Setup the search field
    private func setupSearchTextField() {
        searchTextfield.attributedPlaceholder = NSAttributedString(string: " Search...", attributes: [.foregroundColor: UIColor.white])
        searchTextfield.leftView = UIImageView.withSystemName("magnifyingglass")
        searchTextfield.leftViewMode = .always
        searchTextfield.textColor = .white
        searchTextfield.transform = CGAffineTransform(translationX: 0, y: -200)
        searchTextfield
            .underlined(ofColor: .white)
            .height(UIConstants.inputHeight)
            .tinted(.white)
            .constrained()
            .addAsSubview(of: view)
            .top(toSafeAreaOf: view, constant: UIConstants.spacingDouble)
            .pinHorizontaly(to: view, padding: UIConstants.spacingQuadruple)
        searchTextfield.addTarget(self, action: #selector(didEditTextfield), for: .editingChanged)
    }
    
    /// Setup bindings
    private func setupBindings() {
        viewModel.results
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] results in
                self?.searchResults = results
                self?.tableView.reloadData()
            }).store(in: &bag)
        spinner.visibilityBindedTo(viewModel, storedIn: &bag)
    }
    
    /// Close button handler
    @objc private func didSelectCloseButton() {
        UIView.animate(withDuration: UIConstants.animationDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.searchTextfield.transform = CGAffineTransform(translationX: 0, y: -200)
            self.searchTextfield.alpha = 0
            self.closeButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            self.blurBackground.alpha = 0
            self.tableView.alpha = 0
        }, completion: { _ in
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    /// Textfield edit
    @objc private func didEditTextfield() {
        guard let searchTerm = searchTextfield.text, !searchTerm.isEmpty else { return }
        viewModel.didTypeSearchTerm(searchTerm)
    }
}

extension SearchViewController: UITableViewDelegate {

}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        spinner.wrapAndPin(top: UIConstants.spacingDouble, bottom: -UIConstants.spacingDouble)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let result = searchResults[safe: indexPath.row],
              let cell = tableView.dequeueReusableCell(withIdentifier: searchCellResultId, for: indexPath) as? SearchResultCell
        else { return UITableViewCell() }
        cell.setResult(result)
        return cell
    }
    
    
}
