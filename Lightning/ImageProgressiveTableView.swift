//
//  ImageTableView.swift
//  SoHungry
//
//  Created by Shi Yan on 10/17/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation
import UIKit

class ImageProgressiveTableView : UITableView {
    
    var imageDelegate : ImageProgressiveTableViewDelegate?
    
    func startOperationsForPhotoRecord(inout pendingOperations : PendingOperations, photoDetails : PhotoRecord, indexPath : NSIndexPath) {
        switch (photoDetails.state) {
        case .New:
            startDownloadForRecord(&pendingOperations, photoDetails: photoDetails, indexPath : indexPath)
        default: break
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
                self.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            })
        }
        
        // Keep track of the downloader for the indexPath
        pendingOperations.downloadsInProgress[indexPath] = downloader
        
        // Add to download queue
        pendingOperations.downloadQueue.addOperation(downloader)
        
    }
    
    func cancellImageLoadingForUnvisibleCells(inout pendingOperations : PendingOperations) {
        if let pathsOfVisibleCells = self.indexPathsForVisibleRows {
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
    }
    
    func loadImageForVisibleCells(inout pendingOperations : PendingOperations) {
        if let pathsOfVisibleCells = self.indexPathsForVisibleRows {
            let allPendingOperations = Set(pendingOperations.downloadsInProgress.keys)
            
            let visiblePaths = Set(pathsOfVisibleCells)
            var toBeStarted = visiblePaths
            toBeStarted.subtractInPlace(allPendingOperations)
            
            for indexPath : NSIndexPath in toBeStarted {
                let recordToProcess = imageDelegate?.imageForIndexPath(tableView: self, indexPath: indexPath)
                let row = indexPath.row
                let section = indexPath.section
                startOperationsForPhotoRecord(&pendingOperations, photoDetails: recordToProcess!, indexPath: indexPath)
            }
        }
    }
}

protocol ImageProgressiveTableViewDelegate {
    
    func imageForIndexPath(tableView tableView : UITableView, indexPath : NSIndexPath) -> PhotoRecord
    
}


