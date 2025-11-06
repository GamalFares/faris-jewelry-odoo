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
    gcc \
    g++ \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Download Odoo 17
RUN git clone https://github.com/odoo/odoo.git --branch 17.0 --depth 1

# Install Python dependencies manually (skip problematic requirements.txt)
RUN pip install --no-cache-dir \
    Babel==2.14.0 \
    chardet==5.2.0 \
    cryptography==41.0.7 \
    decorator==5.1.1 \
    docutils==0.20.1 \
    freezegun==1.5.1 \
    gevent==23.9.1 \
    greenlet==3.0.1 \
    idna==3.6 \
    Jinja2==3.1.2 \
    libsass==0.22.0 \
    lxml==5.2.1 \
    MarkupSafe==2.1.3 \
    num2words==0.5.13 \
    passlib==1.7.4 \
    Pillow==10.1.0 \
    polib==1.2.0 \
    psutil==5.9.8 \
    psycopg2-binary==2.9.7 \
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
    urllib3==2.0.7 \
    vobject==0.9.6.1 \
    Werkzeug==3.0.1 \
    xlrd==2.0.1 \
    XlsxWriter==3.1.9 \
    xlwt==1.3.0 \
    zeep==4.2.1

# Copy custom addons
COPY custom-addons/ ./custom-addons/

# Set Python path
ENV PYTHONPATH=/app/odoo:$PYTHONPATH

# Create user
RUN useradd -m -U odoo-user
RUN chown -R odoo-user:odoo-user /app
USER odoo-user

# Create data directory for SQLite
RUN mkdir -p /tmp/odoo-data

# Start Odoo with SQLite
CMD cd odoo && python odoo-bin \
    --addons-path=addons,../custom-addons \
    --database=file:///tmp/odoo-data/faris_jewelry.db \
    --http-port=${PORT} \
    --without-demo=all \
    --proxy-mode