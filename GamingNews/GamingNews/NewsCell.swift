//
//  NewsCell.swift
//  GamingNews
//
//  Created by Antoine Dufayet on 17/11/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import UIKit
import AlamofireRSSParser
import AlamofireImage
import FirebaseUI

class NewsCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var articleImage: UIImageView!

        func configureCell(article: RSSItem) {
            articleImage.layer.cornerRadius = 8
            title.text = article.title
            sourceLabel.text = article.source
            displayNewsDelay(article: article)
            guard let image = article.mediaThumbnail else {
                articleImage.isHidden = true
                return
            }
            guard let URLImage = URL(string: image) else { return }
            articleImage.af.setImage(withURL: URLImage)
            return
        }

    private func displayNewsDelay(article: RSSItem) {
        var calendar = NSCalendar.autoupdatingCurrent
        calendar.timeZone = NSTimeZone.system
        if let startDate = article.pubDate {
            let components = calendar.dateComponents(
                [ .hour, .day, .minute ],
                from: startDate,
                to: NSDate() as Date
            )
            if let hour = components.hour,
                let day = components.day,
                let minute = components.minute {
                if day > 0 {
                    timeLabel.text = "\(String(describing: day))j"
                } else if minute < 60 && hour < 1 {
                    timeLabel.text = "\(String(describing: minute))m"
                    } else {
                        timeLabel.text = "\(String(hour))h\(String(minute))m"
                }
            }
        }
    }
}
