FROM ruby:3.2.8-alpine
RUN apk update && \
    apk upgrade && \
    apk add --no-cache gcompat && \
    apk add --no-cache linux-headers libxml2-dev make gcc yaml-dev libc-dev nodejs tzdata postgresql-dev postgresql git bash && \
    apk add --virtual build-packages --no-cache build-base curl-dev
RUN mkdir /app
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install
RUN apk del build-packages
ADD . /app
EXPOSE 4000
CMD ["rails", "server", "-b", "0.0.0.0"]
