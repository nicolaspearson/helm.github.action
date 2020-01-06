# ------------------------------------------------------
#                       Dockerfile
# ------------------------------------------------------
# image:    helm.github.action
# name:     nicolaspearson/helm.github.action/helm.github.action:master
# repo:     https://github.com/nicolaspearson/helm.github.action
# requires: docker:19.03
# authors:  Nicolas Pearson
# ------------------------------------------------------

FROM docker:19.03

LABEL repository="https://github.com/nicolaspearson/helm.github.action"
LABEL maintainer="Nicolas Pearson"

ENV HELM_VERSION="v3.0.0"

RUN apk add --no-cache bash ca-certificates curl git gnupg jq nodejs npm python tar wget

# Install helm
RUN wget https://keybase.io/bacongobbler/pgp_keys.asc -O - | gpg --import
RUN wget -q https://github.com/helm/helm/releases/download/${HELM_VERSION}/helm-${HELM_VERSION}-linux-amd64.tar.gz.asc
RUN wget -q https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz
RUN gpg --verify helm-${HELM_VERSION}-linux-amd64.tar.gz.asc helm-${HELM_VERSION}-linux-amd64.tar.gz &&\
  rm helm-${HELM_VERSION}-linux-amd64.tar.gz.asc
RUN tar -zxvf helm-${HELM_VERSION}-linux-amd64.tar.gz &&\
  rm helm-${HELM_VERSION}-linux-amd64.tar.gz
RUN mv linux-amd64/helm /usr/local/bin/helm && rm -rf linux-amd64
RUN chmod +x /usr/local/bin/helm
RUN helm plugin install https://github.com/hayorov/helm-gcs

COPY lib/ /usr/src/
COPY package.json /usr/src

WORKDIR /usr/src
RUN npm install --only=prod

ENTRYPOINT ["node", "/usr/src/main.js"]
CMD ["bash"]
