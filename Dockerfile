ARG FROM_TAG=7.1.4-ubuntu-20.04
ARG PWSH_CORE_REPO=mcr.microsoft.com/powershell
ARG PESTER_VERSION=5.3.0
ARG ANALYZER_VERSION=1.20.0
ARG AZP_AGENT_VERSION=2.191.1

FROM ${PWSH_CORE_REPO}:${FROM_TAG} AS INSTALLER_ENV

##  build arguments.
ARG DEBIAN_FRONTEND=noninteractive
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

ENV AZP_POOL=Default \
  AZP_WORK=_work \
  AZP_AGENT_VERSION=${AZP_AGENT_VERSION}

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

SHELL ["pwsh", "-command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common \
  jq \
  git \
  iputils-ping \
  libcurl4 \
  libicu66 \
  libunwind8 \
  netcat && \
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
  apt-get update && \
  apt-get install docker-ce docker-ce-cli containerd.io && \
  apt-get clean && rm -rf /var/lib/apt/lists/* && \
  Install-Module Pester -Repository PSGallery -RequiredVersion ${PESTER_VERSION} -Scope AllUsers -Force && \
  Install-Module PSScriptAnalyzer -Repository PSGallery -RequiredVersion ${ANALYZER_VERSION} -Scope AllUsers -Force

WORKDIR /azp

COPY ./scripts/start-docker.sh .
RUN chmod +x start-docker.sh

CMD ["/azp/start-docker.sh"]
