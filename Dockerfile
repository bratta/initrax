FROM ruby:2.4.1-alpine

LABEL maintainer="tgourley@gmail.com" \
      description="Track Your RPG Initiative"

ENV RAILS_ENV production
ENV NODE_ENV production

WORKDIR /initrax

COPY Gemfile Gemfile.lock package.json yarn.lock /initrax/

EXPOSE 3000

RUN apk -U upgrade && apk add --no-cache \
    git \
    postgresql-dev \
    libxml2-dev \
    libxslt-dev \
    build-base \
    nodejs \
    libpq \
    libxml2 \
    libxslt \
    ffmpeg \
    file \
    imagemagick \
 && npm install -g npm@3 && npm install -g yarn \
 && bundle install --deployment --without test development \
 && yarn \
 && yarn cache clean \
 && npm -g cache clean \
 && rm -rf /tmp/* /var/cache/apk/*

COPY . /initrax

VOLUME /initrax/public/system /initrax/public/assets /initrax/public/packs
