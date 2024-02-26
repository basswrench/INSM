FROM jasonish/suricata:latest
ENV SURICATA_OPTIONS="-i eno2 -vvv"
COPY suricata.yaml /etc/suricata/
COPY local.rules /var/lib/suricata/rules


