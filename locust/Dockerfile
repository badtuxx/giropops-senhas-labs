FROM python:3.11-slim-buster as base

FROM base as builder 
RUN apt-get -qq update \
    && apt-get install -y --no-install-recommends g++ \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --prefix="/reqs" -r requirements.txt

FROM base
WORKDIR /usr/src/app
VOLUME /usr/src/app/scripts
COPY --from=builder /reqs /usr/local
ENTRYPOINT locust




