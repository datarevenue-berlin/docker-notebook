FROM jupyter/base-notebook

USER root

RUN apt-get update \
  && apt-get install -yq --no-install-recommends graphviz git \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

USER $NB_USER

RUN conda install --yes --freeze-installed \
    -c conda-forge \
    python-blosc \
    cytoolz \
    dask==2.0.0 \
    nomkl \
    numpy==1.16.2 \
    pandas==0.24.2 \
    ipywidgets \
    dask-labextension==1.0.0 \
    python-graphviz \
    jupyterlab_code_formatter \
    black \
    isort \
    && jupyter labextension install \
      @jupyter-widgets/jupyterlab-manager@1.0.1 \
      dask-labextension@1.0.0 \
      @ryantam626/jupyterlab_code_formatter \
      jupyterlab-drawio \
      @krassowski/jupyterlab_go_to_definition \
      @oriolmirosa/jupyterlab_materialdarker \
    && conda clean -tipsy \
    && jupyter lab clean \
    && jlpm cache clean \
    && npm cache clean --force \
    && find /opt/conda/ -type f,l -name '*.a' -delete \
    && find /opt/conda/ -type f,l -name '*.pyc' -delete \
    && find /opt/conda/ -type f,l -name '*.js.map' -delete \
    && find /opt/conda/lib/python*/site-packages/bokeh/server/static -type f,l -name '*.js' -not -name '*.min.js' -delete \
    && rm -rf /opt/conda/pkgs

RUN jupyter serverextension enable --py jupyterlab_code_formatter
RUN git clone https://github.com/datarevenue-berlin/sparsity.git && pip install -e sparsity/

USER root
RUN fix-permissions /home/jovyan/.jupyter/
# Create the /opt/app directory, and assert that Jupyter's NB_UID/NB_GID values
# haven't changed.
RUN mkdir /opt/app \
    && if [ "$NB_UID" != "1000" ] || [ "$NB_GID" != "100" ]; then \
        echo "Jupyter's NB_UID/NB_GID changed, need to update the Dockerfile"; \
        exit 1; \
    fi

COPY shortcuts.jupyterlab-settings .jupyter/lab/user-settings/@jupyterlab/shortcuts-extension/
COPY themes.jupyterlab-settings .jupyter/lab/user-settings/@jupyterlab/apputils-extension/

RUN fix-permissions .jupyter/ .jupyter/lab
RUN fix-permissions .jupyter/lab/user-settings/@jupyterlab/shortcuts-extension/
RUN fix-permissions .jupyter/lab/user-settings/@jupyterlab/shortcuts-extension/

USER $NB_USER

CMD ["start.sh", "jupyter", "lab"]
