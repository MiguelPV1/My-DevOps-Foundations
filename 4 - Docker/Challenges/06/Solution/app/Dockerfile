FROM python:3.10.5-alpine
WORKDIR /poke-app
COPY . /poke-app/
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 5000
CMD ["python", "app.py"]