//
//  ImageProgressiveCollectionView.swift
//  SoHungry
//
//  Created by Shi Yan on 10/26/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class ImageProgressiveCollectionView : UICollectionView {
    
    var imageDelegate : ImageProgressiveCollectionViewDelegate?
    
    func startOperationsForPhotoRecord(inout pendingOperations : PendingOperations, photoDetails : PhotoRecord, indexPath : NSIndexPath) {
        switch (photoDetails.state) {
        case .New:
            startDownloadForRecord(&pendingOperations, photoDetails: photoDetails, indexPath : indexPath)
        default:
            print("do nothing")
        }
        
    }
    
    func startDownloadForRecord(inout pendingOperations : PendingOperations, photoDetails : PhotoRecord, indexPath : NSIndexPath) {
        
        // Check to see if there's already a download operation for this index path
        if pendingOperations.downloadsInProgress[indexPath] != nil {
            return
        }
        
        // create an instance of ImageDownloader
        let downloader = ImageDownloader(photoRecord: photoDetails)
        downloader.completionBlock = {
            if downloader.cancelled {
                return
            }
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                pendingOperations.downloadsInProgress.removeValueForKey(indexPath)
                self.reloadItemsAtIndexPaths([indexPath])
            })
        }
        
        // Keep track of the downloader for the indexPath
        pendingOperations.downloadsInProgress[indexPath] = downloader
        
        // Add to download queue
        pendingOperations.downloadQueue.addOperation(downloader)
        
    }
    
    func cancellImageLoadingForUnvisibleCells(inout pendingOperations : PendingOperations) {
        let pathsOfVisibleCells = self.indexPathsForVisibleItems()
        let allPendingOperations = Set(pendingOperations.downloadsInProgress.keys)
        
        var toBeCancelled = allPendingOperations
        let visiblePaths = Set(pathsOfVisibleCells)
        
        toBeCancelled.subtractInPlace(visiblePaths)
        
        for indexPath in toBeCancelled {
            if let pendingDownload = pendingOperations.downloadsInProgress[indexPath] {
                pendingDownload.cancel()
            }
            pendingOperations.downloadsInProgress.removeValueForKey(indexPath)
        }
    }
    
    func loadImageForVisibleCells(inout pendingOperations : PendingOperations) {
        let pathsOfVisibleCells = self.indexPathsForVisibleItems()
        let allPendingOperations = Set(pendingOperations.downloadsInProgress.keys)
        
        let visiblePaths = Set(pathsOfVisibleCells)
        var toBeStarted = visiblePaths
        toBeStarted.subtractInPlace(allPendingOperations)
        
        for indexPath : NSIndexPath in toBeStarted {
            let recordToProcess = imageDelegate?.imageForIndexPath(collectionView: self, indexPath: indexPath)
            startOperationsForPhotoRecord(&pendingOperations, photoDetails: recordToProcess!, indexPath: indexPath)
        }
    }

}

protocol ImageProgressiveCollectionViewDelegate {
    
    func imageForIndexPath(collectionView collectionView : UICollectionView, indexPath : NSIndexPath) -> PhotoRecord
    
}