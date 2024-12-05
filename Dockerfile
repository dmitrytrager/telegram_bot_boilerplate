FROM ruby:3.3.6
ENV LANG C.UTF-8

ARG BRANCH

ENV BOT_ROOT /app
ENV BOT_ENV production
ENV APP_USER deployer

RUN gem update --system

RUN apt-get update -qq && \
  apt-get install -qq -y --no-install-recommends \
  build-essential \
  postgresql-client

RUN rm -rf /var/cache/apk/*

# add a non-privileged user
RUN groupadd -g 10001 $APP_USER
RUN useradd -m -u 10001 -g 10001 $APP_USER

RUN mkdir $BOT_ROOT
RUN chown $APP_USER:$APP_USER $BOT_ROOT
WORKDIR $BOT_ROOT

RUN gem install bundler -v "2.5.13"

USER $APP_USER

COPY Gemfile* $BOT_ROOT/

RUN bundle config set deployment "true"
RUN bundle config set without "development test"
RUN bundle install --jobs=20 --retry=5

COPY --chown=10001:10001 . $BOT_ROOT

ENTRYPOINT ["/app/bin/entrypoint.sh"]

CMD ["./bin/bot"]
