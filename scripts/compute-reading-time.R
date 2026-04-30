#!/usr/bin/env Rscript
# Pre-render script: injects prose-reading-time into each post's YAML front matter.
# Word count excludes fenced code blocks and inline code.
# Runs before Quarto renders so the listing engine sees the field.

WPM <- 200L

count_prose_words <- function(file) {
  text <- paste(readLines(file, warn = FALSE), collapse = "\n")

  # Strip YAML front matter ((?s) makes . match newlines in PCRE)
  body <- sub("(?s)^---\\n.*?\\n---\\n?", "", text, perl = TRUE)

  # Strip fenced code blocks (with or without language tag)
  body <- gsub("(?s)```\\{[^}]*\\}.*?```", "", body, perl = TRUE)
  body <- gsub("(?s)```.*?```",            "", body, perl = TRUE)

  # Strip inline code
  body <- gsub("`[^`\n]+`", "", body, perl = TRUE)

  tokens <- unlist(strsplit(body, "\\s+"))
  sum(nchar(tokens) > 0L)
}

set_field <- function(file, label) {
  lines <- readLines(file, warn = FALSE)
  if (length(lines) == 0L || lines[1L] != "---") return(invisible(NULL))

  # Find closing --- of YAML block
  rest      <- lines[-1L]
  close_pos <- which(rest == "---")[1L]
  if (is.na(close_pos)) return(invisible(NULL))
  end_idx   <- close_pos + 1L           # real index in `lines`

  field_line <- paste0('prose-reading-time: "', label, '"')

  # Find existing field (if any) within the YAML block
  yaml_range    <- seq_len(end_idx - 1L)[-1L]   # lines 2..(end_idx-1)
  existing_rows <- grep("^prose-reading-time:", lines[yaml_range])

  if (length(existing_rows) > 0L) {
    real_row <- yaml_range[existing_rows[1L]]
    if (lines[real_row] == field_line) return(invisible(NULL))   # unchanged
    lines[real_row] <- field_line
  } else {
    # Insert just before closing ---
    lines <- c(lines[seq_len(end_idx - 1L)], field_line, lines[end_idx:length(lines)])
  }

  writeLines(lines, file)
  cat(sprintf("  [reading-time] %s -> %s\n", file, label))
}

process <- function(file) {
  words   <- tryCatch(count_prose_words(file), error = function(e) 0L)
  minutes <- max(1L, ceiling(words / WPM))
  set_field(file, as.character(minutes))
}

# Glob one level deep inside posts/ (avoids picking up posts/index.qmd)
en_files <- Sys.glob("posts/*/index.qmd")
el_files <- Sys.glob("posts/*/index.el.qmd")

for (f in en_files) process(f)
for (f in el_files) process(f)
