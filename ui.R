shinyUI(bootstrapPage(
  
  dashboardPage( dashboardHeader(title = "RNA(Seq) Browser")
               , dashboardSidebar( uiOutput('selectDataset')
                                 , uiOutput('menu')
                                 )
               , dashboardBody( tags$head(includeScript('highlight.min.js'))
                              , tags$head(includeCSS('highlight.css'))
                              , uiOutput('tabs')
                              )
               , skin = "purple"
               )

))
