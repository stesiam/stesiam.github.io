lang <- rmarkdown::metadata$lang

if (!is.null(lang) && lang == "el") {
  Sys.setlocale("LC_TIME", "el_GR.UTF-8")
} else {
  Sys.setlocale("LC_TIME", "C")  # safe default, no installation needed
}