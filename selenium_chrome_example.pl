use strict;
use warnings;
use Selenium::Chrome;
use HTML::TreeBuilder;

print "=" x 70 . "\n";
print "Scraping Dynamic Content with Selenium::Chrome\n";
print "=" x 70 . "\n\n";

print "1. Starting headless Chrome via Selenium...\n";
my $driver = Selenium::Chrome->new(
    extra_capabilities => {
        'goog:chromeOptions' => {
            binary => '/usr/bin/chromium',
            args   => [
                '--headless',
                '--no-sandbox',
                '--disable-dev-shm-usage',
            ],
        }
    }
);
print "   Chrome started\n\n";

print "2. Navigating to JavaScript-heavy page...\n";
$driver->get('https://quotes.toscrape.com/js/');
print "   Page loaded\n\n";

print "3. Waiting for JavaScript to render quotes...\n";
# Implicit wait: find_element polls the DOM until the element appears,
# up to the timeout, before throwing an error.
$driver->set_implicit_wait_timeout(10_000);
eval { $driver->find_element('.quote', 'css') };
print "   Quotes detected in DOM\n\n";

print "4. Extracting rendered page source...\n";
my $html = $driver->get_page_source();
print "   HTML extracted (" . length($html) . " bytes)\n\n";

print "5. Parsing quotes with HTML::TreeBuilder...\n";
my $tree = HTML::TreeBuilder->new_from_content($html);
my @spans = $tree->look_down(_tag => 'span', class => 'text');
print "   Found " . scalar(@spans) . " quotes\n\n";

print "--- Extracted Quotes ---\n";
for my $span (@spans) {
    print $span->as_text() . "\n";
}

$tree->delete();
$driver->quit();

print "\n" . "=" x 70 . "\n";
print "Dynamic content successfully scraped with Selenium.\n";
print "=" x 70 . "\n";
