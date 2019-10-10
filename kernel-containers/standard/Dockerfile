FROM elyra/kernel-py:2.0.0
RUN conda install --quiet --yes \
    'fastparquet=0.3.*' \
    'xgboost=0.90' \
    'tqdm=4.*' \
    'black' \
    'isort' \
    && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER
RUN git clone https://github.com/datarevenue-berlin/sparsity.git && \
    cd sparsity && \
    git checkout v0.21.0-rc1 && \
    pip install -e .
