//
//  TabsViewController.swift
//  RicaWeb
//
//  Created by Italo Ricardo Geske on 2019/06/22.
//  Copyright © 2019 Italo Ricardo Geske. All rights reserved.
//

import Foundation

class TabsViewController: UICollectionViewController {

    private lazy var viewModel: TabsViewModel = {
        let model = TabsViewModel()
        return model
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.tabs.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Reuse", for: indexPath) as? TabsCellViewController else { return UICollectionViewCell() }
        let model = viewModel.tabs[indexPath.item]
        cell.title.text = model
        return cell
    }

    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
