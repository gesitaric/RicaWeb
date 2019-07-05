//
//  TabsViewController.swift
//  RicaWeb
//
//  Created by Italo Ricardo Geske on 2019/06/22.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import Foundation

protocol TabsDelegate: class {
    func didSelectItemAt(tab: Tab)
    func closeAllTabs()
}

class TabsViewController: UICollectionViewController {

    private lazy var viewModel: TabsViewModel = {
        let model = TabsViewModel()
        return model
    }()

    weak var delegate: TabsDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        setThemeColor()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.scrollToItem(at: viewModel.getIndexPath(), at: .centeredHorizontally, animated: true)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TabsManager.shared.tabs.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Reuse", for: indexPath) as? TabsCellViewController else { return UICollectionViewCell() }
        cell.buttonAction = { sender in
            self.viewModel.deleteTab(index: indexPath.item)
            collectionView.reloadData()
        }
        return viewModel.setupCell(cell: cell, indexPath: indexPath)
        
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        TabsManager.shared.changeCurrentTab(index: indexPath.item)
        dismiss(animated: true, completion: {
            self.delegate?.didSelectItemAt(tab: TabsManager.shared.tabs[indexPath.item])
        })
    }

    private func setThemeColor() {
        guard let color = viewModel.themeColor else { return }
        collectionView.backgroundColor = color.adjust(by: 70)
    }

    @IBAction func closeTab(_ sender: Any) {
        
    }
}
