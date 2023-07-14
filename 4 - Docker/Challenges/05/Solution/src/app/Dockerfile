FROM python:3.10.5-alpine
WORKDIR /api
RUN pip install --no-cache-dir flask==2.3.2
COPY . /api
EXPOSE 8000
CMD ["python", "app.py"]