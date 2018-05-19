//
//  CDImageTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/18.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import ImageViewer
import Kingfisher
import KingfisherWebP

class CDImageTableViewController: CDTableViewController {
    
    private func createGalleryItem(_ url: URL?) -> GalleryItem {
        let myFetchImageBlock: FetchImageBlock = { (completion) in
            guard let url = url else {
                completion(nil)
                return
            }
            KingfisherManager.shared.retrieveImage(with: url, options: [.processor(WebPProcessor.default), .cacheSerializer(WebPSerializer.default), .scaleFactor(UIScreen.main.scale)], progressBlock: nil) { image, _, _, _ in
                completion(image)
            }

        }
        let itemViewControllerBlock: ItemViewControllerBlock = { index, itemCount, fetchImageBlock, configuration, isInitialController in
            return ItemBaseController<UIImageView>(index: index, itemCount: itemCount, fetchImageBlock: myFetchImageBlock, configuration: configuration, isInitialController: isInitialController)
        }
        let galleryItem = GalleryItem.custom(fetchImageBlock: myFetchImageBlock, itemViewControllerBlock: itemViewControllerBlock)
        return galleryItem
    }

    var items = [GalleryItem]()

    private func createGalleryViewController(startIndex: Int, image: UIImage?) -> GalleryViewController {
        let config = [
            GalleryConfigurationItem.closeButtonMode(.builtIn),
            GalleryConfigurationItem.closeLayout(.pinLeft(32, 20)),
            GalleryConfigurationItem.thumbnailsActivityIndicator(true),
            GalleryConfigurationItem.hideDecorationViewsOnLaunch(true),
            GalleryConfigurationItem.deleteButtonMode(.none),
            GalleryConfigurationItem.thumbnailsButtonMode(.none),
            GalleryConfigurationItem.swipeToDismissMode(.vertical),
            GalleryConfigurationItem.activityViewByLongPress(true),
            GalleryConfigurationItem.placeHolderImage(image),
            
        ]
        let vc = GalleryViewController(startIndex: startIndex, itemsDataSource: self, itemsDelegate: nil, displacedViewsDataSource: self, configuration: config)
        return vc
    }
    
    private var urls = [URL]()

    override func prepareRows(for card: Card) {
        let height = Int(CDImageTableViewCell.imageHeight * UIScreen.main.scale)
        
        rows.removeAll()

        rows += [
            Row(type: CDImageTableViewCell.self, data: .album(NSLocalizedString("Still", comment: ""), card.stillImageURLs(), card.stillImageURLs(postfix: "@h\(height)"))),
            Row(type: CDImageTableViewCell.self, data: .album(NSLocalizedString("Full", comment: ""), [card.fullImageURL()], [card.fullImageURL(postfix: "@h\(height)")])),
            Row(type: CDImageTableViewCell.self, data: .album(NSLocalizedString("Profile", comment: ""), card.profileImageURLs(), card.profileImageURLs(postfix: "@h\(height)"))),
            Row(type: CDImageTableViewCell.self, data: .album(NSLocalizedString("Comic", comment: ""), card.comicImageURLs(), card.comicImageURLs(postfix: "@h\(height)"))),
            Row(type: CDImageTableViewCell.self, data: .album(NSLocalizedString("Plate", comment: ""), card.plateImageURLs(), card.plateImageURLs(postfix: "@h\(height)")))
        ]
        
        urls = rows.flatMap { (row) -> [URL] in
            if case .album(_, let fullURLs, _) = row.data {
                return fullURLs
            } else {
                return []
            }
        }
        items = urls.map { createGalleryItem($0) }
    }
    
    override func cdImageTableViewCell(_ cdImageTableViewCell: CDImageTableViewCell, didSelect imageView: UIImageView, url: URL) {
        if let index = urls.index(where: { $0.absoluteString == String(url.absoluteString.split(separator: "@").first ?? "") }) {
            let vc = createGalleryViewController(startIndex: index, image: imageView.image)
            presentImageGallery(vc)
        }
    }

}

extension CDImageTableViewController: GalleryItemsDataSource {

    func itemCount() -> Int {
        return items.count
    }

    func provideGalleryItem(_ index: Int) -> GalleryItem {
        return items[index]
    }

}

extension CDImageTableViewController: GalleryDisplacedViewsDataSource {
    
    func provideDisplacementItem(atIndex index: Int) -> DisplaceableView? {
        let url = urls[index]
        var row: Int?
        var item: Int?
        for i in 0..<rows.count {
            if case .album(_, let urls, _) = rows[i].data {
                if let index = urls.index(where: { $0 == url }) {
                    item = index
                    row = i
                    break
                }
            }
        }
        if let row = row, let item = item {
            let indexPath = IndexPath(row: row, section: 0)
            if let tableViewCell = tableView.cellForRow(at: indexPath) as? CDImageTableViewCell,
                let collectionViewCell = tableViewCell.imageCollectionView.cellForItem(at: IndexPath(item: item, section: 0)) as? ImageCollectionViewCell {
                return collectionViewCell.imageView
            }
        }
        return nil
    }
    
}

extension UIImageView: DisplaceableView {
    
}
