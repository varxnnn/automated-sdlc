#!/bin/bash
sudo yum update
sudo yum -y install docker
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo usermod -a -G docker ec2-user
sudo systemctl start docker

cd /home/ec2-user

mkdir -p monitoring
cd monitoring

touch prometheus.yaml
cat <<EOT >> prometheus.yaml
global:
  scrape_interval: 15s 

scrape_configs:
  - job_name: "react"
    static_configs:
      - targets: ["nginx-exporter:9113"]
EOT

touch docker-compose.yaml
cat <<EOT >> docker-compose.yaml
---
services:
  prometheus:
    image: prom/prometheus:latest
    networks: 
      - profana
    ports: 
      - 9090:9090
    container_name: prometheus
    volumes:
      - ./prometheus.yaml:/etc/prometheus/prometheus.yml:ro,Z
    
  react:
    image: varxn/major-react:deployment
    networks: 
      - profana
    ports: 
      - 80:80
      - 81:81
    container_name: react

  nginx-exporter:
    restart: always
    image: nginx/nginx-prometheus-exporter:latest
    networks:
      - profana
    ports:
      - 9113:9113
    container_name: nginx_exporter
    command: ["-nginx.scrape-uri", "http://react:81/"]
  
  grafana:
    image: grafana/grafana-oss:latest
    networks:
      - profana
    ports: 
      - 3000:3000
    container_name: grafana
    volumes:
      - ./grafana/provisioning/datasources.yml:/etc/grafana/provisioning/datasources/datasources.yml
      - ./grafana/provisioning/dashboards/:/etc/grafana/provisioning/dashboards/
  
networks:
  profana:
EOT


mkdir -p grafana
cd grafana
mkdir -p provisioning
cd provisioning


touch datasources.yml
cat <<EOT >> datasources.yml
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    orgId: 1
    url: http://prometheus:9090
    isDefault: true
    version: 1
    editable: true
EOT