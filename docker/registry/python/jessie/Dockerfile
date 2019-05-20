ARG IMAGE
ARG NEXUS_HOST
ARG NEXUS_PORT
FROM $NEXUS_HOST:$NEXUS_PORT/$IMAGE
COPY sources.list /etc/apt/
COPY pip.conf /root/.config/pip/pip.conf
COPY base-requirements.txt ./
# jessie needs apt config
RUN pip install --no-cache-dir -r base-requirements.txt
