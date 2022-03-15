FROM ruby:3.0.2

RUN apt-get update && apt-get install

RUN mkdir -p /var/app
COPY . /var/app
WORKDIR /var/app

ADD Gemfile Gemfile.lock /app/
RUN bundle install

CMD rails s -b 0.0.0.0