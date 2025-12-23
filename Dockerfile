FROM ubuntu:22.04

# Evitar prompts durante la instalación
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Instalar dependencias base, GitHub CLI, PHP 8.4 y extensiones en una sola capa
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    unzip \
    zip \
    sudo \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common \
    # Agregar repositorio de GitHub CLI
    && mkdir -p -m 755 /etc/apt/keyrings \
    && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    # Agregar repositorio de PHP
    && add-apt-repository ppa:ondrej/php \
    && apt-get update && apt-get install -y --no-install-recommends \
    gh \
    php8.4-cli \
    php8.4-dev \
    php8.4-pgsql \
    php8.4-sqlite3 \
    php8.4-gd \
    php8.4-curl \
    php8.4-imap \
    php8.4-mbstring \
    php8.4-xml \
    php8.4-zip \
    php8.4-bcmath \
    php8.4-soap \
    php8.4-intl \
    php8.4-readline \
    php8.4-ldap \
    php8.4-msgpack \
    php8.4-igbinary \
    php8.4-redis \
    php8.4-pcov \
    php8.4-xdebug \
    postgresql-client \
    redis-tools \
    jq \
    vim \
    nano \
    && rm -rf /var/lib/apt/lists/*

# Instalar Composer, Node.js y MinIO Client en paralelo (una sola capa)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && ARCH=$(dpkg --print-architecture) \
    && if [ "$ARCH" = "arm64" ]; then MC_ARCH="linux-arm64"; else MC_ARCH="linux-amd64"; fi \
    && curl -fsSL -o /usr/local/bin/mc https://dl.min.io/client/mc/release/${MC_ARCH}/mc \
    && chmod +x /usr/local/bin/mc \
    && rm -rf /var/lib/apt/lists/*

# Crear usuario coder
RUN useradd -m -s /bin/bash coder && \
    echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/coder && \
    chmod 0440 /etc/sudoers.d/coder && \
    chown -R coder:coder /home/coder

# Configurar directorio de trabajo
WORKDIR /workspaces
RUN chown -R coder:coder /workspaces

# Cambiar al usuario coder
USER coder
WORKDIR /home/coder

# Configurar directorios y PATH
ENV NPM_CONFIG_PREFIX=/home/coder/.npm-global \
    BUN_INSTALL=/home/coder/.bun \
    COMPOSER_HOME=/home/coder/.composer \
    PATH=/home/coder/.bun/bin:/home/coder/.npm-global/bin:/home/coder/.composer/vendor/bin:$PATH

RUN mkdir -p /home/coder/.npm-global /home/coder/.bun /home/coder/.composer \
    && curl -fsSL https://bun.sh/install | bash \
    && npm install -g @vue/cli create-vite \
    && composer global require laravel/installer \
    && git config --global init.defaultBranch main

# Exponer puertos para Laravel y Vite
EXPOSE 8000 5173

# Comando por defecto
CMD ["/bin/bash"]
