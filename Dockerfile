FROM jupyter/datascience-notebook
USER root

RUN curl -sL https://deb.nodesource.com/setup_12.x |bash - \
    && apt-get install -y --no-install-recommends \
    nodejs \
    yarn

# install python library
COPY requirements.txt .
RUN pip3 install --upgrade pip && \
    pip3 install --no-cache-dir -r requirements.txt \
    && rm -rf ~/.cache/pip

# install jupyterlab&kite
RUN pip3 install --no-cache-dir \
    jupyterlab \
    'jupyterlab-kite>=2.0.2' \
    && jupyter labextension install \
        '@kiteco/jupyterlab-kite'

# install jupyterlab_variableinspector
RUN pip3 install --upgrade --no-cache-dir \
    black \
    isort \
    jupyterlab_code_formatter \
    && jupyter labextension install \
        @ryantam626/jupyterlab_code_formatter \
    && jupyter serverextension enable --py jupyterlab_code_formatter

# install jupyterlab_variableinspector
RUN pip3 install --no-cache-dir lckr-jupyterlab-variableinspector

# install other_extentions
RUN  jupyter labextension install \
    @jupyterlab/toc

# install jupyter-kite
RUN cd && \
    wget https://linux.kite.com/dls/linux/current && \
    chmod 777 current && \
    sed -i 's/"--no-launch"//g' current > /dev/null && \
    ./current --install ./kite-installer

WORKDIR /work
COPY /work /work
