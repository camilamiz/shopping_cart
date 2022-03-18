FROM ruby:3.0.2

RUN apt-get update && apt-get install

ENV LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3

# Store Bundler settings in the project's root
ENV BUNDLE_APP_CONFIG=.bundle

# Upgrade RubyGems and install the latest Bundler version
RUN gem update --system && \
    gem install bundler

RUN mkdir -p /app
WORKDIR /app
EXPOSE 3000

ADD Gemfile Gemfile.lock /app/
RUN bundle install

CMD rails s -b 0.0.0.0