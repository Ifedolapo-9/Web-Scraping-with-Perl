FROM perl:5.38

ENV DEBIAN_FRONTEND=noninteractive

# Chromium + the system libraries that Perl's C-level modules compile against.
# libexpat1-dev  → XML::Parser (required by several CPAN deps)
# libssl-dev     → Net::SSLeay / IO::Socket::SSL (required for HTTPS)
# pkg-config     → helps the compiler locate installed libraries
RUN apt-get update && apt-get install -y \
    chromium \
    chromium-driver \
    libssl-dev \
    libexpat1-dev \
    zlib1g-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

ENV CHROME_BIN=/usr/bin/chromium

# Install in dependency order so each layer is cached independently.
# If a later step fails you can re-run without rebuilding earlier steps.

# Mojolicious is the event-loop backend WWW::Mechanize::Chrome relies on.
RUN cpanm --notest Mojolicious

# SSL stack — must exist before the browser module tries to make HTTPS calls.
RUN cpanm --notest IO::Socket::SSL Net::SSLeay

# The main headless-Chrome module and its DevTools Protocol layer.
RUN cpanm --notest WWW::Mechanize::Chrome

# Selenium alternative + HTML parser used in the article's second example.
RUN cpanm --notest Selenium::Remote::Driver HTML::TreeBuilder

WORKDIR /app
COPY mechanize_chrome_example.pl .

CMD ["perl", "mechanize_chrome_example.pl"]
