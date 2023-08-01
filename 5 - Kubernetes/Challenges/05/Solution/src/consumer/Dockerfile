FROM python:3.10.5-alpine
WORKDIR /consumer
ENV LOCAL=true PYTHONUNBUFFERED="1"
RUN pip install --no-cache-dir requests==2.31.0
COPY . /consumer
EXPOSE 8000
CMD ["python", "consumer.py"]