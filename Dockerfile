# docker build -t mydao/inv8 .

FROM ruby:2.5.3-stretch

ARG http_port=8888

ENV HTTP_PORT          $http_port
ENV HEALTHCHECK_URL    "http://127.0.0.1:${http_port}"

RUN mkdir /inv8
WORKDIR /inv8
COPY . /inv8/

RUN bundle install --binstubs

EXPOSE $http_port

ENTRYPOINT bundle exec puma -C puma.rb

HEALTHCHECK --interval=15s --timeout=5s --retries=10 CMD curl --silent --fail "${HEALTHCHECK_URL}" || exit 1
