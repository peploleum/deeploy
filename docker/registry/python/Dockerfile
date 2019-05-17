ARG IMAGE=192.168.0.52:9082/python:3.6.8-alpine3.9
FROM $IMAGE
COPY pip.conf /root/.config/pip/pip.conf
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
