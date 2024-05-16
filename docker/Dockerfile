FROM sphinxdoc/sphinx-latexpdf:7.3.7

WORKDIR /docs

RUN apt-get update \
    && apt-get install -y git \
    && rm -rf /var/lib/apt/lists/*
ADD requirements.txt /docs
RUN pip3 install -r requirements.txt
RUN chmod -R 777 /var/lib/texmf # Solve permissions for lualatex