import Foundation
import Publish
import Plot

// This type acts as the configuration for your website.
struct SwiftBlogWebsite: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case posts
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://swiftblogwebsite.com")!
    var name = "Swift Blog Website"
    var description = "This is going to be seen by people serching on Google."
    var language: Language { .english }
    var imagePath: Path? { nil }
}

private extension Node where Context == HTML.BodyContext {
    static func wrapper(_ nodes: Node...) -> Node {
        .div(.class("wrapper"), .group(nodes))
    }
    
    static func itemList<T: Website>(for items: [Item<T>], on site: T) -> Node {
        return .ul(
            .class("item-list"),
            .forEach(items) { item in
                .li(.article(
                    .h1(.a(
                        .href(item.path),
                        .text(item.title)
                    )),
                    .p(.text(item.description))
                ))  // li
            }  // forEach
        )  // ul
    }
}

extension Node where Context == HTML.BodyContext {
    static func myHeader<T: Website>(for context: PublishingContext<T>) -> Node {
        .header(
            .wrapper (
                .nav(
                    .class("site-name"),
                    .a(
                        .href("/"),
                        .text(context.site.name)  // context --> site property --> name
                    )
                )  // nav
            )  // wrapper
        )  // header
    }
}

struct MyHtmlFactory<Site: Website>: HTMLFactory {
    func makeIndexHTML(for index: Index, context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .head(for: index, on: context.site),
            
            .body(
                .myHeader(for: context),
                
                .wrapper(
                    .ul(
                        .class("item-list"),
                            .forEach(
                                context.allItems(sortedBy: \.date, order: .descending)
                            ) { item in
                                .li(
                                    .article(  // creates article
                                        .h1(.a(
                                            .href(item.path),
                                            .text(item.title)  // article title
                                            )),  // h1
                                        .p(.text(item.description))  // article text
                                    )  // article
                                )  // li
                        }  // forEach
                    )  // ul
                )  // wrapper
            )  // body
        )  // html
    }
    
    func makeSectionHTML(for section: Section<Site>, context: PublishingContext<Site>) throws -> HTML {
        try makeIndexHTML(for: context.index, context: context)
    }
    
    func makeItemHTML(for item: Item<Site>, context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .head(for: item, on: context.site),
            
            .body(
                .myHeader(for: context),  // header
                
                .wrapper(
                    .article(
                        .contentBody(item.body)
                    )  // article
                )  // wrapper
            )  // body
        )  // html
    }
    
    func makePageHTML(for page: Page, context: PublishingContext<Site>) throws -> HTML {
        try makeIndexHTML(for: context.index, context: context)
    }
    
    func makeTagListHTML(for page: TagListPage, context: PublishingContext<Site>) throws -> HTML? {
        nil
    }
    
    func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<Site>) throws -> HTML? {
        nil
    }
}

extension Theme {
    static var myTheme: Theme {
        Theme(
            htmlFactory: MyHtmlFactory(),
            resourcePaths: ["Resources/MyTheme/styles.css"]
        )
    }
}

// This will generate your website using the built-in Foundation theme:
try SwiftBlogWebsite().publish(withTheme: .myTheme)
