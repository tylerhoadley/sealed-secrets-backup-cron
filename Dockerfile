FROM debian:bullseye-20231030
USER root

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -qq update && apt-get -y install ca-certificates nano curl git jq procps p7zip-full && apt-get -qq upgrade -y && apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"  && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

ADD setup.sh /usr/local/bin/run_ss-backup.sh
RUN chmod +x /usr/local/bin/run_ss-backup.sh 

ENTRYPOINT ["/usr/local/bin/run_ss-backup.sh"]
