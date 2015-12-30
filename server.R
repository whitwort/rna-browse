library(shiny)

shinyServer(function(input, output) {
  
  db <- reactive({ 
    d <- sources[[input$dataset]] 
    
    # Convert annotation columns to links here for efficiency
    for (tblN in 1:length(d$tables)) {
      for (colName in names(d$tables[[tblN]]$links)) {
        
        f <- d$tables[[tblN]]$links[[colName]]
        s <- d$tables[[tblN]]$data[[colName]]
        
        d$tables[[tblN]]$data[[colName]] <-  paste0( '<a href="'
                                                   , f(s)
                                                   , '">'
                                                   , s
                                                   , '</a>'
                                                   )
      }
    }
    
    d
  })
  
  output$menu <- renderUI({
    
    menuItems <- lapply( db()$tables
                       , function(tbl) {
                           menuItem( tbl$name
                                   , tabName = toname(tbl$name)
                                   )
                         }
                       )

    args <- c( list(menuItem("Pipeline", tabName = "notebook"))
             , list(menuItem("Changes", tabName = "changes"))
             , menuItems
             )
    
    do.call(sidebarMenu, args)

  })
  
  output$tabs <- renderUI({

    data <- db()
    
    tabs <- lapply( data$tables
                  , function(tbl) {
                      tabItem( tabName = toname(tbl$name)
                             , fluidRow( tableWidget(tbl, input, output) )
                             )
                    }
                  )
    
    notebook <- data$notebook
    noteTabs <- lapply( names(notebook)
                      , function(name) {
                          tabPanel( name
                                  , fluidRow(HTML(notebook[[name]]))
                                  )
                        }
                      )
    noteTabs$width = 12
    notebox <- do.call(tabBox, noteTabs)
    
    changes <- if (!is.null(data$changes)) { data$changes } else { "" }
    changebox <- box( HTML( markdown::renderMarkdown(text = changes))
                    , title = "Changes"
                    , width = 12
                    )
    
    args <- c( list( tabItem(tabName = "notebook", fluidRow(notebox) ) )
             , list( tabItem(tabName = "changes", fluidRow(changebox) ) )
             , tabs
             )
    
    do.call(tabItems, args)
  })

})

toname <- function(s) { s %>% tolower %>% gsub(" ", "", ., fixed = TRUE) }

tableWidget <- function(tbl, input, output) {
  
  tblId <- paste(toname(tbl$name), 'dt', sep = ".")
  serId <- paste(toname(tbl$name), 'series', sep = ".")
  annId <- paste(toname(tbl$name), 'annotations', sep = ".")
  btnId <- paste(toname(tbl$name), 'button', sep = ".")
  
  data <- reactive({
    dataCols <- tbl$series[[ input[[serId]] ]] 
    annoCols <- input[[annId]] 
    
    cols <- c(dataCols, annoCols)
    
    tbl$data[cols]
    
  })
  
  output[[tblId]] <- DT::renderDataTable({
    
    datatable( data()
             , escape = FALSE
             , filter = 'top'
             )
    
  })
  
  output[[btnId]] <- downloadHandler( filename = paste( toname(tbl$name)
                                                      , toname(input[[serId]])
                                                      , "csv"
                                                      , sep = "."
                                                      )
                                    , content     = function(file) { 
                                                      write.csv(data(), file) 
                                                    }
                                    , contentType = "text/csv"
                                    )
  
  box( helpText(tbl$desc)
     , fluidRow( column( selectInput( serId
                                    , label    = "Series"
                                    , choices  = names(tbl$series)
                                    , selected = names(tbl$series)[1]
                                    , multiple = FALSE
                                    )
                       , width = 4
                       )
               , column( selectInput( annId
                                    , label    = "Annotations"
                                    , choices  = tbl$annotations
                                    , selected = tbl$annotations[1]
                                    , multiple = TRUE
                                    )
                       , width = 4
                       )
               , column(downloadButton(btnId), width = 4)
               )
     , hr()
     , fluidRow(column(12, DT::dataTableOutput(tblId)))
     , title = "Data"
     , width = 12
     )
  
}
