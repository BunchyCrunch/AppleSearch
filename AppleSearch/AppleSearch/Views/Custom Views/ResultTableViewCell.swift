//
//  ResultTableViewCell.swift
//  AppleSearch
//
//  Created by Josh Sparks on 10/3/19.
//  Copyright © 2019 Josh Sparks. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {

    @IBOutlet weak var artworkImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var musicItem: MusicSearchResult? {
        didSet {
            guard let item = musicItem else { return }
            titleLabel.text = item.trackName
            subtitleLabel.text = item.artistName
            artworkImageView.image = nil
            SearchResultController.getMusicImageFor(item: item) { (image) in
                if let image = image {
                    DispatchQueue.main.async {
                        self.artworkImageView.image = image
                    }
                } else {
                    print("image was nil")
                }
            }
        }
    }
    
    var appItem: AppSearchResult? {
        didSet {
            guard let item = appItem else { return }
            titleLabel.text = item.trackName
            subtitleLabel.text = item.description
            artworkImageView.image = nil
            SearchResultController.getAppImageFor(item: item) { (image) in
                if let image = image {
                    DispatchQueue.main.async {
                        self.artworkImageView.image = image
                    }
                } else {
                    print("image was nil")
                }
        }
    }
}
}
