FROM ruby:3.2.2

ENV APP_DIR=/opt/app/

EXPOSE $APP_PORT
VOLUME ${APP_DIR}

RUN mkdir -p ${APP_DIR}
WORKDIR ${APP_DIR}

COPY Gemfile ${APP_DIR}
COPY Gemfile.lock ${APP_DIR}

# For caching gems.
ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle

ENV PATH="${BUNDLE_BIN}:${PATH}" \
    LC_ALL="en_US.UTF-8" \
    LANG="en_US.UTF-8"

RUN echo "deb http://ftp.debian.org/debian stretch-backports main" >> /etc/apt/sources.list

RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch"-pgdg main | tee  /etc/apt/sources.list.d/pgdg.list

RUN dpkg --add-architecture i386
RUN apt-get update -qq && \
    apt-get install -y \
      build-essential \
      libssl-dev \
      ssh && \
    apt-get -t stretch-backports install -y \
      postgresql-client-12 && \
    rm -rf /var/lib/apt/lists/*

RUN bundle install --jobs 6

COPY . .

CMD bundle exec rails s -b $APP_BINDING -p $APP_PORT
