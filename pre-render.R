# Add the date of the last update in the cv pdf
# Only run date logic if rendering locally, not on GitHub Actions
if (Sys.getenv("GITHUB_ACTIONS") != "true") {
  css_files <- c("CV/CV_english.css", "CV/CV_french.css")
  qmd_files <- c("CV/CV_english.qmd", "CV/CV_french.qmd")

  for (i in seq_along(css_files)) {
    # Check if the corresponding qmd file has been modified in Git
    git_status <- system2(
      "git",
      args = c("diff", "--name-only", "HEAD", qmd_files[i]),
      stdout = TRUE
    )
    if (length(git_status) > 0) {
      # File has changed, update the date
      today <- format(Sys.Date(), "%Y-%m-%d")
      css <- readLines(css_files[i])
      css <- gsub(
        'content: "\\d{4}-\\d{2}-\\d{2}"',
        paste0('content: "', today, '"'),
        css
      )
      writeLines(css, css_files[i])
      message(paste("Date updated in", css_files[i]))
    } else {
      message(paste("No changes detected in", qmd_files[i], "- date unchanged"))
    }
  }
}


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
