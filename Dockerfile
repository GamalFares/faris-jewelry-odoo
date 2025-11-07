FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libsasl2-dev \
    libldap2-dev \
    libssl-dev \
    libjpeg-dev \
    libopenjp2-7-dev \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    gcc \
    g++ \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

WORKDIR /app

# Download Odoo 17
RUN git clone https://github.com/odoo/odoo.git --branch 17.0 --depth 1

# Install Odoo dependencies from Odoo's requirements + your custom requirements
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r /app/odoo/requirements.txt
RUN pip install --no-cache-dir \
    psycopg2-binary==2.9.7 \
    Babel==2.14.0 \
    chardet==5.2.0 \
    decorator==5.1.1 \
    docutils==0.20.1 \
    gevent==23.9.1 \
    greenlet==3.0.1 \
    idna==3.6 \
    Jinja2==3.1.2 \
    libsass==0.22.0 \
    lxml==5.2.1 \
    lxml-html-clean==0.4.3 \
    MarkupSafe==2.1.3 \
    num2words==0.5.13 \
    passlib==1.7.4 \
    Pillow==10.1.0 \
    polib==1.2.0 \
    psutil==5.9.8 \
    pydot==1.4.2 \
    pyOpenSSL==23.2.0 \
    PyPDF2==3.0.1 \
    pypdf==3.17.4 \
    pyserial==3.5 \
    python-dateutil==2.8.2 \
    pytz==2024.1 \
    qrcode==7.4.2 \
    reportlab==4.0.4 \
    requests==2.31.0 \
    rjsmin==1.2.0 \
    urllib3==2.0.7 \
    vobject==0.9.6.1 \
    Werkzeug==3.0.1 \
    xlrd==2.0.1 \
    XlsxWriter==3.1.9 \
    xlwt==1.3.0

# Copy custom addons
COPY custom-addons/ ./custom-addons/

# Copy start script
COPY start.sh /app/start.sh

# Set Python path
ENV PYTHONPATH=/app/odoo:$PYTHONPATH

# Create user and data directory with proper permissions
RUN useradd -m -U -s /bin/bash odoo-user && \
    mkdir -p /app/data /app/logs && \
    chown -R odoo-user:odoo-user /app

# Set file permissions for start script
RUN chmod +x /app/start.sh

# Switch to odoo-user
USER odoo-user

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:${PORT:-10000}/web/health || exit 1

# Expose port
EXPOSE 10000

# Start Odoo
CMD ["/app/start.sh"]