FROM odoo:17.0

USER root

# Install ONLY postgresql-client for database connections
RUN apt-get update && apt-get install -y postgresql-client && rm -rf /var/lib/apt/lists/*

USER odoo

# Copy configuration
COPY odoo.conf /etc/odoo/

EXPOSE 8069

CMD ["odoo"]