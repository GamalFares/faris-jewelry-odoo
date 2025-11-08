FROM odoo:17.0

# Install dependencies
USER root
RUN apt-get update && apt-get install -y \
    build-essential \
    python3-dev \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    libsasl2-dev \
    libldap2-dev \
    libssl-dev \
    libffi-dev \
    libjpeg-dev \
    libpq-dev \
    libjpeg8-dev \
    liblcms2-dev \
    libblas-dev \
    libatlas-base-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install wkhtmltopdf
RUN curl -sSL https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.bullseye_amd64.deb -o /tmp/wkhtmltopdf.deb \
    && apt-get update \
    && apt-get install -y /tmp/wkhtmltopdf.deb \
    && rm /tmp/wkhtmltopdf.deb

# Switch back to odoo user
USER odoo

# Copy configuration and entrypoint
COPY odoo.conf /etc/odoo/
COPY entrypoint.sh /
COPY scripts/init-odoo.sh /tmp/

RUN sudo chmod +x /entrypoint.sh /tmp/init-odoo.sh

EXPOSE 8069 8072

ENTRYPOINT ["/entrypoint.sh"]
CMD ["odoo"]
