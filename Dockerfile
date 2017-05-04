FROM andrewosh/binder-base

USER root

RUN apt-get update && \
    apt-get install -y python-dev curl gcc g++ 
    
ADD requirements.txt requirements.txt
RUN $HOME/anaconda2/envs/python3/bin/pip install --upgrade pip && \
    $HOME/anaconda2/envs/python3/bin/pip install -r requirements.txt


    
RUN conda config --add channels r && \
    conda install --quiet --yes \
    'rpy2=2.8*' \
    'r-base=3.3.1 1' \
    'r-irkernel=0.6*' \
    'r-devtools=1.11*' \
    'r-ggplot2=2.1*' \
    'r-rcurl=1.95*' \
    'r-data.table=1.10.0*' && conda clean -tipsy

USER main
WORKDIR $HOME/notebooks
