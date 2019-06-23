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
}

class TabsViewController: UICollectionViewController {

    private lazy var viewModel: TabsViewModel = {
        let model = TabsViewModel()
        return model
    }()

    weak var delegate: TabsDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TabsManager.shared.tabs.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Reuse", for: indexPath) as? TabsCellViewController else { return UICollectionViewCell() }
        let model = TabsManager.shared.tabs[indexPath.item]
        cell.title.text = model.title
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismiss(animated: true, completion: {
            self.delegate?.didSelectItemAt(tab: TabsManager.shared.tabs[indexPath.item])
        })
    }

    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
