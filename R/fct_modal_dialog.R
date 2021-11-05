modal_dialog <- function() {
  
  shiny::modalDialog(
    title = "Edit Fields",
    div(
      class = "text-left",
      
      div(
        shinyWidgets::prettyRadioButtons(
          inputId = "use",
          label = "What is your primary use of land cover chnage data?", 
          choices = c("A technical geospatial specialist who builds models or performs analyses", 
                      "A technical statistical specialist who builds models or performs analyses", 
                      "An advisor or policy maker using the land cover change analysis, stats and insight to shape policy making and management",
                      "A decision maker who makes environmental, climate change and sustainability related decisions for government, NGOs, private sector",
                      "A researcher in biodiversity, technology, artificial intelligence, conservation, climate science, agriculture, energy, nature based services, carbon markets and economy",
                      "Other"),
          icon = icon("check"), 
          bigger = TRUE,
          status = "info",
          animation = "jelly"
        )
      ),
      div(
        shinyWidgets::prettyRadioButtons(
          inputId = "Id039",
          label = "Which industry domains(s) do you work with when using land cover chnage maps?", 
          choices = c("Aviation", 
                      "Agriculture", 
                      "Built Environment, Smart Cities and Architecture",
                      "Climate Action",
                      "Defense & Intelligence",
                      "Crises Mapping & Human Rights & Investigative Journalism",
                      "Government & Public Sector",
                      "Conservation",
                      "Energy & Utilities",
                      "Insurance & Finance",
                      "Environment, Energy, Forestry,Health",
                      "Marketing & Communications",
                      "Other"),
          icon = icon("check"), 
          bigger = TRUE,
          status = "info",
          animation = "jelly"
        )
      ),
      div(
        shinyWidgets::prettyRadioButtons(
          inputId = "industry",
          label = "Which industry domains(s) do you work with when using land cover chnage maps?", 
          choices = c("Aviation", 
                      "Agriculture", 
                      "Built Environment, Smart Cities and Architecture",
                      "Climate Action",
                      "Defense & Intelligence",
                      "Crises Mapping & Human Rights & Investigative Journalism",
                      "Government & Public Sector",
                      "Conservation",
                      "Energy & Utilities",
                      "Insurance & Finance",
                      "Environment, Energy, Forestry,Health",
                      "Marketing & Communications",
                      "Other"),
          icon = icon("check"), 
          bigger = TRUE,
          status = "info",
          animation = "jelly"
        )
      ),
      div(
        shiny::textAreaInput(
          "suggestion",
          "What features will you like to see incorporated in the web application?",
          placeholder = "suggestions and recommendations",
          width = "100%"
        )
      ),
      div(
        div(
          shinyWidgets::prettyRadioButtons(
            inputId = "fmts",
            label = "Choose:", 
            choices = c("pdf", "webpage", "tiff", "word document")
          )
        )
      )
    ),
    size = "l",
    easyClose = TRUE,
    footer = div(
      class = "pull-right container",
      shinyWidgets::actionBttn (
        inputId = "final_edit",
        label ="DOWNLOAD REPORT", 
        size = "xs",
        style = "material-flat",
        icon = shiny::icon("download"),
        color = "primary"),
      shinyWidgets::actionBttn (
        inputId = "dismiss_modal",
        label ="Close", 
        size = "xs",
        style = "material-flat",
        icon = shiny::icon("close"),
        color = "danger")
    )
  ) %>% shiny::showModal()
}