######################################################### TOOLCHAIN VERSIONING #########################################
# Leave version blank to install latest, or specify a version to pin
# NOTE: Docker, Azure CLI, and Ansible always install latest (scripts do not support version pinning)
ARG UBUNTU_VERSION=24.04
ARG KUBECTL_VERSION=
ARG HELM_VERSION=
ARG TERRAFORM_VERSION=
ARG TERRAGRUNT_VERSION=
ARG POWERSHELL_VERSION=
ARG KUBELOGIN_VERSION=
ARG YQ_VERSION=
ARG TFLINT_VERSION=
ARG TF_SUMMARIZE_VERSION=
ARG CHECKOV_VERSION=
ARG NODE_VERSION=
ARG DOTNET_VERSION=
ARG AZCOPY_VERSION=
ARG CLAUDE_CODE_VERSION=
ARG CODEX_VERSION=
ARG CSWAP_VERSION=
ARG GITLEAKS_VERSION=
ARG UV_VERSION=
FROM mcr.microsoft.com/devcontainers/base:ubuntu-${UBUNTU_VERSION} AS final

ARG USERNAME=vscode
ARG KUBECTL_VERSION
ARG HELM_VERSION
ARG TERRAFORM_VERSION
ARG TERRAGRUNT_VERSION
ARG POWERSHELL_VERSION
ARG KUBELOGIN_VERSION
ARG YQ_VERSION
ARG TFLINT_VERSION
ARG TF_SUMMARIZE_VERSION
ARG AZCOPY_VERSION
ARG CHECKOV_VERSION
ARG NODE_VERSION
ARG DOTNET_VERSION
ARG CLAUDE_CODE_VERSION
ARG CODEX_VERSION
ARG CSWAP_VERSION
ARG GITLEAKS_VERSION
ARG UV_VERSION

# Install base packages
ARG PKGS="\
    gnupg \
    software-properties-common \
    ncat \
    curl \
    wget \
    git \
    unzip \
    jq \
    ca-certificates \
    iputils-ping \
    dnsutils \
    postgresql-client \
    cifs-utils \
    gettext-base \
    "

# Trust any extra CA certificates dropped into files/certs/ (see the README there).
# The directory may hold nothing but the README, in which case only the public
# roots from the base image are trusted and the build still succeeds.
# REQUESTS_CA_BUNDLE / SSL_CERT_FILE cover Python (az, ansible, checkov, etc.) and
# curl; Node.js ignores the system store, so NODE_EXTRA_CA_CERTS points it at the
# merged bundle explicitly.
COPY files/certs/ /usr/local/share/ca-certificates/extra/
RUN chmod -R a+r /usr/local/share/ca-certificates/extra && \
    update-ca-certificates
ENV REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt \
    SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt \
    NODE_EXTRA_CA_CERTS=/etc/ssl/certs/ca-certificates.crt

# Allow system-wide pip installs (PEP 668 on Ubuntu 24.04+)
# Safe in a devcontainer where system Python is the intended target
ENV PIP_BREAK_SYSTEM_PACKAGES=1
ENV PIP_ROOT_USER_ACTION=ignore

