ARG IMAGE
ARG NEXUS_HOST
ARG NEXUS_PORT
FROM $NEXUS_HOST:$NEXUS_PORT/$IMAGE
COPY pip.conf /root/.config/pip/pip.conf
COPY base-requirements.txt ./
RUN pip install --no-cache-dir -r base-requirements.txt
