/**
*  Plot
*  Copyright (c) Alan DeGuzman 2026
*  Copyright (c) John Sundell 2019
*  MIT license, see LICENSE file for details
*/

import Foundation
import Testing
import Plot

struct PodcastFeedTests {
    @Test func emptyFeed() {
        let feed = PodcastFeed()
        assertEqualPodcastFeedContent(feed, "")
    }

    @Test func newFeedURL() {
        let feed = PodcastFeed(.newFeedURL("url.com"))
        assertEqualPodcastFeedContent(feed, "<itunes:new-feed-url>url.com</itunes:new-feed-url>")
    }

    @Test func podcastTitle() {
        let feed = PodcastFeed(.title("MyPodcast"))
        assertEqualPodcastFeedContent(feed, "<title>MyPodcast</title>")
    }

    @Test func podcastSubtitle() {
        let feed = PodcastFeed(.subtitle("Subtitle"))
        assertEqualPodcastFeedContent(feed, "<itunes:subtitle>Subtitle</itunes:subtitle>")
    }

    @Test func podcastDescription() {
        let feed = PodcastFeed(.description("Description"))
        assertEqualPodcastFeedContent(feed, "<description>Description</description>")
    }

    @Test func podcastSummary() {
        let feed = PodcastFeed(.summary("Summary"))
        assertEqualPodcastFeedContent(feed, "<itunes:summary>Summary</itunes:summary>")
    }

    @Test func podcastURL() {
        let feed = PodcastFeed(.link("url.com"))
        assertEqualPodcastFeedContent(feed, "<link>url.com</link>")
    }

    @Test func podcastAtomLink() {
        let feed = PodcastFeed(.atomLink("url.com"))
        assertEqualPodcastFeedContent(feed, """
        <atom:link href="url.com" rel="self" type="application/rss+xml">
        """)
    }

    @Test func podcastLanguage() {
        let feed = PodcastFeed(.language(.usEnglish))
        assertEqualPodcastFeedContent(feed, "<language>en-us</language>")
    }

    @Test func podcastTTL() {
        let feed = PodcastFeed(.ttl(200))
        assertEqualPodcastFeedContent(feed, "<ttl>200</ttl>")
    }

    @Test func podcastCopyright() {
        let feed = PodcastFeed(.copyright("Copyright"))
        assertEqualPodcastFeedContent(feed, "<copyright>Copyright</copyright>")
    }

    @Test func podcastAuthor() {
        let feed = PodcastFeed(.author("Author"))
        assertEqualPodcastFeedContent(feed, "<itunes:author>Author</itunes:author>")
    }

    @Test func podcastExplicitFlag() {
        let explicitFeed = PodcastFeed(.explicit(true))
        assertEqualPodcastFeedContent(explicitFeed, "<itunes:explicit>yes</itunes:explicit>")

        let nonExplicitFeed = PodcastFeed(.explicit(false))
        assertEqualPodcastFeedContent(nonExplicitFeed, "<itunes:explicit>no</itunes:explicit>")
    }

    @Test func podcastOwner() {
        let feed = PodcastFeed(.owner(.name("Name"), .email("Email")))
        assertEqualPodcastFeedContent(feed, """
        <itunes:owner><itunes:name>Name</itunes:name><itunes:email>Email</itunes:email></itunes:owner>
        """)
    }

