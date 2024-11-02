FROM python:3.9-alpine3.13
LABEL maintainer="recipe-app"

ENV PYTHONUNBUFFERED 1

# Copy requirements and app directory to Docker
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app

# Set the working directory
WORKDIR /app

# Use port 8000
EXPOSE 8000

ARG DEV=false

# Create a virtual environment, upgrade pip, install dependencies, and clean up
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then \
        /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# Update the PATH environment variable
ENV PATH="/py/bin:$PATH"

# Use the created user
USER django-user