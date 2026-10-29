library(shiny)
library(plotly)
library(ggplot2)
library(gganimate)
pkgload::load_all(export_all = FALSE, helpers = FALSE, quiet = TRUE)

ui <- fluidPage(
  titlePanel('dataBiosphere: Auditable Cinematic Engine (SaaS)'),
  sidebarLayout(
    sidebarPanel(
      h4('1. Upload Data Source'),
      fileInput('pdf_file', 'Upload Article (PDF)', accept = '.pdf'),
      fileInput('csv_file', 'Or Upload Dataset (CSV: time, value)', accept = '.csv'),
      hr(),
      h4('2. Finding Metadata (Editable)'),
      numericInput('effect_value', 'Effect Size (HR/OR):', value = 0.72, step = 0.01),
      numericInput('ci_lower', '95% CI Lower:', value = 0.61, step = 0.01),
      numericInput('ci_upper', '95% CI Upper:', value = 0.85, step = 0.01),
      numericInput('n', 'Sample Size (n):', value = 1200, step = 100),
      selectInput('signal_id', 'Select Metaphor Signal:', choices = sprintf('S%d', 1:12)),
      checkboxInput('contains_mortality', 'Contains Mortality / Trauma?', value = TRUE),
      hr(),
      actionButton('render_btn', 'Generate Outputs', class = 'btn-primary')
    ),
    mainPanel(
      tabsetPanel(
        tabPanel('T2: Interactive', plotlyOutput('interactive_plot', height = '400px')),
        tabPanel('T1: Auditable Video', 
                 h4('Deterministic Video'),
                 actionButton('video_btn', 'Render & Save MP4'),
                 br(), br(),
                 textOutput('video_status')
        ),
        tabPanel('T3: AI Hybrid',
                 h4('Hybrid Render Pipeline'),
                 p('1. Copy this prompt for Sora/Runway:'),
                 verbatimTextOutput('ai_prompt'),
                 p('2. Upload the AI video (.mp4) to merge:'),
                 fileInput('ai_video_file', 'Upload AI Video (MP4)', accept = '.mp4'),
                 actionButton('merge_btn', 'Merge Videos (FFmpeg)'),
                 br(), br(),
                 textOutput('merge_status')
        )
      )
    )
  )
)

server <- function(input, output, session) {
  
  # PDF yüklendiğinde verileri otomatik doldur
  observeEvent(input$pdf_file, {
    req(input$pdf_file)
    extracted <- extractArticleData(input$pdf_file$datapath)
    
    updateNumericInput(session, 'effect_value', value = extracted$effect_value)
    updateNumericInput(session, 'ci_lower', value = extracted$ci_lower)
    updateNumericInput(session, 'ci_upper', value = extracted$ci_upper)
    updateNumericInput(session, 'n', value = extracted$n)
  })

  user_data <- reactive({
    if (is.null(input$csv_file)) {
      return(data.frame(time = 1:20, value = 100 * exp(-0.1 * (1:20))))
    }
    df <- read.csv(input$csv_file$datapath)
    colnames(df)[1:2] <- c('time', 'value')
    return(df)
  })
  
  overlay_args <- reactive({
    list(
      effect_type = 'HR', effect_value = input$effect_value,
      ci_lower = input$ci_lower, ci_upper = input$ci_upper,
      n = input$n, finding_label = 'Uploaded Study Data',
      risk_tier = ifelse(input$contains_mortality, 1, 3),
      contains_mortality = input$contains_mortality
    )
  })

  output$interactive_plot <- renderPlotly({
    req(input$render_btn)
    renderInteractiveMetaphor(user_data(), 'time', 'value', input$signal_id, overlay_args())
  })
  
  output$ai_prompt <- renderText({
    generateAIPrompt(input$signal_id, 'Uploaded Study Data')
  })

  status_text <- reactiveVal('Ready')
  output$video_status <- renderText({ status_text() })

  observeEvent(input$video_btn, {
    status_text('Rendering video...')
    renderAuditableVideo(user_data(), 'time', 'value', input$signal_id, overlay_args(), 'saas_output.mp4', transparent_bg = TRUE)
    status_text('Video saved as saas_output.mp4!')
  })

  merge_text <- reactiveVal('')
  output$merge_status <- renderText({ merge_text() })
  
  observeEvent(input$merge_btn, {
    req(input$ai_video_file)
    merge_text('Merging videos... Please wait.')
    mergeHybridVideo(r_video = 'saas_output.mp4', ai_video = input$ai_video_file$datapath, output_file = 'final_hybrid.mp4')
    merge_text('Merge complete! Saved as final_hybrid.mp4')
  })
}

shinyApp(ui = ui, server = server)
