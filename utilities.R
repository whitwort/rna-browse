packageHTML <- function(file) {
  
  s     <- paste(readLines(file), collapse = "\n")
  body  <- regexpr(pattern = "<body>(.*)</body>", text = s)
  start <- as.vector(body)
  n     <- attr(body, "match.length")
  
  substr(s, start = start, stop = start + n)
  
}

pushLive <- function(path = "live/") {
  files <- c("server.R", "ui.R", "global.R")
  file.copy(files, paste(path, files, sep = ""), overwrite = TRUE)
  system("touch live/restart.txt")
}
