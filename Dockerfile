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

# Install Odoo dependencies
RUN pip install --no-cache-dir \
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
    rjsmin==1.2.0 \
    urllib3==2.0.7 \
    vobject==0.9.6.1 \
    Werkzeug==3.0.1 \
    xlrd==2.0.1 \
    XlsxWriter==3.1.9 \
    xlwt==1.3.0

# Copy custom addons
COPY custom-addons/ ./custom-addons/

# Set Python path
ENV PYTHONPATH=/app/odoo:$PYTHONPATH

# Create user
RUN useradd -m -U odoo-user
RUN chown -R odoo-user:odoo-user /app
USER odoo-user

# Create odoo configuration file using proper syntax
RUN echo "[options]" > /app/odoo.conf && \
    echo "addons_path = /app/odoo/addons,/app/custom-addons" >> /app/odoo.conf && \
    echo "data_dir = /tmp/odoo-data" >> /app/odoo.conf && \
    echo "admin_passwd = ${DB_PASSWORD}" >> /app/odoo.conf && \
    echo "db_name = faris_jewelry_db" >> /app/odoo.conf && \
    echo "db_host = dpg-d46h36qli9vc73fekfn0-a.frankfurt-postgres.render.com" >> /app/odoo.conf && \
    echo "db_user = faris_jewelry_db_user" >> /app/odoo.conf && \
    echo "db_password = 0bLwx3jy7aSnwmvVTaFbysL8cuOHjPIk" >> /app/odoo.conf && \
    echo "db_port = 5432" >> /app/odoo.conf && \
    echo "without_demo = True" >> /app/odoo.conf && \
    echo "proxy_mode = True" >> /app/odoo.conf

# Start Odoo with configuration file
CMD cd odoo && python odoo-bin -c /app/odoo.conf --http-port=${PORT} --init=base,web --without-demo=all --proxy-mode