from scrapy.contrib.linkextractors.sgml import SgmlLinkExtractor
from scrapy.contrib.spiders import CrawlSpider, Rule
from get_links.items import MyItem

class MySpider(CrawlSpider):
    name = 'links'
    allowed_domains = ['alltypefireprotection.ca', 'alltypefire.calls.net', 'rushpalletandcrates.ca', 'rushpalletandcrates.calls.net', 'dixieartpictureframe.ca', 'dixieartpictureframe.com']
    start_urls = ['http://www.alltypefireprotection.ca', 'http://www.alltypefire.calls.net', 'http://www.rushpalletandcrates.ca', 'http://www.rushpalletandcrates.calls.net', 'http://www.dixieartpictureframe.ca', 'http://dixieartpictureframe.com/']

    rules = (Rule(SgmlLinkExtractor(), callback='parse_url', follow=True), )

    def parse_url(self, response):
        item = MyItem()
        item['url'] = response.url
        yield item
