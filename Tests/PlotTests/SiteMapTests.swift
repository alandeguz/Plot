/**
*  Plot
*  Copyright (c) Alan DeGuzman 2026
*  Copyright (c) John Sundell 2019
*  MIT license, see LICENSE file for details
*/

import Foundation
import Testing
import Plot

struct SiteMapTests {
    @Test func emptyMap() {
        let map = SiteMap()
        assertEqualSiteMapContent(map, "")
    }

    @Test func dailyUpdatedLocation() throws {
        let dateStubs = try Date.makeStubs(withFormattingStyle: .siteMap)

        let map = SiteMap(.url(
            .loc("url.com"),
            .changefreq(.daily),
            .priority(1.0),
            .lastmod(dateStubs.date, timeZone: dateStubs.timeZone)
        ))

        assertEqualSiteMapContent(map, """
        <url>\
        <loc>url.com</loc>\
        <changefreq>daily</changefreq>\
        <priority>1.0</priority>\
        <lastmod>\(dateStubs.expectedString)</lastmod>\
        </url>
        """)
    }

    @Test func monthlyUpdatedLocation() throws {
        let dateStubs = try Date.makeStubs(withFormattingStyle: .siteMap)

        let map = SiteMap(.url(
            .loc("url.com"),
            .changefreq(.monthly),
            .priority(1.0),
            .lastmod(dateStubs.date, timeZone: dateStubs.timeZone)
        ))

        assertEqualSiteMapContent(map, """
        <url>\
        <loc>url.com</loc>\
        <changefreq>monthly</changefreq>\
        <priority>1.0</priority>\
        <lastmod>\(dateStubs.expectedString)</lastmod>\
        </url>
        """)
    }
}
