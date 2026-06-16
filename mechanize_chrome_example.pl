use strict;
use warnings;
use Log::Log4perl qw(:easy);
use WWW::Mechanize::Chrome;
use HTML::TreeBuilder;

# Suppress WWW::Mechanize::Chrome's internal debug chatter
Log::Log4perl->easy_init($ERROR);

# 1. Launch a real headless Chrome instance.
# launch_exe and launch_arg are required inside Docker/Linux.
# On macOS you can omit them — Chromium is found automatically.
print "Launching headless Chrome engine...\n";
my $mech = WWW::Mechanize::Chrome->new(
    headless   => 1,
    autodie    => 1,
    launch_exe => '/usr/bin/chromium',
    launch_arg => ['--no-sandbox', '--disable-dev-shm-usage'],
);

# 2. Load a JavaScript-heavy page.
# quotes.toscrape.com/js/ intentionally requires JS to render its quotes.
# A plain HTTP client like LWP::UserAgent would receive an empty list.
my $target_url = 'https://quotes.toscrape.com/js/';
print "Navigating to $target_url...\n";
$mech->get($target_url);

# 3. Wait for JavaScript rendering to finish.
# Chrome executes JS asynchronously after the initial HTML arrives.
# A short sleep gives the engine time to inject the dynamic content into the DOM.
print "Waiting for dynamic content to render...\n";
sleep(2);

# 4. Capture a screenshot as visual proof the page rendered correctly.
print "Capturing rendered page screenshot...\n";
my $screenshot_data = $mech->content_as_png();
open(my $fh, '>', 'rendered_page.png') or die "Cannot save screenshot: $!";
binmode $fh;
print $fh $screenshot_data;
close($fh);
print "Screenshot saved to rendered_page.png\n";

# 5. Pull the fully rendered HTML out of Chrome, then parse it.
# content() returns the live DOM after JS has run — not the original server HTML.
print "\n--- Extracted Dynamic Content ---\n";
my $html = $mech->content();
my $tree = HTML::TreeBuilder->new_from_content($html);

my @spans = $tree->look_down(_tag => 'span', class => 'text');
if (@spans) {
    for my $span (@spans) {
        print "Quote: " . $span->as_text() . "\n";
    }
} else {
    print "No quotes found — JS may need more time. Try increasing the sleep.\n";
}

$tree->delete();
print "\nDone.\n";


# ---------------------------------------------------------------
# ALTERNATIVE: Selenium::Chrome
# Use this if Selenium is already part of your stack, or if you need
# fine-grained WebDriver control (multi-tab, JS execution, form fills).
# ---------------------------------------------------------------
# use strict;
# use warnings;
# use Selenium::Chrome;
# use HTML::TreeBuilder;
#
# my $driver = Selenium::Chrome->new(
#     extra_capabilities => {
#         chromeOptions => {
#             args => [
#                 '--headless',
#                 '--no-sandbox',              # required inside Docker
#                 '--disable-dev-shm-usage',   # prevents shared-memory crashes
#                 '--disable-blink-features=AutomationControlled',
#             ]
#         }
#     }
# );
#
# $driver->get('https://quotes.toscrape.com/js/');
#
# # Wait up to 10 seconds for at least one .quote element to appear in the DOM.
# eval {
#     $driver->wait_for_element_by_class_name('quote', 10);
# };
#
# # Grab the fully rendered HTML and parse it with HTML::TreeBuilder.
# my $html = $driver->get_page_source();
# my $tree = HTML::TreeBuilder->new_from_content($html);
#
# my @quote_divs = $tree->look_down(_tag => 'div', class => qr/quote/);
# for my $div (@quote_divs) {
#     my $span = $div->look_down(_tag => 'span', class => 'text');
#     print "Quote: " . ($span ? $span->as_text : 'N/A') . "\n";
# }
#
# $tree->delete();
# $driver->quit();
