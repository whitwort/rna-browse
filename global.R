library(shiny)
library(shinydashboard)
library(DT)

library(magrittr)


sources <- lapply( list.files("data", ".rds", full.names = TRUE)
                 , function(path) { readRDS(path) }
                 )

names(sources) <- sapply(sources, function(s) { s$name } )
print(names(sources))