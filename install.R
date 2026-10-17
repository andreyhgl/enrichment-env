#!/usr/bin/env Rscript

n_cpus <- parallel::detectCores()

#---- CRAN packages -----------------------------------------------------------

pkgs_cran <- c(
  "BiocManager",
  "openxlsx",
  "msigdbr"
)

install.packages(
  pkgs_cran,
  repos = "https://cloud.r-project.org",
  Ncpus = n_cpus
)

#---- Bioconductor packages ---------------------------------------------------

pkgs_bioc <- c(
  "AnnotationDbi",
  "clusterProfiler",
  "ReactomePA",
  "org.Mm.eg.db",
  "org.Hs.eg.db",
  "fgsea",
  "enrichplot"
)

# update = FALSE keeps CRAN dependencies at the rocker snapshot versions
BiocManager::install(
  pkgs_bioc,
  ask = FALSE,
  update = FALSE,
  Ncpus = n_cpus
)

#---- Check -------------------------------------------------------------------

# install.packages() only warns on failure, so fail the build explicitly
missing <- setdiff(c(pkgs_cran, pkgs_bioc), rownames(installed.packages()))

if (length(missing) > 0) {
  stop("Failed to install: ", paste(missing, collapse = ", "))
}

cat(" > All packages installed successfully.\n")
