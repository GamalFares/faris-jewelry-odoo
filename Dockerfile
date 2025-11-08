FROM odoo:17.0

USER root

# Install only essential system dependencies
RUN apt-get update && apt-get install -y \
    postgresql-client \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install wkhtmltopdf for PDF reports (optional but recommended)
RUN curl -sSL https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.jammy_amd64.deb -o /tmp/wkhtmltopdf.deb \
    && apt-get update \
    && apt-get install -y /tmp/wkhtmltopdf.deb \
    && rm /tmp/wkhtmltopdf.deb

USER odoo

# Copy configuration
COPY odoo.conf /etc/odoo/
COPY entrypoint.sh /

RUN sudo chmod +x /entrypoint.sh

EXPOSE 8069

ENTRYPOINT ["/entrypoint.sh"]
CMD ["odoo"]