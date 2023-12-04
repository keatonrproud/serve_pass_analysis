#### # Packages ----
library(cowplot)
library(googlesheets4)
library(dplyr)
library(tidyverse)
library(ggplot2)
library(ggpubr)
library(png)
library(ragg)
library(reshape2)
library(RColorBrewer)
library(scales)
library(shiny)
library(statmod)

sessionInfo()-> info

packages_loaded <- info$loadedOnly

packages_loaded %>% 
  map_df(., ~sum(grepl(., pattern = "CRAN"))) %>% 
  gather(package, status) %>% 
  filter(status !=1)


# Retrieve Season Data ----

gs4_deauth()

## load your own serve pass data ##
raw <- read_sheet("https://docs.google.com/spreadsheets/d/1uTodPLPOsbYeQIX9xVCWUWi1T_XbTDKO8i57Y5ylwus/edit?usp=sharing")

# Process Data
raw <- as.data.frame(raw)
raw[raw == "NULL"] <- NA ## Convert "NULL" to NA
raw <- as.data.frame(lapply(raw, unlist))

# Update with Current Roster Info from Load Mgmt Sheet ----
## load your own roster ##
qmvb_roster <- read_sheet("https://docs.google.com/spreadsheets/d/1cYoXhlRev8H5EPltaSN7Bwzu9kNR3izzPeNssdGoUac/edit?usp=sharing")
qmvb_roster <- as.data.frame(lapply(qmvb_roster, unlist))
qmvb_roster$Number %>% as.character()


named_data <- left_join(raw,qmvb_roster,by = c("ServerNumber" = "Number")) %>%
  filter(!is.na(raw$ServeOutcome)) %>%
  rename(ServerName = Name,
         ServerPos1 = Position1,
         ServerPos2 = Position2)

named_data <- left_join(named_data, qmvb_roster, by = c("PasserNumber" = "Number")) %>%
  rename(PasserName = Name,
         PasserPos1 = Position1,
         PasserPos2 = Position2)

# Online PSP Values ----
## load your own psp values as needed
psp_values <- read_sheet("https://docs.google.com/spreadsheets/d/171x2P0960dpawXg1A08WCBcc0UnzpLE0HRkMsJGlGXM/edit?usp=sharing")
psp_values <- as.data.frame(lapply(psp_values, unlist))

DV_serve_code <- c("=","#","/","+","!","-","-")
DV_pass_code <- c("","=","/","-","!","+","#")
psp_values <-  data.frame(psp_values, DV_serve_code, DV_pass_code)


# Defining Codes and WRANGLE -----
wrangling <- named_data %>%
  mutate(Ace = ifelse(named_data$ServeOutcome == 0,1,0),
         Error = ifelse(named_data$ServeOutcome %in% c("L","N","S","l","n","s"),1,0),
         Long = ifelse(named_data$ServeOutcome == "L",1,0),
         Net = ifelse(named_data$ServeOutcome == "N",1,0),
         Side = ifelse(named_data$ServeOutcome == "S",1,0),
         LivePasser = ifelse(named_data$PasserNumber == "P",0,1),
         Match = ifelse(str_detect(named_data$PasserNumber,";"),1,0))

wrangling <- left_join(wrangling,         # Merge Data with PSP Values by Outcome
                       psp_values, 
                       by = c("ServeOutcome" = "pass_outcome"))

# Assign Errors Proper Info
wrangling$DV_serve_code[wrangling$Error == 1] <- "="     # Give all errors correct DV code
wrangling$serve_psp[wrangling$LivePasser == 1 & wrangling$Error == 1] <- 0   # Live errors 0% PSP
wrangling$pass_sideout[wrangling$LivePasser == 1 & wrangling$Error == 1] <- 1  # Live errors 100% SO 

# Find Live Errors During Games (between rows with ';' passers)
wrangling$DV_serve_code[str_detect(wrangling$PasserNumber[-1],";") &&
                          str_detect(wrangling$PasserNumber[+1],";") &&
                          wrangling$Error -- 1] <- "="


