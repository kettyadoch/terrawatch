#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    # fluidPage(
    #   h1("TerraWatchApp")
    
    # )
    # tags$img(src="www/logo.png", 
    #          height = "100px",
    #          width = "90px", 
    #          style = "margin: 5px;display:inline-block;float:left;")
    
    # # Set height of dashboardHeader
    # tags$li(class = "dropdown",
    #         tags$style(".main-header {max-height: 200px}"),
    #         tags$style(".main-header .logo {height: 200px}")
    # ),
    # # Use image in title
    # title = tags$a(href='',
    #                tags$img(src='www/logo2.png'))
    
    #title = span(img(src="www/logo2.png", width = 50, style = "padding-top: 20px;padding-top:20px; display:inline-block;float:left;"))
    shinydashboardPlus::dashboardPage(
      options = list(sidebarExpandOnHover = TRUE),
      header = shinydashboardPlus::dashboardHeader(
        tags$li(class = "dropdown",
                tags$style(".main-header {max-height: 200px}"),
                tags$style(".main-header .logo {height: 70px}")
        ),
        # Use image in title
        title = tags$a(href='',
                       tags$img(src='www/logo2.png', width = 70, height = 70, style = "padding: 10px;display:inline-block;float:left;"))
      ),
      
      sidebar = shinydashboardPlus::dashboardSidebar(minified = TRUE, collapsed = TRUE, width = 40),
      
      body = shinydashboard::dashboardBody(
        fresh::use_theme(mytheme),
        tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"),
        
        leaflet::leafletOutput("map"),
        shinymanager::auth_ui(id = "auth",
                              background = "no-repeat center url('www/earth.png');",
        ),
        
        shinymanager::fab_button(
          shiny::actionButton(
            inputId = "logout",
            label = NULL,
            tooltip = "Logout",
            icon = icon("sign-out")
          )
        ),
        
        shiny::absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                      draggable = TRUE, top = 80, left = "auto", right = 100, bottom = "auto",
                      width = 450, height = "auto",
                      
                      h2("LOCATION SELECTION", style="text-align:center;"),
                      hr(),
                      
                      div(
                        shiny::selectInput(inputId = "searchopts", 
                                           label = "Choose the option to search for your location of interest",
                                           choices = c("","Multi-points", "Single-Point", "Upload Image"),
                                           selected = c(""),
                                           width = "100%"),
                        
                        conditionalPanel(
                          condition = "input.searchopts == 'Multi-points'",
                          hr(),
                          p(strong("Double click any cell in table below to enter your coordinates.")),
                          DT::DTOutput("coordtab"),
                          br(),
                          shinyWidgets::actionBttn("search",
                                                   "GO TO LOCATION", 
                                                   icon = icon("search"),
                                                   style = "material-flat",
                                                   size = "xs",
                                                   color = "success"),
                          br()
                        ),
                        
                        shiny::conditionalPanel(
                          condition = "input.searchopts == 'Single-Point'",
                          
                          div(
                            hr(),
                            p(strong("Enter your coordinates in the text boxes below")),
                            fluidRow(
                              
                              column(
                                6,
                                shiny::textInput("lng","Longitude", placeholder = "Longitude")
                              ),
                              column(
                                6,
                                shiny::textInput("lat","Latitude", placeholder = "Latitude")
                              )
                            )
                          ),
                          shinyWidgets::actionBttn("search2",
                                                   "GO TO LOCATION", 
                                                   icon = icon("search"),
                                                   style = "material-flat",
                                                   size = "xs",
                                                   color = "success"),
                          br()
                        ),
                        
                        br(),
                        #hr()
                        shiny::conditionalPanel(
                          condition = "input.searchopts == 'Upload Image'",
                          
                          hr(),
                          shiny::fileInput("upload", "UPLOAD"),
                          hr(),
                        ),
                      ),
                      
                      div(
                        br(),
                        hr(),
                        style = "text-align:center;",
                        shinyWidgets::actionBttn("classify",
                                                 "CLASSIFY", 
                                                 icon = icon("search"),
                                                 style = "material-flat",
                                                 size = "sm",
                                                 color = "success"),
                        hr()
                      )
        ),
        tags$div(id = 'infocad'),

      ),
      controlbar = shinydashboardPlus::dashboardControlbar(),
      title = "DashboardPage"
    )
  )
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
 
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'TerraWatchApp'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}