    @Test func podcastCategory() {
        let feed = PodcastFeed(.category("News"))
        assertEqualPodcastFeedContent(feed, #"<itunes:category text="News">"#)
    }

    @Test func podcastSubcategory() {
        let feed = PodcastFeed(.category("News", .category("Tech News")))
        assertEqualPodcastFeedContent(feed, """
        <itunes:category text="News"><itunes:category text="Tech News"></itunes:category>
        """)
    }

    @Test func podcastType() {
        let episodicFeed = PodcastFeed(.type(.episodic))
        assertEqualPodcastFeedContent(episodicFeed, "<itunes:type>episodic</itunes:type>")

        let serialFeed = PodcastFeed(.type(.serial))
        assertEqualPodcastFeedContent(serialFeed, "<itunes:type>serial</itunes:type>")
    }

    @Test func podcastImage() {
        let feed = PodcastFeed(.image("image.png"))
        assertEqualPodcastFeedContent(feed, #"<itunes:image href="image.png">"#)
    }

    @Test func podcastPublicationDate() throws {
        let stubs = try Date.makeStubs(withFormattingStyle: .rss)
        let feed = PodcastFeed(.pubDate(stubs.date, timeZone: stubs.timeZone))
        assertEqualPodcastFeedContent(feed, "<pubDate>\(stubs.expectedString)</pubDate>")
    }

    @Test func podcastLastBuildDate() throws {
        let stubs = try Date.makeStubs(withFormattingStyle: .rss)
        let feed = PodcastFeed(.lastBuildDate(stubs.date, timeZone: stubs.timeZone))
        assertEqualPodcastFeedContent(feed, "<lastBuildDate>\(stubs.expectedString)</lastBuildDate>")
    }

    @Test func episodeGUID() {
        let guidFeed = PodcastFeed(.item(.guid("123")))
        assertEqualPodcastFeedContent(guidFeed, "<item><guid>123</guid></item>")

        let permaLinkFeed = PodcastFeed(.item(.guid("url.com", .isPermaLink(true))))
        assertEqualPodcastFeedContent(permaLinkFeed, """
        <item><guid isPermaLink="true">url.com</guid></item>
        """)

        let nonPermaLinkFeed = PodcastFeed(.item(.guid("123", .isPermaLink(false))))
        assertEqualPodcastFeedContent(nonPermaLinkFeed, """
        <item><guid isPermaLink="false">123</guid></item>
        """)
    }

    @Test func episodeTitle() {
        let feed = PodcastFeed(.item(.title("Title")))
        assertEqualPodcastFeedContent(feed, """
        <item><title>Title</title><itunes:title>Title</itunes:title></item>
        """)
    }

    @Test func episodeDescription() {
        let feed = PodcastFeed(.item(.description("Description")))
        assertEqualPodcastFeedContent(feed, """
        <item><description>Description</description></item>
        """)
    }

    @Test func episodeURL() {
        let feed = PodcastFeed(.item(.link("url.com")))
        assertEqualPodcastFeedContent(feed, "<item><link>url.com</link></item>")
    }

    @Test func episodePublicationDate() throws {
        let stubs = try Date.makeStubs(withFormattingStyle: .rss)
        let feed = PodcastFeed(.item(.pubDate(stubs.date, timeZone: stubs.timeZone)))
        assertEqualPodcastFeedContent(feed, """
        <item><pubDate>\(stubs.expectedString)</pubDate></item>
        """)
    }

    @Test func episodeDuration() {
        let feed = PodcastFeed(.item(
            .duration("00:15:12"),
            .duration(hours: 0, minutes: 15, seconds: 12),
            .duration(hours: 1, minutes: 2, seconds: 3)
        ))

        assertEqualPodcastFeedContent(feed, """
        <item>\
        <itunes:duration>00:15:12</itunes:duration>\
        <itunes:duration>00:15:12</itunes:duration>\
        <itunes:duration>01:02:03</itunes:duration>\
        </item>
        """)
    }

    @Test func seasonNumber() {
        let feed = PodcastFeed(.item(.seasonNumber(3)))
        assertEqualPodcastFeedContent(feed, """
        <item><itunes:season>3</itunes:season></item>
        """)
    }

    @Test func episodeNumber() {
        let feed = PodcastFeed(.item(.episodeNumber(42)))
        assertEqualPodcastFeedContent(feed, """
        <item><itunes:episode>42</itunes:episode></item>
        """)
    }

    @Test func episodeType() {
        let feed = PodcastFeed(
            .item(.episodeType(.full)),
            .item(.episodeType(.trailer)),
            .item(.episodeType(.bonus))
        )

        assertEqualPodcastFeedContent(feed, """
        <item><itunes:episodeType>full</itunes:episodeType></item>\
        <item><itunes:episodeType>trailer</itunes:episodeType></item>\
        <item><itunes:episodeType>bonus</itunes:episodeType></item>
        """)
    }

    @Test func episodeAudio() {
        let feed = PodcastFeed(.item(.audio(
            url: "episode.mp3",
            byteSize: 69121733,
            title: "Episode"
        )))

        let expectedComponents = [
            "<item>",
            #"<enclosure url="episode.mp3" length="69121733" type="audio/mpeg">"#,
            #"<media:content url="episode.mp3" length="69121733" type="audio/mpeg" isDefault="true" medium="audio">"#,
            #"<media:title type="plain">Episode</media:title>"#,
            "</media:content>",
            "</item>"
        ]

        assertEqualPodcastFeedContent(feed, expectedComponents.joined())
    }

    @Test func episodeHTMLContent() {
        let feed = PodcastFeed(.item(.content(
            "<p>Hello</p><p>World &amp; Everyone!</p>"
        )))

        let expectedComponents = [
            "<item>",
            "<content:encoded>",
            "<![CDATA[<p>Hello</p><p>World &amp; Everyone!</p>]]>",
            "</content:encoded>",
            "</item>"
        ]

        assertEqualPodcastFeedContent(feed, expectedComponents.joined())
    }
}
