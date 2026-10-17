[![Build and Release Docker Container](https://github.com/andreyhgl/enrichment-env/actions/workflows/build-release.yml/badge.svg)](https://github.com/andreyhgl/enrichment-env/actions/workflows/build-release.yml)

A **bioconductor/bioconductor_docker:RELEASE_3_19** container with [clusterProfiler](https://bioconductor.org/packages/clusterProfiler/) and [ReactomePA](https://bioconductor.org/packages/ReactomePA/) R-packages (and some dependencies). Used for functional enrichment analysis, both over-representation analysis (ORA) and gene set enrichment analysis (GSEA), with GO, KEGG, Reactome and MSigDB gene sets.

> [!NOTE]
> Currently only works for human and mouse annotations

<details>
  <summary>Included softwares</summary>

  + R 4.4.0 (Bioconductor 3.19)
  + AnnotationDbi
  + clusterProfiler
  + ReactomePA
  + org.Hs.eg.db (human annotation)
  + org.Mm.eg.db (mouse annotation)
  + fgsea
  + enrichplot
  + msigdbr
  + openxlsx
  + git
  + less
  + procps (needed for Nextflow)
</details>

## Pull the container

```sh
# docker
docker pull ghcr.io/andreyhgl/enrichment-env:main

# apptainer / singularity
apptainer pull docker://ghcr.io/andreyhgl/enrichment-env:main
singularity pull docker://ghcr.io/andreyhgl/enrichment-env:main
```

## Run interactively

```sh
# docker
docker run -it --rm -v $(pwd):/data ghcr.io/andreyhgl/enrichment-env:main

# apptainer / singularity
apptainer shell docker://ghcr.io/andreyhgl/enrichment-env:main
singularity shell docker://ghcr.io/andreyhgl/enrichment-env:main
```

## Include inside a nextflow process

```groovy
process PROCESS {
  container "${workflow.containerEngine == 'singularity' ?
    'docker://ghcr.io/andreyhgl/enrichment-env:main' :
    'ghcr.io/andreyhgl/enrichment-env:main'}"
}
```

The container definition uses an [elvis operator](https://www.nextflow.io/docs/latest/reference/syntax.html#unary-expressions) = `<statement> ? <TRUE> : <FALSE>`

## Build locally

```sh
git clone https://github.com/andreyhgl/enrichment-env.git
cd enrichment-env
docker build -t enrichment-env .
```

---

### Dockerfile details

`Dockerfile` runs the content inside `install.R`, which holds all R-packages. Edit `install.R` in order to add more packages:
+ **CRAN** packages goes into `pkgs_cran`
+ **Bioconductor** packages into `pkgs_bioc`

```dockerfile
# Dockerfile
COPY install.R /tmp/install.R
RUN Rscript /tmp/install.R
```

```r
# install.R
pkgs_cran <- c(
  "BiocManager",
  "openxlsx",
  "msigdbr"
)

install.packages(
  pkgs_cran,
  repos = "https://cloud.r-project.org",
  Ncpus = parallel::detectCores()
)

pkgs_bioc <- c(
  "AnnotationDbi",
  "clusterProfiler",
  "ReactomePA",
  "org.Mm.eg.db",
  "org.Hs.eg.db",
  "fgsea",
  "enrichplot"
)

BiocManager::install(
  pkgs_bioc,
  ask = FALSE,
  update = FALSE,
  Ncpus = parallel::detectCores()
)
```
