FROM jupyter/datascience-notebook

USER root

RUN apt-get update && \
    apt-get install -y python-dev curl gcc g++ xz
    
ADD requirements.txt requirements.txt
RUN pip install --upgrade pip && \
    pip install -r requirements.txt
    
USER main
WORKDIR $HOME
