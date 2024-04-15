FROM python:3.11 AS base

RUN mkdir -p /app/task

WORKDIR /app/task

COPY requirements.txt requirements.txt

RUN pip install --upgrade pip
RUN pip install -r requirements.txt

FROM base

COPY . /app/task

WORKDIR /app/task/scentbird

EXPOSE 8888

CMD ["bash", "-c", "dbt build && jupyter notebook --allow-root --ServerApp.ip='0.0.0.0' --no-browser"]