# Choose your desired base image
FROM jupyter/minimal-notebook:latest

# name your environment and choose the python version
ARG conda_env=python37
ARG py_ver=3.7
RUN source ${HOME}/.bashrc

# you can add additional libraries you want mamba to install by listing them below the first line and ending with "&& \"
RUN mamba create --quiet --yes -p "${CONDA_DIR}/envs/${conda_env}" python=${py_ver} ipython ipykernel && \
    mamba clean --all -f -y

# create Python kernel and link it to jupyter
RUN "${CONDA_DIR}/envs/${conda_env}/bin/python" -m ipykernel install --user --name="${conda_env}" && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

RUN source activate ${conda_env} && \
    conda install -c anaconda zeromq -y && \
    conda install -c anaconda numpy -y && \
    conda install -c anaconda mysql-connector-python -y && \
    conda install -c anaconda matplotlib -y
