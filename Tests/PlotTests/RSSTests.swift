/**
*  Plot
*  Copyright (c) Alan DeGuzman 2026
*  Copyright (c) John Sundell 2019
*  MIT license, see LICENSE file for details
*/

import Foundation
import Testing
import Plot

struct RSSTests {
    @Test func emptyFeed() {
        let feed = RSS()
        assertEqualRSSFeedContent(feed, "")
    }

    @Test func feedTitle() {
        let feed = RSS(.title("MyPodcast"))
        assertEqualRSSFeedContent(feed, "<title>MyPodcast</title>")
    }

    @Test func feedDescription() {
        let feed = RSS(.description("Description"))
        assertEqualRSSFeedContent(feed, "<description>Description</description>")
    }

    @Test func feedDescriptionWithHTMLContent() {
        let feed = RSS(
            .description(
                .p(
                    .text("Description with "),
                    .em("emphasis"),
                    .text(".")
                )
            )
        )
        assertEqualRSSFeedContent(feed, "<description><![CDATA[<p>Description with <em>emphasis</em>.</p>]]></description>")
    }

    @Test func feedURL() {
        let feed = RSS(.link("url.com"))
        assertEqualRSSFeedContent(feed, "<link>url.com</link>")
    }

    @Test func feedAtomLink() {
        let feed = RSS(.atomLink("url.com"))
        assertEqualRSSFeedContent(feed, """
        <atom:link href="url.com" rel="self" type="application/rss+xml">
        """)
    }

    @Test func feedLanguage() {
        let feed = RSS(.language(.usEnglish))
        assertEqualRSSFeedContent(feed, "<language>en-us</language>")
    }

    @Test func feedTTL() {
        let feed = RSS(.ttl(200))
        assertEqualRSSFeedContent(feed, "<ttl>200</ttl>")
    }

    @Test func feedPublicationDate() throws {
        let stubs = try Date.makeStubs(withFormattingStyle: .rss)
        let feed = RSS(.pubDate(stubs.date, timeZone: stubs.timeZone))
        assertEqualRSSFeedContent(feed, "<pubDate>\(stubs.expectedString)</pubDate>")
    }

    @Test func feedLastBuildDate() throws {
        let stubs = try Date.makeStubs(withFormattingStyle: .rss)
        let feed = RSS(.lastBuildDate(stubs.date, timeZone: stubs.timeZone))
        assertEqualRSSFeedContent(feed, "<lastBuildDate>\(stubs.expectedString)</lastBuildDate>")
    }

    @Test func itemGUID() {
        let feed = RSS(
            .item(.guid("123")),
            .item(.guid("url.com", .isPermaLink(true))),
            .item(.guid("123", .isPermaLink(false)))
        )

        assertEqualRSSFeedContent(feed, """
        <item><guid>123</guid></item>\
        <item><guid isPermaLink="true">url.com</guid></item>\
        <item><guid isPermaLink="false">123</guid></item>
        """)
    }

    @Test func itemTitle() {
        let feed = RSS(.item(.title("Title")))
        assertEqualRSSFeedContent(feed, "<item><title>Title</title></item>")
    }

    @Test func itemDescription() {
        let feed = RSS(.item(.description("Description")))
        assertEqualRSSFeedContent(feed, """
        <item><description>Description</description></item>
        """)
    }

    @Test func itemURL() {
        let feed = RSS(.item(.link("url.com")))
        assertEqualRSSFeedContent(feed, "<item><link>url.com</link></item>")
    }

    @Test func itemPublicationDate() throws {
        let stubs = try Date.makeStubs(withFormattingStyle: .rss)
        let feed = RSS(.item(.pubDate(stubs.date, timeZone: stubs.timeZone)))
        assertEqualRSSFeedContent(feed, """
        <item><pubDate>\(stubs.expectedString)</pubDate></item>
        """)
    }

    @Test func itemHTMLStringContent() {
        let feed = RSS(.item(.content(
            "<p>Hello</p><p>World &amp; Everyone!</p>"
        )))

        assertEqualRSSFeedContent(feed, """
        <item>\
        <content:encoded>\
        <![CDATA[<p>Hello</p><p>World &amp; Everyone!</p>]]>\
        </content:encoded>\
        </item>
        """)
    }

    @Test func itemHTMLDSLContent() {
        let feed = RSS(.item(
            .content(.h1("Title"))
        ))

        assertEqualRSSFeedContent(feed, """
        <item>\
        <content:encoded>\
        <![CDATA[<h1>Title</h1>]]>\
        </content:encoded>\
        </item>
        """)
    }
}
