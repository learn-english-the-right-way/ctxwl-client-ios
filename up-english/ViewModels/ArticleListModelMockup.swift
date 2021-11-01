//
//  ArticleListModelMockup.swift
//  up-english
//
//  Created by James Tsai on 10/24/21.
//

import Foundation

class ArticleListModelMockup: ArticleListModel {
    struct ArticleInfoMockup: ArticleInfo {
        var title: String
        var brief: String
        var url: String
    }
    typealias Info = ArticleInfoMockup
    
    @Published var content: [Info] = [
        ArticleInfoMockup(title: "New Video Provides Extensive Hands-on Look at New 16-inch MacBook Pro", brief: "A new video posted to YouTube today offers viewers perhaps the best real-world look yet at Apple's latest 16-inch MacBook Pro.", url: "https://www.macrumors.com/2021/10/23/new-hands-on-macbook-pro-16-video/"),
        ArticleInfoMockup(title: "macOS Monterey: Here Are All the Features Your Intel Mac Won't Support", brief: "Apple's official public release of macOS Monterey arrives on Monday, October 25, and users should be aware that there are several features in macOS 12 that are only available to machines powered by Apple silicon chips.", url: "https://www.macrumors.com/2021/10/23/macos-monterey-features-intel-incompatible/"),
        ArticleInfoMockup(title: "Today Marks the 20th Anniversary of the iPod", brief: "In what has become one of the most defining moments in Apple's history, today marks the 20th anniversary of Steve Jobs introducing the original iPod at a small press event at the Town Hall auditorium at Apple's former Infinite Loop headquarters.", url: "https://www.macrumors.com/2021/10/23/ipod-turns-20-anniversary/"),
        ArticleInfoMockup(title: "Gurman: Apple Event in November Unlikely, New MacBook Air With Biggest Redesign Since 2010 to Launch Next Year", brief: "In the latest edition of his Power On newsletter, Bloomberg's Mark Gurman said that he doesn't expect Apple to hold another event or make any other major product announcements this year, while turning his attention to what we can expect next year.", url: "https://www.macrumors.com/2021/10/22/november-apple-event-unlikely-gurman/"),
        ArticleInfoMockup(title: "Deals: New AirPods Pro With MagSafe Case Already Down to $219.99 ($29 Off)", brief: "Alongside the third-generation AirPods, Apple this week also introduced a minor update for the AirPods Pro to add MagSafe support to the charging case.", url: "https://www.macrumors.com/2021/10/22/deals-airpods-pro-magsafe-220/"),
        ArticleInfoMockup(title: "Apple Card 6% Daily Cash Listings for Apple Purchases Were in Error, but Apple is Honoring Them", brief: "Yesterday, a number of Apple Card users were seeing mentions of 6% Daily Cash showing up next to some recent Apple purchases, leading to some confusion about whether Apple was launching a special promotion to double the usual 3% cashback program.", url: "https://www.macrumors.com/2021/10/22/apple-card-daily-cash-bonus-error/"),
        ArticleInfoMockup(title: "With the New MacBook Pro Finally Out, Are There Any Other Products Coming From Apple in 2021?", brief: "Apple has had a busy year in 2021, releasing several new products, updates to services, new software updates, and more.", url: "https://www.macrumors.com/2021/10/22/no-more-apple-product-launches-2021/"),
        ArticleInfoMockup(title: "Apple Updates App Store Guidelines as Part of Agreement With U.S. Developers", brief: "In what has become one of the most defining moments in Apple's history, today marks the 20th anniversary of Steve Jobs introducing the original iPod at a small press event at the Town Hall auditorium at Apple's former Infinite Loop headquarters.", url: "https://www.macrumors.com/2021/10/23/ipod-turns-20-anniversary/"),
        ArticleInfoMockup(title: "Today Marks the 20th Anniversary of the iPod", brief: "Apple today announced it has updated its App Store Review Guidelines with three key changes related to outside-of-app communications, collecting contact information within an app, and in-app events featured in the App Store.", url: "https://www.macrumors.com/2021/10/22/app-store-review-guidelines-october-2021/"),
        ArticleInfoMockup(title: "First Real-World Photos and Video of New MacBook Pro Models Begin to Surface", brief: "Apple unveiled new 14-inch and 16-inch MacBook Pro models earlier this week, and the first real-world photos of the notebooks have surfaced.", url: "https://www.macrumors.com/2021/10/22/real-world-14-16-inch-macbook-pro-photos/"),
    ]
    func onItemAppear(_ index: Int) {
        print(index)
        if (self.isTheLastArticle(index: index)) {
            self.getMoreContent()
            print("onappear called")
        }
    }
    private func getMoreContent() {
        // get 5 more articles in the list
        let supplement = [
            ArticleInfoMockup(title: "Leaker claims iMac Pro with M1 Pro/M1 Max chips, ProMotion mini-LED display, and more slated for first half of 2022", brief: "Dylandkt, who has been building his reputation regarding Apple leaks over the past year, has shared some information about a possible new iMac or iMac Pro that could launch in the first half of 2022.", url: "https://9to5mac.com/2021/10/30/leaker-claims-imac-pro-with-m1-pro-m1-max-chips-promotion-mini-led-display-and-more-slated-for-first-half-of-2022/"),
            ArticleInfoMockup(title: "Apple says Adele’s ’30’ has become Apple Music’s most pre-added album ever", brief: "A couple of weeks since Adele launched her new single “Easy on Me” and opened pre-orders for her new album 30, Apple Music has announced that both of them have broken records on the platform.", url: "https://9to5mac.com/2021/10/30/apple-says-adeles-30-has-become-apple-musics-most-pre-added-album-ever/"),
            ArticleInfoMockup(title: "Super Follow now available to all iOS users; Twitter Blue detailed", brief: "Twitter announced that every iOS user can now start using the Super Follow feature, this comes a couple of months after the company rolled out this function for users in the US and Canada.", url: "https://9to5mac.com/2021/10/30/super-follow-now-available-to-all-ios-users-twitter-blue-detailed/"),
            ArticleInfoMockup(title: "WhatsApp refreshes branding in new update, now ‘WhatsApp from Meta’", brief: "After Facebook announced this week that the brand that will gather Facebook itself, Messenger, WhatsApp, Instagram, and more will be called Meta, the company is now changing the footer of its apps to reflect that.", url: "https://9to5mac.com/2021/10/30/whatsapp-refreshes-branding-in-new-update-now-whatsapp-from-meta/")
        ]
        self.content = self.content + supplement
    }
    private func isTheLastArticle(index: Int) -> Bool {
        // tell if the index is the last one in content
        if (index == self.content.endIndex - 1) {
            return true
        } else {
            return false
        }
    }
    
}
