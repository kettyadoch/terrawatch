#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # List the first level callModules here
  
  # # authentication module
  auth <- callModule(
    module = shinymanager::auth_server,
    id = "auth",
    check_credentials = shinymanager::check_credentials(credentials),
  )

  output$res_auth <- renderPrint({
    reactiveValuesToList(auth)
  })

  observeEvent(session$input$logout,{
    session$reload()
  })
  
  init = data.frame(
    Longitude = numeric(4),
    Latitude = numeric(4)
  )
  
  dff <- data.frame(value = c(10, 30, 32, 28),
                   Classes = c("Class One", "Class Two", "Class Three", "Class Four"))
  
  crd_rv <- reactiveValues(df  = init)

  
  
  output$coordtab <- DT::renderDT({
    DT::datatable(crd_rv$df,rownames = F,editable = "cell",options = list(dom = 't'))%>%
      DT::formatStyle(c(1,2), `border` = "solid 1px")
  })
  
  
  proxy = DT::dataTableProxy("coordtab")
  
  # shiny::observe({
  #   DT::replaceData(proxy, crd_rv$df, resetPaging = FALSE, rownames = FALSE)
  # })
  
  
  observeEvent(input$coordtab_cell_edit, {
    info = input$coordtab_cell_edit
    
    str(info)
    i = info$row
    j = info$col + 1
    k = info$value
    
    
    crd_rv$df[i, j] <<- DT::coerceValue(k, crd_rv$df[i, j])
    DT::replaceData(proxy, crd_rv$df, resetPaging = FALSE)
  })
  
  
  output$loc <- shiny::renderText({
    "KAMPALA, UGANDA"
  })
  
  output$map <- leaflet::renderLeaflet({
    leaflet::leaflet() %>% 
      
      #leaflet::addTiles() %>% 
      leaflet::setView(lng = 32.3032414, lat = 1.3707295, zoom = 18)%>%
      leaflet::addProviderTiles(leaflet::providers$NASAGIBS.ModisTerraTrueColorCR,
                       options = leaflet::providerTileOptions(time = Sys.Date() - 1)) 
  })
  
  
  
  observeEvent(input$search,{
    
    df <- crd_rv$df %>% na.omit()
    
    crds = geosphere::centroid(df)
    
    if(nrow(df) > 1){
      leaflet::leafletProxy("map") %>%
        leaflet::clearMarkers()%>%
        leaflet::clearPopups()%>%
        leaflet::setView(lng = as.numeric(crds[1]), lat = as.numeric(crds[2]), zoom = 12)%>%
        leaflet::addMarkers(lng = crds[1], lat = crds[2])%>%
        leaflet::addPolygons(lng = df$Longitude, lat = df$Latitude)
    }
    
  })
  
   
  
  observeEvent(input$search2, {
    
    req(input$lng)
    req(input$lat)
    
    long = as.numeric(input$lng)
    lat = as.numeric(input$lat)
    
    leaflet::leafletProxy("map") %>%
      leaflet::clearMarkers()%>%
      leaflet::clearPopups()%>%
      leaflet::setView(lng = long, lat = lat, zoom = 10)%>%
      leaflet::addMarkers(lng = long, lat = lat)%>%
      leaflet.extras::addDrawToolbar(
        position = "topright",
        circleOptions = FALSE,
        rectangleOptions = FALSE,
      )
    
  })
  
  
    
  
  
  
  
  
  #------------------Analytics-------------------------
  output$progressBox <- shinydashboard::renderValueBox({
    shinydashboard::valueBox(
      paste0(25 , "%"), "Model Accuracy", icon = icon("list"),
      color = "green"
    )
  })
  
  output$approvalBox <- shinydashboard::renderValueBox({
    shinydashboard::valueBox(
      "1200 sq.ft.", "Area size", icon = icon("thumbs-up", lib = "glyphicon"),
      color = "yellow"
    )
  })
  
  output$modelBox <- shinydashboard::renderValueBox({
    shinydashboard::valueBox(
      "RF", "model", icon = icon("thumbs-up", lib = "glyphicon"),
      color = "aqua"
    )
  })
  
  output$plot2 <- renderPlot({
    shinipsum::random_ggplot()
  })
  
  
  output$plot <- shiny::renderPlot({
    data <- data.frame(
      category=c("water", "forest", "vegetation"),
      count=c(10, 60, 30)
    )
    
    # Compute percentages
    data$fraction <- data$count / sum(data$count)
    
    # Compute the cumulative percentages (top of each rectangle)
    data$ymax <- cumsum(data$fraction)
    
    # Compute the bottom of each rectangle
    data$ymin <- c(0, head(data$ymax, n=-1))
    
    # Compute label position
    data$labelPosition <- (data$ymax + data$ymin) / 2
    
    # Compute a good label
    data$label <- paste0(data$category, "\n value: ", data$count)
    
    # Make the plot
    #dev.new(width=5, height=4)
    ggplot2::ggplot(data, ggplot2::aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=category)) +
      ggplot2::geom_rect() +
      ggplot2::geom_text( x=2, ggplot2::aes(y=labelPosition, label=label, color=category), size=6) + # x here controls label position (inner / outer)
      ggplot2::scale_fill_brewer(palette=3) +
      ggplot2::scale_color_brewer(palette=3) +
      ggplot2::coord_polar(theta="y") +
      ggplot2::xlim(c(-1, 4)) +
      ggplot2::theme_void() +
      ggplot2::theme(legend.position = "none")
      #ggplot2::theme(plot.margin = ggplot2::unit(c(1,1,1,1),"cm"))
  })
  
  observeEvent(input$report, {
    modal_dialog()
  })
  
  shiny::observeEvent(input$dismiss_modal, {
    shiny::removeModal()
  })
  
  shiny::observeEvent(input$final_edit, {
    
    
    shiny::removeModal()
    
    
  })
  
  # shiny::observeEvent(input$classify, {
  #   
  #   output$infocad <- shiny::renderUI({
  #     my_infocard() %>%shiny::tagList()
  #   })
  # })
  
  output$timeplot = highcharter::renderHighchart({
    highcharter::highchart() %>%
      highcharter::hc_plotOptions(series = list(stacking = 'normal')) %>%
      highcharter::hc_yAxis_multiples(
        list(min = 0, max = 20),
        list(min = 0, max = 16, opposite = TRUE)
      ) %>% 
      highcharter::hc_add_series(data = c(1, 2, 3, 4, 5, 6), type = 'area') %>% 
      highcharter::hc_add_series(data = c(10, 12, 10, 13, 10, 11), type = 'area') %>% 
      highcharter::hc_add_series(data = c(1, 3, 2, 3, 5, 3), type = 'area', yAxis = 1) %>% 
      highcharter::hc_add_series(data = c(2, 3, 2, 3, 2, 3), type = 'area', yAxis = 1)
    
  })
  
  output$donut <- shiny::renderPlot({
    hsize <- 10
    
    df <- dff %>% 
      dplyr::mutate(x = hsize)
    
    ggplot2::ggplot(df, ggplot2::aes(x = hsize, y = value, fill = Classes)) +
      ggplot2::geom_col() +
      ggplot2::coord_polar(theta = "y") +
      ggplot2::xlim(c(0.2, hsize + 0.5))
  })
  
  
  observeEvent(input$classify, {
    btn <- input$classify
    id <- paste0('txt', btn)
    insertUI(
      selector = '#infocad',
      ## wrap element in a div with id for ease of removal
      ui = tags$div(
        shiny::absolutePanel(id = "analytics", class = "panel panel-default", fixed = TRUE,
                             draggable = TRUE, top = 80, left = 250, right = "auto", bottom = "auto",
                             width = 600, height = 700,
                             style = "overflow-y: scroll;",
                             shiny::column(
                               width = 12,
                               tags$hr(),
                               tags$div(
                                 # picture
                                 tags$div(
                                   #style = "padding-top:5px;",
                                   fluidRow(
                                     column(
                                       1,
                                       shiny::span(shiny::icon("search"))
                                     ),
                                     column(
                                       11,
                                       shiny::textOutput("loc")
                                     )
                                   )
                                 ),
                                 tags$hr()
                                 ,
                                 tags$div(
                                   shiny::fluidRow(
                                     shinydashboard::valueBoxOutput("progressBox", width = 4),
                                     shinydashboard::valueBoxOutput("approvalBox", width = 4),
                                     shinydashboard::valueBoxOutput("modelBox", width = 4)
                                   )
                                 ),
                                 # main information
                                 tags$div(
                                   #class = "caption",
                                   hr(),
                                   shinydashboardPlus::box(
                                     width = 12,
                                     status = "success",
                                     # background = "gray",
                                     # collapsible = "TRUE",
                                     title = "LAND COVER CHANGE CLASSIFICATION RESULTS",
                                     
                                     shiny::plotOutput("donut")
                                     
                                   ),
                                   hr()
                                   
                                   #p(selected_actor)
                                 ),
                                 # link to wikipedia's page
                                 tags$div(
                                   br(),
                                   hr(),
                                   
                                   shinydashboardPlus::box(
                                     width = 12,
                                     status = "success",
                                     title = "MODEL PERFORMANCE OVER TIME",
                                     highcharter::highchartOutput("timeplot")
                                   )
                                 ),
                                 tags$div(
                                   hr(),
                                   shinyWidgets::actionBttn("report", 
                                                            "GENERATE REPORT", 
                                                            icon = icon("book"), 
                                                            style = "material-flat",
                                                            block = TRUE,
                                                            color = "success"),
                                   br()
                                 )
                               )
                             )
                             
                             ),
        id = id
      )
    )
    #inserted <<- c(id, inserted)
  })
  
}
