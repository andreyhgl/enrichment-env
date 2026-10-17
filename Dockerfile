FROM bioconductor/bioconductor_docker:RELEASE_3_19

# System tools (procps is useful inside Nextflow pipelines) and
# headers needed to compile Bioconductor packages from source
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  git \
  less \
  procps \
  && rm -rf /var/lib/apt/lists/*

# Install R-packages
COPY install.R /tmp/install.R
RUN Rscript /tmp/install.R

WORKDIR /data
CMD ["/bin/bash"]
