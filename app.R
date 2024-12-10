library(shiny)
library(dplyr)
library(ggplot2)
library(readr)
library(DT)  # Para tablas interactivas

# Cargar datos
ventas <- read_csv("data/datos_ventas.csv")
ventas$fecha <- as.Date(ventas$fecha)
ventas$ingreso <- ventas$cantidad * ventas$precio

# Depuración: Imprimir los primeros registros
print(head(ventas))

# UI
ui <- fluidPage(
  titlePanel("Dashboard de Ventas"),
  sidebarLayout(
    sidebarPanel(
      selectInput("categoria", "Seleccionar Categoría:", choices = c("Todas", unique(ventas$categoria))),
      dateRangeInput("fechas", "Rango de Fechas:", start = min(ventas$fecha), end = max(ventas$fecha)),
      sliderInput("precio_min", "Precio Mínimo:", min = min(ventas$precio), max = max(ventas$precio), value = min(ventas$precio)),
      sliderInput("precio_max", "Precio Máximo:", min = min(ventas$precio), max = max(ventas$precio), value = max(ventas$precio)),
      downloadButton("descargar_datos", "Descargar Datos")
    ),
    mainPanel(
      fluidRow(
        column(4, uiOutput("total_ingresos")),
        column(4, uiOutput("productos_vendidos")),
        column(4, uiOutput("categoria_top"))
      ),
      fluidRow(
        column(12, plotOutput("grafico_categorias", height = "300px")),
        column(12, plotOutput("grafico_tiempo", height = "300px")),
        column(12, DTOutput("tabla_ventas"))
      )
    )
  ),
  tags$head(
    tags$style(HTML("
      body {
        background-color: #f8f9fa;
      }
      .main-panel {
        background-color: #ffffff;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
      }
      .sidebar-panel {
        background-color: #343a40;
        color: #ffffff;
        padding: 20px;
        border-radius: 10px;
      }
      .sidebar-panel input, .sidebar-panel select {
        background-color: #495057;
        color: #ffffff;
        border: 1px solid #ced4da;
      }
      .sidebar-panel .btn {
        background-color: #007bff;
        border-color: #007bff;
      }
    "))
  )
)

# Server
server <- function(input, output, session) {
  
  # Filtrar datos por categoría, rango de fechas y precio
  ventas_filtradas <- reactive({
    ventas %>%
      filter(
        (categoria == input$categoria | input$categoria == "Todas"),
        fecha >= input$fechas[1],
        fecha <= input$fechas[2],
        precio >= input$precio_min,
        precio <= input$precio_max
      )
  })
  
  # Total de ingresos
  output$total_ingresos <- renderUI({
    total_ingresos <- sum(ventas_filtradas()$ingreso)
    HTML(paste0(
      '<div class="alert alert-success text-center" role="alert">',
      '<h3>Ingresos Totales</h3>',
      '<p>$', format(total_ingresos, big.mark = ","), '</p>',
      '</div>'
    ))
  })
  
  # Total de productos vendidos
  output$productos_vendidos <- renderUI({
    total_productos <- sum(ventas_filtradas()$cantidad)
    HTML(paste0(
      '<div class="alert alert-primary text-center" role="alert">',
      '<h3>Productos Vendidos</h3>',
      '<p>', format(total_productos, big.mark = ","), '</p>',
      '</div>'
    ))
  })
  
  # Categoría top
  output$categoria_top <- renderUI({
    categoria_top <- ventas_filtradas() %>%
      group_by(categoria) %>%
      summarise(total_ingresos = sum(ingreso)) %>%
      arrange(desc(total_ingresos)) %>%
      slice(1) %>%
      pull(categoria)
    
    HTML(paste0(
      '<div class="alert alert-info text-center" role="alert">',
      '<h3>Categoría Top</h3>',
      '<p>', categoria_top, '</p>',
      '</div>'
    ))
  })
  
  # Gráfico de ingresos por categoría
  output$grafico_categorias <- renderPlot({
    ventas_filtradas() %>%
      group_by(categoria) %>%
      summarise(total_ingresos = sum(ingreso)) %>%
      ggplot(aes(x = categoria, y = total_ingresos, fill = categoria)) +
      geom_bar(stat = "identity") +
      theme_minimal() +
      labs(title = "Ingresos por Categoría", x = "Categoría", y = "Ingresos")
  })
  
  # Gráfico de líneas de ventas a lo largo del tiempo
  output$grafico_tiempo <- renderPlot({
    ventas_filtradas() %>%
      group_by(fecha) %>%
      summarise(total_ingresos = sum(ingreso)) %>%
      ggplot(aes(x = fecha, y = total_ingresos)) +
      geom_line() +
      theme_minimal() +
      labs(title = "Ventas a lo Largo del Tiempo", x = "Fecha", y = "Ingresos")
  })
  
  # Tabla de ventas
  output$tabla_ventas <- renderDT({
    datatable(ventas_filtradas(), options = list(pageLength = 10))
  })
  
  # Descargar datos
  output$descargar_datos <- downloadHandler(
    filename = function() {
      paste("ventas_filtradas", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write_csv(ventas_filtradas(), file)
    }
  )
}

# Ejecutar la aplicación
shinyApp(ui, server)