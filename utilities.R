packageHTML <- function(file) {
  
  s     <- paste(readLines(file), collapse = "\n")
  body  <- regexpr(pattern = "<body>(.*)</body>", text = s)
  start <- as.vector(body)
  n     <- attr(body, "match.length")
  
  substr(s, start = start, stop = start + n)
  
}

pushLive <- function(path = "live/") {
  files <- c( list.files(pattern = "*.R")
            , list.files(pattern = "*.js")
            , list.files(pattern = "*.css")
            )
  file.copy(files, paste(path, files, sep = ""), overwrite = TRUE)
  system("touch live/restart.txt")
}
