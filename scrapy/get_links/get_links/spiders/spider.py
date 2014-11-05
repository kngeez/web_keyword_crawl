from scrapy.contrib.linkextractors.sgml import SgmlLinkExtractor
from scrapy.contrib.spiders import CrawlSpider, Rule
from get_links.items import MyItem

class MySpider(CrawlSpider):
    name = 'links'
    allowed_domains = ['alltypefire.ca', 'rushpalletandcrates.com']
    start_urls = ['http://www.alltypefire.ca'
                  , 'http://www.rushpalletandcrates.com']

    rules = (Rule(SgmlLinkExtractor(), callback='parse_url', follow=True), )

    def parse_url(self, response):
        item = MyItem()
        item['url'] = response.url
        yield item
