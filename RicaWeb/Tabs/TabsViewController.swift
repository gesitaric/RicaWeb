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

    var themeColor: UIColor?

    private lazy var viewModel: TabsViewModel = {
        let model = TabsViewModel()
        return model
    }()

    weak var delegate: TabsDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        themeColor = Util().getThemeColor()
        setThemeColor()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let index = TabsManager.shared.currentTab ?? TabsManager.shared.tabs.count - 1
        collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TabsManager.shared.tabs.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Reuse", for: indexPath) as? TabsCellViewController else { return UICollectionViewCell() }
        let model = TabsManager.shared.tabs[indexPath.item]
        cell.title.text = model.title
        cell.image.image = Util().stringToImage(imageString: model.image)
        cell.backgroundColor = themeColor?.adjust(by: 40)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        TabsManager.shared.currentTab = indexPath.item
        dismiss(animated: true, completion: {
            self.delegate?.didSelectItemAt(tab: TabsManager.shared.tabs[indexPath.item])
        })
    }

    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    private func setThemeColor() {
        guard let color = themeColor else { return }
        collectionView.backgroundColor = color.adjust(by: 70)
    }
}
