FROM jupyter/datascience-notebook

USER root

RUN apt-get update && \
	apt-get install -y --no-install-recommends xz-utils curl
	
USER $NB_USER

COPY requirements.txt ./
RUN pip install --upgrade pip \
    && pip install -r requirements.txt
    
RUN echo "install.packages(c('data.table', 'ggplot2'), repos = 'http://cran.us.r-project.org')" | R --no-save

COPY . /home/$NB_USER/

USER root

RUN chown -R $NB_USER /home/$NB_USER/ && chgrp -R $NB_USER / /home/$NB_USER

USER $NB_USER
