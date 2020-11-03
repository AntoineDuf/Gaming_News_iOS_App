//
//  GeneralFeedCell.swift
//  GamingNews
//
//  Created by Antoine Dufayet on 28/10/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import UIKit
import AlamofireRSSParser
import AlamofireImage
import FirebaseUI

class GeneralFeedCell: UITableViewCell {

    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var sourceLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var articleImage: UIImageView!

    func configureCell(article: RSSItem) {
        articleImage.layer.cornerRadius = 8
        title.text = article.title
        sourceLabel.text = article.source
        displayNewsDelay(article: article)
        guard let image = article.mediaThumbnail else {
            guard let image = article.enclosures?[0] else {
                articleImage.isHidden = true
                return
            }
            articleImage.af.setImage(withURL: URL(string: image["url"]!)!)
            return
        }
        articleImage.af.setImage(withURL: URL(string: image)!)
        return
    }

    private func displayNewsDelay(article: RSSItem) {
        var calendar = NSCalendar.autoupdatingCurrent
        calendar.timeZone = NSTimeZone.system
        if let startDate = article.pubDate {
            let components = calendar.dateComponents(
                [ .hour, .day ],
                from: startDate,
                to: NSDate() as Date
            )
            if let hour = components.hour,
                let day = components.day {
                if day > 0 {
                    timeLabel.text = "\(String(describing: day)) jour(s)"
                } else {
                    timeLabel.text = "\(String(describing: hour)) heure(s)"
                }
            }
        }
    }
}
