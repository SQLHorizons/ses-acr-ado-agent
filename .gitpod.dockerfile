FROM gitpod/workspace-full:latest

ARG PS_VERSION=7.1.4
ARG PS_PACKAGE=powershell_${PS_VERSION}-1.ubuntu.20.04_amd64.deb

RUN wget https://github.com/PowerShell/PowerShell/releases/download/v${PS_VERSION}/${PS_PACKAGE} && \
    sudo add-apt-repository universe && \
    sudo dpkg --force-all -i ${PS_PACKAGE} && \
    rm ${PS_PACKAGE}