names_list <- lapply(qmvb_roster$Name[qmvb_roster$Name != "-"],list)
names_list <- flatten(names_list)
names_list <- as.data.frame(unlist(names_list)) %>% mutate(
  all_names = names_list
)

# Define UI for application -----
ui <- fluidPage(titlePanel("PSP Analysis"),
                sidebarLayout(
                  sidebarPanel(
                    textInput("Password","Password:", value='dataiscool'),
                    tags$hr(),
                    selectInput("SkillInput","Select Skill:", 
                                choices = c("Serving","")),
                    selectInput("BinSizeInput","Speed Ranges:",
                                choices = c("",3,5,8)),
                    uiOutput("names_list")
                    ),
                  mainPanel(
                    plotOutput("Plot1", height = 600)
                  )
                )
              )


# Define server logic required to draw a histogram
server <- function(input, output) observe({
    if(input$Password == "dataiscool") {
    output$names_list <- renderUI ({
    input_names <- names_list
    input_names <- c("",input_names)
    selectInput("names_list", "Player Name:",
                choices = as.list(input_names$`all_names`))
  })

## Setting Up Player 1 Plots ----
  output$Plot1 <- renderPlot ({
# Need to wait for Names Input
    shiny::validate(
      need(input$names_list != "", "Select a player."))
  
    
    ## Check to make sure data exists for athlete
    shiny::validate(
      need(length(wrangling$Velocity[wrangling$ServerName == input$names_list]) > 10,
           "Not enough data for this player."))
    
    plyr_to_analyse <- input$names_list
    
    
    ## Make sure there is a bin size value
    shiny::validate(
      need(input$BinSizeInput != "", "Select a range for speeds.")
    )
    
    # Velocity Binning -- create intervals of 5, offset by 2
    bins <- as.numeric(input$BinSizeInput)
    wrangling$velocityBins <- findInterval(wrangling$Velocity, c((1:(120/bins))*bins-(bins*.5)))*bins
    
    
    
    
    plyr_live_data <- filter(wrangling, 
                             grepl(plyr_to_analyse,ServerName,ignore.case = TRUE),
                             LivePasser == 1)
    
    
    
    ### Aggregate Based on Bins -----
    aggregated_psp <- aggregate(plyr_live_data$serve_psp, list(plyr_live_data$velocityBins), mean, na.rm = TRUE)
    aggregated_count <- aggregate(plyr_live_data$serve_psp, list(plyr_live_data$velocityBins), length)
    aggregated_aces <- aggregate(plyr_live_data$Ace, list(plyr_live_data$velocityBins), mean, na.rm = TRUE)
    aggregated_errors <- aggregate(plyr_live_data$Error, list(plyr_live_data$velocityBins), mean, na.rm = TRUE)
    
    
    binned_summary <- left_join(aggregated_psp,aggregated_count, by = "Group.1") %>%
      left_join(., aggregated_aces, by = "Group.1") %>%
      left_join(., aggregated_errors, by = "Group.1")
    names(binned_summary) <- c("velocityBins","PSP","Attempts","Aces","Errors")
    
    # Remove Rows of Velocity Bins with < 1% of total serves
    binned_summary <- binned_summary[binned_summary$Attempts > round(.01*sum(binned_summary$Attempts))+1,]
    
    
    ### Prepping Data for Plotting  -----
    binned_summary_long <- reshape2::melt(binned_summary,                  # Melt data to get all variables on chart
                                id.vars = "velocityBins",
                                value.name = "value",
                                variable.name = "stats")
    
    binned_summary_long$stats <- factor(binned_summary_long$stats, levels = c("PSP", "Attempts", "Errors", "Aces"))
    
  
      PSP_plot <- ggplot(binned_summary_long[binned_summary_long$stats != "Attempts",],
                         aes(x = velocityBins, y = value, colour = stats, alpha = stats)) +
      scale_color_manual(values = c("#619CFF", "#c31609", "#00BA38"))+
      ggtitle(paste0("Serving - ", plyr_to_analyse),
              subtitle = paste0('This includes ', nrow(plyr_live_data), ' serves against live passers...',"\n",
                                'PSP: ', scales::label_percent(1)(mean(plyr_live_data$serve_psp)),"     ",
                                'Aces: ', scales::label_percent(1)(mean(plyr_live_data$Ace)), paste0(" [", sum(plyr_live_data$Ace),"]"), "   ",
                                'Errors: ', scales::label_percent(1)(mean(plyr_live_data$Error)), paste0(" [", sum(plyr_live_data$Error),"]")))+
      geom_segment(linetype = "dashed", 
                   colour = "darkgrey",
                   aes(x = min(velocityBins), xend = max(velocityBins), y = .4, yend = .4),
                   show.legend = FALSE)+
      theme_bw()+
      theme(plot.title = element_text(size = 18, face = "bold"),
            plot.subtitle = element_text(size = 12, face = "bold"),
            axis.text.x = element_text(size = 9),
            axis.title.y = element_blank(),
            axis.title.x = element_blank(),
            legend.title = element_blank(),
            legend.background = element_rect(fill = NA,
                                             size = 0),
            legend.position = c(.8, 1.05),
            legend.key = element_blank(),
            legend.key.size = unit(1, "cm"),
            legend.direction = "horizontal",
            legend.text = element_text(margin = margin(r = 8, unit = "pt"), 
                                       size = 15,
                                       face = "bold"),
            axis.line = element_line(colour = "black"),
            panel.border = element_blank(),
            panel.grid.minor = element_blank()) +
      geom_line(aes(colour = stats),
                linewidth = 1.5)+ 
      geom_area(data = binned_summary_long[binned_summary_long$stats == "PSP",],
                fill = "#619CFF",
                alpha = .15) +
      geom_label(data = binned_summary_long[binned_summary_long$stats == "PSP",],
                 aes(label = scales::label_percent(accuracy = 1L)(value)),
                 nudge_y = .03,
                 size = 7,
                 show.legend = FALSE) +
      scale_alpha_manual(values = c(1,0.3,0.3))+
      coord_cartesian(ylim=c(0,.6))+
      scale_y_continuous(labels = scales::percent_format(accuracy = 1),
                         expand = expansion(mult = .001))+           
      scale_x_continuous(labels = as.character(binned_summary_long$velocityBins), 
                         breaks = binned_summary_long$velocityBins,
                         expand = expansion(mult = .035))+             
      guides(color=guide_legend(override.aes=list(fill=NA)))
    
    # scales::hue_pal()(3) ## Determine Colours Being Used
    
    
    attempts_plot <- ggplot(binned_summary,
                            aes(x = velocityBins, y = Attempts)) +
      scale_color_brewer(palette = "Set1")+
      labs(caption = paste0("Against live passers only. Velocity ranges (+/- ",
                            trunc(bins/2),
                            "km/h) under 1% of attempts are excluded."))+
      theme_bw()+
      theme(panel.grid.minor = element_blank(),
            panel.grid.major = element_blank(),
            axis.line = element_line(colour = "black"),
            panel.border = element_blank(),
            axis.text.x = element_text(size = 9),
            plot.caption = element_text(size = 10),
            axis.title.y = element_text(size = 11))+
      scale_fill_manual(values = c("lightgreen"))+
      geom_line()+
      geom_area(colour = "lightgray", 
                alpha = 0.05)+
      scale_x_continuous("Velocity (km/h)", 
                         labels = as.character(binned_summary_long$velocityBins),
                         breaks = binned_summary_long$velocityBins,
                         expand = expansion(mult = .03))+
      scale_y_continuous(expand = expansion(mult = .001))
    
    ### Combine Plots for Processing -----
    ggarrange(PSP_plot, attempts_plot, heights = c(4, 1.25),
              ncol = 1, nrow = 2)
  })
    }
  else {}
})


# Run the application LAST LINE OF CODE!! 
shinyApp(ui = ui, server = server)
