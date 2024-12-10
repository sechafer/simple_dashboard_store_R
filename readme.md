 # Overview

As a software engineer, I developed a web-based dashboard application to solve a real business challenge in data visualization. The project focuses on making sales data accessible and understandable without requiring additional licenses for tools like Power BI.

This application leverages R and Shiny to create an interactive dashboard that processes CSV reports and transforms them into meaningful visualizations. The software demonstrates modern R capabilities in both frontend and backend development, showcasing skills in file processing, data manipulation, and dynamic visualization creation.

The purpose of this software is to provide sales teams with an efficient way to analyze sales performance metrics. It processes CSV files containing sales data and generates interactive charts and metrics for key performance indicators such as total revenue, products sold, and top-performing categories.

Try it out here: [Live Demo](#)

[Software Demo Video](#)

# Development Environment

The development environment consists of several modern web development tools and technologies:

**Tools Used:**
- RStudio for development
- Git for version control
- R (^4.0.0) runtime environment
- CRAN (Comprehensive R Archive Network) for dependency management

**Programming Language and Libraries:**
- R as the primary programming language
- Backend Libraries:
  - Shiny (^1.7.1) for server implementation
  - dplyr (^1.0.7) for data manipulation
  - ggplot2 (^3.3.5) for data visualization
  - readr (^2.0.2) for CSV file processing
- Frontend Libraries:
  - Shinydashboard for UI components
  - DT for interactive tables

# Useful Websites

- [Shiny Documentation](https://shiny.rstudio.com/)
- [dplyr Documentation](https://dplyr.tidyverse.org/)
- [ggplot2 Documentation](https://ggplot2.tidyverse.org/)
- [readr Documentation](https://readr.tidyverse.org/)
- [Shinydashboard Documentation](https://rstudio.github.io/shinydashboard/)
- [DT Documentation](https://rstudio.github.io/DT/)

# Future Work

- Implement data caching mechanism to improve performance with large datasets
- Add export functionality to save dashboard configurations
- Create custom templates for different types of sales reports
- Add user authentication system for secure file uploads
- Implement real-time data updates through WebSocket integration
- Add more advanced filtering and sorting options for the visualizations