# NOTE: apt-get upgrade removed to improve layer cacheability.
# The base image is maintained upstream; weekly scheduled builds (--no-cache) pick up updates.
RUN apt-get update && \
    apt-get install --no-install-recommends -y ${PKGS} && \
    apt-get autoremove --purge -y && \
    rm -rf /var/lib/apt/lists/*

# Copy all installation scripts
COPY ./files/install/*.sh /tmp/install/
RUN chmod +x /tmp/install/*.sh

RUN /tmp/install/install-python-tools.sh

RUN /tmp/install/install-azure-cli.sh

RUN /tmp/install/install-azcopy.sh ${AZCOPY_VERSION}

RUN /tmp/install/install-terraform.sh ${TERRAFORM_VERSION} && \
    /tmp/install/install-terragrunt.sh ${TERRAGRUNT_VERSION} && \
    /tmp/install/install-tflint.sh ${TFLINT_VERSION} && \
    /tmp/install/install-tf-summarize.sh ${TF_SUMMARIZE_VERSION} && \
    /tmp/install/install-checkov.sh ${CHECKOV_VERSION}

RUN /tmp/install/install-docker.sh

RUN /tmp/install/install-ansible.sh

RUN /tmp/install/install-helm.sh ${HELM_VERSION} && \
    /tmp/install/install-kubectl.sh ${KUBECTL_VERSION} && \
    /tmp/install/install-kubelogin.sh ${KUBELOGIN_VERSION} 

RUN /tmp/install/install-powershell.sh ${POWERSHELL_VERSION}

RUN /tmp/install/install-yq.sh ${YQ_VERSION} && \
    /tmp/install/install-git-crypt.sh && \
    /tmp/install/install-pre-commit.sh && \
    /tmp/install/install-gitleaks.sh ${GITLEAKS_VERSION}

RUN /tmp/install/install-node.sh ${NODE_VERSION} && \
    /tmp/install/install-codex.sh ${CODEX_VERSION}

# .NET SDK: system-wide install dir, dev-friendly defaults, and ~/.dotnet/tools
# (per-user global tools) on PATH so `dotnet tool install -g` works out of the box.
ENV DOTNET_ROOT=/usr/share/dotnet \
    DOTNET_CLI_TELEMETRY_OPTOUT=1 \
    DOTNET_NOLOGO=1 \
    PATH="${PATH}:/usr/share/dotnet:/home/${USERNAME}/.dotnet/tools"
RUN /tmp/install/install-dotnet.sh ${DOTNET_VERSION}

# uv: fast Python package/project manager. Installed for interactive use only —
# nothing in this image is installed through it yet, so it deliberately sits
# late, where a version bump costs no cached layers. Migrating the first tool to
# `uv tool install` means moving this RUN above that tool's own.
RUN /tmp/install/install-uv.sh ${UV_VERSION}

# claude-swap (`cswap`): Claude Code multi-account switcher. Installed
# system-wide rather than into ~/.local because /home/vscode is a named volume
# only seeded from /tmp-home on first start — a home-tree install would go
# stale for anyone with a pre-existing volume.
RUN /tmp/install/install-cswap.sh ${CSWAP_VERSION}

# Claude Code is installed natively (not via npm -g) into the vscode user's
# ~/.local tree so that auto-updates work without sudo. It must run as the
# vscode user (with HOME set explicitly — the USER instruction does not set
# HOME) and before the /tmp-home snapshot below, so the install is seeded into
# the home volume on first container start.
USER ${USERNAME}
RUN HOME=/home/${USERNAME} /tmp/install/install-claude-code.sh ${CLAUDE_CODE_VERSION}
USER root

# Codex bootstrap: ships a config template + interactive init script.
# Users run `codex-init` manually to be prompted for endpoint URL and deployment
# name; values are saved to ~/.config/codex-bootstrap.env and ~/.codex/config.toml is rendered.
COPY ./files/codex/config.toml.tmpl /usr/local/share/codex/config.toml.tmpl
COPY ./files/codex/codex-init /usr/local/bin/codex-init
RUN chmod +x /usr/local/bin/codex-init && \
    chmod 0644 /usr/local/share/codex/config.toml.tmpl

# Set zsh as default shell and prepare home directory template
RUN chsh -s /bin/zsh ${USERNAME} && \
    cp -r /home/vscode/. /tmp-home

COPY ./files/home/ /tmp-home/
COPY ./files/entrypoint.sh /usr/local/bin/entrypoint.sh

# Source environment in bashrc, install zsh plugins, and cleanup
RUN echo '' >> /tmp-home/.bashrc && \
    echo '# Load DevContainer environment' >> /tmp-home/.bashrc && \
    echo 'if [ -f ~/.environment ]; then' >> /tmp-home/.bashrc && \
    echo '    source ~/.environment' >> /tmp-home/.bashrc && \
    echo 'fi' >> /tmp-home/.bashrc && \
    git -c advice.detachedHead=false clone --branch v0.7.1 --depth 1 https://github.com/zsh-users/zsh-autosuggestions /tmp-home/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
    git -c advice.detachedHead=false clone --branch 0.8.0 --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git /tmp-home/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
    rm -rf /tmp/install-* /tmp/install /var/lib/apt/lists/*

HEALTHCHECK --interval=60s --timeout=10s --retries=3 \
    CMD terraform version > /dev/null 2>&1 && python3 --version > /dev/null 2>&1 || exit 1

USER $USERNAME

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]