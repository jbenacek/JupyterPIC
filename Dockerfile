FROM jupyter/datascience-notebook

MAINTAINER Benjamin J. Winjum <bwinjum@ucla.edu>
#With grateful acknowledgements to the Jupyter Project <jupyter@googlegroups.com> for Jupyter
#And to the Particle-in-Cell and Kinetic Simulation Software Center for OSIRIS:

USER root

#
# OSIRIS
#
RUN apt-get update && \
    apt-get install -yq --no-install-recommends \
    libopenmpi-dev \
    libhdf5-openmpi-dev \
    gfortran \
    openmpi-bin \
    openmpi-common \
    openmpi-doc \
    gcc-4.8 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV H5_ROOT /usr/lib/x86_64-linux-gnu/hdf5/openmpi/lib

RUN mkdir /usr/local/osiris
RUN mkdir /usr/local/beps
ENV PATH $PATH:/usr/local/osiris:/usr/local/beps
ENV PYTHONPATH $PYTHONPATH:/usr/local/osiris
COPY osiris-1D.e /usr/local/osiris/osiris-1D.e
COPY upic-es.out /usr/local/beps/upic-es.out
COPY osiris.py /usr/local/osiris/osiris.py
COPY combine_h5_util_1d.py /usr/local/osiris/combine_h5_util_1d.py
COPY combine_h5_util_2d.py /usr/local/osiris/combine_h5_util_2d.py
COPY analysis.py /usr/local/osiris/analysis.py
COPY h5_utilities.py /usr/local/osiris/h5_utilities.py
COPY str2keywords.py /usr/local/osiris/str2keywords.py
RUN chmod -R 711 /usr/local/osiris/osiris-1D.e
RUN chmod -R 711 /usr/local/beps/upic-es.out

WORKDIR work
COPY notebooks notebooks
RUN chmod 777 notebooks
WORKDIR notebooks
RUN chmod 777 electron-plasma-wave-dispersion
RUN chmod 777 faraday-rotation
RUN chmod 777 light-wave-dispersion
RUN chmod 777 light-wave-vacuum-into-plasma
RUN chmod 777 r-and-l-mode-dispersion
RUN chmod 777 velocities
RUN chmod 777 x-and-o-mode-dispersion
RUN chmod 777 x-mode-propagation

USER $NB_USER
