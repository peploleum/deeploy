ARG IMAGE
ARG NEXUS_HOST
ARG NEXUS_PORT
FROM $NEXUS_HOST:$NEXUS_PORT/$IMAGE
COPY pip.conf /root/.config/pip/pip.conf

# jessie needs apt config
RUN sudo apt-add-repository http://$NEXUS_HOST:8081/repository/apt-ansible-bionic/

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
