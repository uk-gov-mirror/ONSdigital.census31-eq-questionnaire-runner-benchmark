FROM python:3.13-slim

WORKDIR /benchmark
COPY . /benchmark

# These dependencies are required for the psutil Python package
RUN apt-get update \
    && apt-get install -y --no-install-recommends gcc='*' python3-dev='*' \
    && rm -rf /var/lib/apt/lists/*

# Install the required dependencies via pip
COPY pyproject.toml pyproject.toml
COPY poetry.lock poetry.lock
RUN pip install "poetry==2.1.2" \
    --no-cache-dir \
    && poetry config virtualenvs.create false \
    && poetry install --only main \
    && useradd --create-home --shell /bin/bash benchmark \
    && chown -R benchmark:benchmark /benchmark

USER benchmark

HEALTHCHECK NONE

# Start Locust using LOCUS_OPTS environment variable
ENTRYPOINT ["bash", "./docker_entrypoint.sh"]
