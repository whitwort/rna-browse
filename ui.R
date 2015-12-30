shinyUI(bootstrapPage(
  
  dashboardPage( dashboardHeader(title = "RNA(Seq) Browser")
               , dashboardSidebar( selectInput('dataset', "Dataset", choices = names(sources))
                                 , uiOutput('menu')
                                 )
               , dashboardBody( uiOutput('tabs')
                              )
               , skin = "purple"
               )

))
