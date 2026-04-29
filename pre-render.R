# Update copyright year in _quarto.yml footer
if (Sys.getenv("GITHUB_ACTIONS") != "true") {
  current_year <- format(Sys.Date(), "%Y")
  quarto_yml <- readLines("_quarto.yml")
  quarto_yml <- gsub(
    'left:  "\\d{4} Kinlan M\\.G\\. Jan"',
    paste0('left:  "', current_year, ' Kinlan M.G. Jan"'),
    quarto_yml
  )
  writeLines(quarto_yml, "_quarto.yml")
}

# Add the date of the last update in the cv pdf
if (Sys.getenv("GITHUB_ACTIONS") != "true") {
  
  library(scholar)
  scholar_id <- "Vf6gRpIAAAAJ"
  
  # Fetch current metrics
  profile <- tryCatch(get_profile(scholar_id), error = function(e) NULL)
  
  if (!is.null(profile)) {
    # Load previously saved metrics
    metrics_file <- "CV/last_metrics.rds"
    last_metrics <- tryCatch(readRDS(metrics_file), error = function(e) NULL)
    
    metrics_changed <- is.null(last_metrics) ||
      last_metrics$h_index != profile$h_index ||
      last_metrics$i10_index != profile$i10_index ||
      last_metrics$total_cites != profile$total_cites
    
    # Save current metrics for next comparison
    saveRDS(profile, metrics_file)
    
    css_files <- c("CV/CV_english.css", "CV/CV_french.css")
    qmd_files <- c("CV/CV_english.qmd", "CV/CV_french.qmd")
    
    for (i in seq_along(css_files)) {
      git_status <- system2("git",
                            args = c("diff", "--name-only", "HEAD", qmd_files[i]),
                            stdout = TRUE)
      
      if (length(git_status) > 0 || metrics_changed) {
        today <- format(Sys.Date(), "%Y-%m-%d")
        css <- readLines(css_files[i])
        css <- gsub(
          'content: "\\d{4}-\\d{2}-\\d{2}"',
          paste0('content: "', today, '"'),
          css
        )
        writeLines(css, css_files[i])
        message("Date updated in ", css_files[i])
      } else {
        message("No changes detected - date unchanged")
      }
    }
  }
}