# section 1.3 - define custom analytics card ----

my_infocard <- function() {
  
  # selected_character == value from user pickerInput
  # e.g. "Mike Wheeler"

  # piece of UI to render dynamically
  column(
    width = 4,
    div(
      # picture
      shiny::span(shiny::icon("search")),
      shiny::textInput("loc",label = "",placeholder = "Uganda"),

      div(
        shiny::fluidRow(
          shiny::column(6,
                        shinydashboard::valueBoxOutput("progressBox"))
          ,
          shiny::column(6,
                        shinydashboard::valueBoxOutput("approvalBox"))
          
        )
      ),
      # main information
      div(
        #class = "caption",
        h4("CLASSIFICATION RESULTS"),
        p(selected_actor)
      ),
      # link to wikipedia's page
      div(
        p("plot goes here")
      ),
      # remove button
      div(
        p("time plot goes here7")
      )
    )
  )
}
