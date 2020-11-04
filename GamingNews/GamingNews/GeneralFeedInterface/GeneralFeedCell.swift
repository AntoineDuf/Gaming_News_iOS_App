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
    @IBOutlet weak var imageStackView: UIView!

    func configureCell(article: RSSItem) {
        articleImage.layer.cornerRadius = 8
        title.text = article.title
        sourceLabel.text = article.source
        displayNewsDelay(article: article)
        guard let image = article.mediaThumbnail else {
            articleImage.isHidden = true
            imageStackView.isHidden = true
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
                [ .hour, .day, .minute ],
                from: startDate,
                to: NSDate() as Date
            )
            if let hour = components.hour,
                let day = components.day,
                let minute = components.minute {
                if day > 0 {
                    timeLabel.text = "Il y a \(String(describing: day)) jour(s)"
                } else if minute < 60 && hour < 1 {
                    timeLabel.text = "Il y a \(String(describing: minute)) minute(s)"
                    } else {
                        timeLabel.text = "Il y a \(String(describing: hour)) heure(s) & \(String(describing: minute)) minute(s)"
                }
            }
        }
    }
}
