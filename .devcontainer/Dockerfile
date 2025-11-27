######################################################### TOOLCHAIN VERSIONING #########################################
# Leave version blank to install latest, or specify a version to pin
ARG UBUNTU_VERSION=22.04
ARG DOCKER_VERSION=
ARG KUBECTL_VERSION=
ARG HELM_VERSION=
ARG TERRAFORM_VERSION=
ARG TERRAGRUNT_VERSION=
ARG AZ_CLI_VERSION=
ARG ANSIBLE_VERSION=
ARG POWERSHELL_VERSION=
ARG KUBELOGIN_VERSION=
ARG YQ_VERSION=
ARG JQ_VERSION=
ARG TFLINT_VERSION=
ARG CHECKOV_VERSION=

FROM mcr.microsoft.com/devcontainers/base:ubuntu-${UBUNTU_VERSION} AS final

ARG USERNAME=vscode
ARG KUBECTL_VERSION
ARG HELM_VERSION
ARG TERRAFORM_VERSION
ARG TERRAGRUNT_VERSION
ARG AZ_CLI_VERSION
ARG ANSIBLE_VERSION
ARG POWERSHELL_VERSION
ARG KUBELOGIN_VERSION
ARG YQ_VERSION
ARG JQ_VERSION
ARG TFLINT_VERSION
ARG CHECKOV_VERSION

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
    "

RUN apt-get update && \
    apt-get install --no-install-recommends -y ${PKGS} && \
    apt-get upgrade -y && \
    apt-get autoremove --purge -y && \
    rm -rf /var/lib/apt/lists/*

# Copy all installation scripts
COPY ./files/install/*.sh /tmp/install/
RUN chmod +x /tmp/install/*.sh

RUN /tmp/install/install-python-tools.sh

RUN /tmp/install/install-azure-cli.sh

RUN /tmp/install/install-terraform.sh ${TERRAFORM_VERSION} && \
    /tmp/install/install-terragrunt.sh ${TERRAGRUNT_VERSION} && \
    /tmp/install/install-tflint.sh ${TFLINT_VERSION} && \
    /tmp/install/install-checkov.sh ${CHECKOV_VERSION} 

RUN /tmp/install/install-docker.sh

RUN /tmp/install/install-ansible.sh ${ANSIBLE_VERSION}

RUN /tmp/install/install-helm.sh ${HELM_VERSION} && \
    /tmp/install/install-kubectl.sh ${KUBECTL_VERSION} && \
    /tmp/install/install-kubelogin.sh ${KUBELOGIN_VERSION} 

RUN /tmp/install/install-powershell.sh ${POWERSHELL_VERSION}

RUN /tmp/install/install-yq.sh ${YQ_VERSION} && \
    /tmp/install/install-jq.sh ${JQ_VERSION} && \
    /tmp/install/install-git-crypt.sh && \
    /tmp/install/install-pre-commit.sh

# Set zsh as default shell for vscode user
RUN chsh -s /bin/zsh ${USERNAME}
RUN cp -r /home/vscode/. /tmp-home

COPY ./files/home/.bash_aliases /tmp-home/.bash_aliases
COPY ./files/home/.environment /tmp-home/.environment
COPY ./files/home/.zshrc /tmp-home/.zshrc
COPY ./files/home/Microsoft.PowerShell_profile.ps1 /tmp-home/.config/powershell/Microsoft.PowerShell_profile.ps1
COPY ./files/home/ps_theme.json /tmp-home/.config/powershell/ps_theme.json

# Source environment in bashrc
RUN echo '' >> /tmp-home/.bashrc && \
    echo '# Load DevContainer environment' >> /tmp-home/.bashrc && \
    echo 'if [ -f ~/.environment ]; then' >> /tmp-home/.bashrc && \
    echo '    source ~/.environment' >> /tmp-home/.bashrc && \
    echo 'fi' >> /tmp-home/.bashrc

COPY ./files/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN git clone https://github.com/zsh-users/zsh-autosuggestions /tmp-home/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /tmp-home/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# Cleanup - remove install temp directories but keep /tmp-home
RUN rm -rf /tmp/install-* /tmp/install /var/lib/apt/lists/*

USER $USERNAME

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]