library(shiny)
library(BiocManager)
library(seqinr)
library(shinydashboard)
library(plotly)
library(shinyWidgets)
library(shinyjs)
library(googleVis)
library(xtable)
library(DT)
library(htmltools)
library(phangorn)
library(bios2mds)
library(zip)
library(ape)
library(zCompositions)
library(compositions)
library(stringr)
library(rpart)
library(rpart.plot)
library(caret)
library(ggplot2)
library(randomForest)
library(data.table)
library(SHAPforxgboost)
library(fontawesome)
library(grid)
library(ggplotify)
library(phyloseq)
library(biomformat)
library(dashboardthemes)
library(edarf)
library(chatgpt)
library(xgboost)
library(tidyverse)

# COMMENTS ------
{
  TITLE = p("MiTree: A Unified Web Cloud Analytic Platform for User-Friendly and Interpretable Microbiome Data Mining Using Tree-Based Methods", style = "font-size:18pt")
  HOME_COMMENT = p(strong("MiTree:", style = "font-size:15pt"), "A unified web cloud analytic platform for user-friendly and interpretable microbiome data mining.
                   MiTree employs tree-based learning methods, decision tree, random forest and gradient boosting, that are both well understood and suited to human microbiome studies.
                   We suggest that the random forest or gradient boosting to be used as a main analytic method because of their high prediction accuracy, while the decision tree to be used just for reference.
                   MiTree handles both classification and regression problems through covariate-adjusted or unadjusted analysis. The results from MiTree are also easy to understand and interpret with nice visualizations for important disease predictors and their delicate relationship patterns to the host's health or disease status.
                   It is also engaging that MiTree employs ChatGPT, a popular and well-trained AI language model, as a plug-in to help users easily search for the microbial taxa that are found as important disease predictors.
                   MiTree will provide new insights into microbiome-based diagnostics, treatment and prevention.", style = "font-size:13pt")
  HOME_COMMENT2 = p(strong("URLs:"), "Web server (online implementation):", tags$a(href = "http://mitree.micloud.kr", "http://mitree.micloud.kr"), 
                    "; GitHub repository (local implementation):", 
                    tags$a(href = "https://github.com/jkim209/MiTreeGit", "https://github.com/jkim209/MiTreeGit"), style = "font-size:13pt")
  HOME_COMMENT3 = p(strong("Maintainers:"), "Ji Hun Kim (", tags$a(href = "jihun.kim.3@stonybrook.edu", "jihun.kim.3@stonybrook.edu"), ")", style = "font-size:13pt")
  HOME_COMMENT4 = p(strong("Reference:"), "Kim J, Koh H. MiTree: A unified web cloud analytic platform for user-friendly and interpretable microbiome data mining using tree-based methods (in review)", style = "font-size:13pt")
  
  INPUT_PHYLOSEQ_COMMENT1 = p("Description:", br(), br(), "This should be an '.Rdata' or '.rds' file, and the data should be in 'phyloseq' format (see ", 
                              htmltools::a(tags$u("https://bioconductor.org/packages/release/bioc/html/phyloseq.html"), style = "color:red3"),
                              "). The phyloseq object should contain three necessary data, feature (OTU or ASV) table, taxonomic table and meta/sample information.",br(), br(),
                              "Details:", br(), br(), 
                              strong("Feature table:"), "It should contain counts, where rows are features (OTUs or ASVs) and columns are units (row names are feature IDs and column names are unit IDs).", br(), br(),
                              strong("Taxonomic table:"),"It should contain taxonomic names, where rows are features and columns are seven taxonomic ranks (row names are feature IDs and column names are 'Kingdom', 'Phylum', 'Class', 'Order', 'Family', 'Genus', 'Species' or 'Domain', 'Phylum', 'Class', 'Order', 'Family', 'Genus', 'Species').", br(), br(),
                              strong("Metadata/Sample information:"),"It should contain variables for the units about host phenotypes, medical interventions, disease status or environmental/behavioral factors, where rows are units and columns are variables (row names are unit IDs, and column names are variable names).", br(), br(),
                              "* The features should be matched and identical across feature table and taxonomic table. The units should be matched and identical between feature table and metadata/sample information.
                              MiTree will analyze only the matched features and units.", style = "font-size:11pt")
  INPUT_PHYLOSEQ_COMMENT2 = p("You can download example microbiome data 'sub.1.con.biom.Rdata' in 'phyloseq' format. For more details about 'phyloseq', see ", 
                              htmltools::a(tags$u("https://bioconductor.org/packages/release/bioc/html/phyloseq.html"), style = "color:red3"), br(), br(), 
                              "> setwd('/yourdatadirectory/')", br(), br(), 
                              "> load(file = 'sub.1.con.biom.Rdata')", br(), br(), 
                              "> library(phyloseq)", br(), br(), 
                              " > otu.tab <- otu_table(sub.1.con.biom)", br(), 
                              " > tax.tab <- tax_table(sub.1.con.biom)", br(), 
                              " > sam.dat <- sample_data(sub.1.con.biom)", br(), br(), 
                              "You can check if the features are matched and identical across feature table and taxonomic table, and the units are matched and identical between feature table and metadata/sample information using following code.", br(), br(), 
                              " > identical(rownames(otu.tab), rownames(tax.tab))", br(), 
                              " > identical(colnames(otu.tab), rownames(sam.dat))", style = "font-size:11pt", br(), br(),
                              strong("Reference:"), "Park B, Koh H, Patatanian M, Reyes-Caballero H, Zhao N, Meinert J, et al. The mediating roles of the oral microbiome in saliva and subgingival sites between e-cigarette smoking and gingival inflammation. BMC Microbiology. 2023;23(35):1-18.")
  INPUT_INDIVIDUAL_DATA_COMMENT = p("Description:", br(), br(), 
                                    strong("Feature table:"), "It should contain counts, where rows are features (OTUs or ASVs) and columns are units (row names are feature IDs and column names are unit IDs).", br(), br(),
                                    strong("Taxonomic table:"),"It should contain taxonomic names, where rows are features and columns are seven taxonomic ranks (row names are feature IDs and column names are 'Kingdom', 'Phylum', 'Class', 'Order', 'Family', 'Genus', 'Species' or 'Domain', 'Phylum', 'Class', 'Order', 'Family', 'Genus', 'Species').", br(), br(),
                                    strong("Metadata/Sample information:"),"It should contain variables for the units about host phenotypes, medical interventions, disease status or environmental/behavioral factors, where rows are units and columns are variables (row names are unit IDs, and column names are variable names).", br(), br(),
                                    "* The features should be matched and identical across feature table and taxonomic table. The units should be matched and identical between feature table and metadata/sample information.
                                    MiTree will analyze only the matched features and units.", style = "font-size:11pt")
  INPUT_INDIVIDUAL_DATA_COMMENT2 = p("You can download example microbiome data 'Oral.zip'. This zip file contains three necessary data components, feature table (otu.tab.txt), taxonomic table (tax.tab.txt), and metadata/sample information (sam.dat.txt).", br(), br(),
                                     "> setwd('/yourdatadirectory/')", br(), br(), 
                                     "> otu.tab <- read.table(file = 'sub.1.con.biom.otu.tab.txt', check.names = FALSE)", br(), 
                                     "> tax.tab <- read.table(file = 'sub.1.con.biom.tax.tab.txt', check.names = FALSE)", br(), 
                                     "> sam.dat <- read.table(file = 'sub.1.con.biom.sam.dat.txt', check.names = FALSE)", br(), br(),
                                     "You can check if the features are matched and identical across feature table and taxonomic table, 
                                     and the units are matched and identical between feature table and metadata/sample information using following code.", br(), br(), 
                                     " > identical(rownames(otu.tab), rownames(tax.tab))", br(), 
                                     " > identical(colnames(otu.tab), rownames(sam.dat))", style = "font-size:11pt", br(), br(),
                                     strong("Reference:"), "Park B, Koh H, Patatanian M, Reyes-Caballero H, Zhao N, Meinert J, et al. The mediating roles of the oral microbiome in saliva and subgingival sites between e-cigarette smoking and gingival inflammation. BMC Microbiology. 2023;23(35):1-18.")
  
  QC_KINGDOM_COMMENT = p("A microbial kingdom to be analyzed. Default is 'Bacteria' for 16S data. Alternatively, you can type 'Fungi' for ITS data 
                         or any other kingdom of interest for shotgun metagenomic data.", style = "font-size:11pt")
  QC_LIBRARY_SIZE_COMMENT1 = p("Remove units that have low library sizes (total read counts). Default is 3,000.", style = "font-size:11pt")
  QC_LIBRARY_SIZE_COMMENT2 = p("Library size: The total read count per unit.", style = "font-size:11pt")
  QC_MEAN_PROP_COMMENT1 = p("Remove features (OTUs or ASVs) that have low mean relative abundances (Unit: %). Default is 0.002%.",style = "font-size:11pt")
  QC_MEAN_PROP_COMMENT2 = p("Mean proportion: The average of relative abundances (i.e., proportions) per feature.", style = "font-size:11pt")
  QC_TAXA_NAME_COMMENT1 = p("Remove taxonomic names in the taxonomic table that are completely matched with the specified character strings. 
                            Multiple character strings should be separated by a comma. Default is \"\", \"metagenome\", \"gut metagenome\", \"mouse gut metagenome\".",
                            style = "font-size:11pt")
  QC_TAXA_NAME_COMMENT2 = p("Remove taxonomic names in the taxonomic table that are partially matched with the specified character strings (i.e., taxonomic names that contain 
                            the specified character strings). Multiple character strings should be separated by a comma. Default is \"uncultured\", \"incertae\", \"Incertae\",
                            \"unidentified\", \"unclassified\", \"unknown\".",style = "font-size:11pt")

  DATA_TRANSFORM_COMMENT = p("Transform the data into four different formats (1) CLR (centered log ratio) (Aitchison, 1982), (2) Count (Rarefied) (Sanders, 1968), (3) Proportion, (4) Arcsine-root 
                             for each taxonomic rank (phylum, class, order, familiy, genus, species).")
  DATA_TRANSFORM_REFERENCE = p("1. Aitchison J. The statistical analysis of compositional data. J R Stat Soc B. 1982;44(2):139-77", br(),
                               "2. Sanders HL. Marine benthic diversity: A comparative study. Am Nat. 1968;102:243-282.")
  
  DT_REFERENCE = p("1. Breiman L, Friedman JH, Olshen RA, Stone CJ. Classification and Regression Trees. CRC Press. 1984.", br())
  DT_REFERENCE_CLR = p("1. Breiman L, Friedman JH, Olshen RA, Stone CJ. Classification and Regression Trees. CRC Press. 1984.", br(),
                       "2. Aitchison J. The statistical analysis of compositional data. J R Stat Soc B. 1982;44(2):139-77")
  DT_REFERENCE_RC = p("1. Breiman L, Friedman JH, Olshen RA, Stone CJ. Classification and Regression Trees. CRC Press. 1984.", br(),
                      "2. Sanders HL. Marine benthic diversity: A comparative study. Am Nat. 1968;102:243-282.")
  RF_REFERENCE = p("1. Breiman L. Random forests. Mach Learn. 2001;45:5-32", br())
  RF_REFERENCE_CLR = p("1. Breiman L. Random forests. Mach Learn. 2001;45:5-32", br(),
                       "2. Aitchison J. The statistical analysis of compositional data. J R Stat Soc B. 1982;44(2):139-77")
  RF_REFERENCE_RC = p("1. Breiman L. Random forests. Mach Learn. 2001;45:5-32", br(),
                      "2. Sanders HL. Marine benthic diversity: A comparative study. Am Nat. 1968;102:243-282.")
  XGB_REFERENCE = p("1. Friedman JH. Greedy function approximation: A gradient boosting machine. Ann Stat. 2001;29(5):1189-1232",br(),
                    "2. Chen T, Guestrin C. XGBoost: A scalable tree boosting system. in Proc the 22nd ACM SIGKDD Int Conf KDD. ACM. 2016;785-794", br(),
                    "3. Lundberg SM, Lee SI. A unified approach to interpreting model predictions. in Proc Adv Neural Inf Process Syst. 2017;4765-4774.")
  XGB_REFERENCE_CLR = p("1. Friedman JH. Greedy function approximation: A gradient boosting machine. Ann Stat. 2001;29(5):1189-1232",br(),
                        "2. Chen T, Guestrin C. XGBoost: A scalable tree boosting system. in Proc the 22nd ACM SIGKDD Int Conf KDD. ACM. 2016;785-794", br(),
                        "3. Lundberg SM, Lee SI. A unified approach to interpreting model predictions. in Proc Adv Neural Inf Process Syst. 2017;4765-4774.",br(),
                        "4. Aitchison J. The statistical analysis of compositional data. J R Stat Soc B. 1982;44(2):139-77")
  XGB_REFERENCE_RC = p("1. Friedman JH. Greedy function approximation: A gradient boosting machine. Ann Stat. 2001;29(5):1189-1232",br(),
                       "2. Chen T, Guestrin C. XGBoost: A scalable tree boosting system. in Proc the 22nd ACM SIGKDD Int Conf KDD. ACM. 2016;785-794", br(),
                       "3. Lundberg SM, Lee SI. A unified approach to interpreting model predictions. in Proc Adv Neural Inf Process Syst. 2017;4765-4774.",br(),
                       "4. Sanders HL. Marine benthic diversity: A comparative study. Am Nat. 1968;102:243-282.")
}

# UI ---------------------------------------------------------------------------
{
  ui = dashboardPage(
    title = "MiTree",
    dashboardHeader(title = span(TITLE, style = "float:left;font-size: 20px"), titleWidth = "100%"),
    dashboardSidebar(
      tags$script(JS("document.getElementsByClassName('sidebar-toggle')[0].style.visibility = 'hidden';")),
      sidebarMenu(id = "side_menu",
                  menuItem("Home", tabName = "home"),
                  menuItem("Data Processing",
                           menuSubItem("Data Input", tabName = "step1", icon = fontawesome::fa("upload", margin_left = "0.3em", margin_right = "0.1em")),
                           menuSubItem("Quality Control", tabName = "step2", icon = fontawesome::fa("chart-bar", margin_left = "0.3em")),
                           menuSubItem("Data Transformation", tabName = "dataTransform", icon = fontawesome::fa("calculator", margin_left = "0.3em", margin_right = "0.25em"))),
                  menuItem("Data Mining",
                           menuSubItem("Decision Tree", tabName = "dt", icon = fontawesome::fa("tree", margin_left = "0.2em", margin_right = "0.1em")),
                           menuSubItem("Random Forest", tabName = "rf", icon = fontawesome::fa("network-wired")),
                           menuSubItem("Gradient Boosting", tabName = "xgb", icon = fontawesome::fa("diagram-project"))))),
    dashboardBody(
      customTheme,
      tags$head(tags$style(HTML(".content { padding-top: 2px;}"))),
      tags$script(src = "fileInput_text.js"),
      tags$head(tags$style(HTML('.progress-bar {background-color: rgb(2,144,255);}'))),
      # setSliderColor(rep("#0290ff", 100), seq(1, 100)),
      useShinyjs(),
      tabItems(
        
        ## Home -----
        tabItem(tabName = "home",
                div(id = "homepage", br(), HOME_COMMENT, 
                    p(" ", style = "margin-bottom: 10px;"),
                    div(tags$img(src="MiTree_Home_Img2.png", height = 630, width = 750), style = "text-align: center;"), br(),
                    HOME_COMMENT2, HOME_COMMENT3, HOME_COMMENT4)),
        
        ## DATA INPUT -----
        tabItem(tabName = "step1", br(),
                fluidRow(
                  column(width = 6,
                         box(
                           width = NULL, status = "info", solidHeader = TRUE,
                           title = strong("Data Input", style = "color:white"),
                           selectInput("inputOption", h4(strong("Data type")), c("Choose one" = "", "Phyloseq", "Individual Data"), width = '30%'),
                           div(id = "optionsInfo", tags$p("You can choose phyloseq or individual data.", style = "font-size:11pt"), tags$p("", style = "margin-bottom:-8px"), style = "margin-top: -15px"),
                           uiOutput("moreOptions"))),
                  column(width = 6, style='padding-left:0px', uiOutput("addDownloadinfo"))
                )),
        
        ## QC ----
        tabItem(tabName = "step2", br(),
          sidebarLayout(
            position = "left",
            sidebarPanel(width = 3,
                         textInput("kingdom", h4(strong("Kingdom")), value = "Bacteria"),
                         QC_KINGDOM_COMMENT,
                         tags$style(type = 'text/css', '#slider1 .irs-grid-text {font-size: 1px}'),
                         tags$style(type = 'text/css', '#slider2 .irs-grid-text {font-size: 1px}'),
                         
                         sliderInput("slider1", h4(strong("Library size")), min=0, max=10000, value = 3000, step = 1000),
                         QC_LIBRARY_SIZE_COMMENT1,
                         QC_LIBRARY_SIZE_COMMENT2,
                         
                         sliderInput("slider2", h4(strong("Mean proportion")), min = 0, max = 0.1, value = 0.002, step = 0.001,  post  = " %"),
                         QC_MEAN_PROP_COMMENT1,
                         QC_MEAN_PROP_COMMENT2,
                         
                         br(),
                         p(" ", style = "margin-bottom: -20px;"),
                         
                         h4(strong("Erroneous taxonomic names")),
                         textInput("rem.str", label = "Complete match", value = ""),
                         QC_TAXA_NAME_COMMENT1,
                         
                         textInput("part.rem.str", label = "Partial match", value = ""),
                         QC_TAXA_NAME_COMMENT2,
                         
                         actionButton("run", (strong("Run!")), class = "btn-info"), 
                         p(" ", style = "margin-bottom: +10px;"), 
                         p(strong("Attention:"),"You have to click this Run button to perform data transformation and further analyses.", style = "margin-bottom:-10px"), br(),
                         uiOutput("moreControls")),
            mainPanel(width = 9,
                      fluidRow(width = 12,
                               status = "info", solidHeader = TRUE, 
                               valueBoxOutput("sample_Size", width = 3),
                               valueBoxOutput("OTUs_Size", width = 3),
                               valueBoxOutput("phyla", width = 3),
                               valueBoxOutput("classes", width = 3)),
                      fluidRow(width = 12, 
                               status = "info", solidHeader = TRUE,
                               valueBoxOutput("orders", width = 3),
                               valueBoxOutput("families", width = 3),
                               valueBoxOutput("genera", width = 3),
                               valueBoxOutput("species", width = 3)),
                      fluidRow(style = "position:relative",
                               tabBox(width = 6, title = strong("Library Size", style = "color:black"), 
                                      tabPanel("Histogram",
                                               plotlyOutput("hist"),
                                               sliderInput("binwidth", "# of Bins:",min = 0, max = 100, value = 50, width = "100%"),
                                               chooseSliderSkin("Round", color = "#112446")),
                                      tabPanel("Box Plot", 
                                               plotlyOutput("boxplot"))),
                               tabBox(width = 6, title = strong("Mean Proportion", style = "color:black"), 
                                      tabPanel("Histogram",
                                               plotlyOutput("hist2"),
                                               sliderInput("binwidth2", "# of Bins:",min = 0, max = 100, value = 50, width = "100%"),
                                               chooseSliderSkin("Round", color = "#112446")),
                                      tabPanel("Box Plot",
                                               plotlyOutput("boxplot2"))))))),
        
        ## Data Transformation -----
        tabItem(tabName = "dataTransform", br(),
                column(width = 6, style='padding-left:+13px',
                       box(title = strong("Data Transformation", style = "color:white"), width = NULL, status = "info", solidHeader = TRUE,
                           DATA_TRANSFORM_COMMENT,
                           actionButton("datTransRun", (strong("Run!")), class = "btn-info"),
                           p(" ", style = "margin-bottom: +10px;"), 
                           p(strong("Attention:"),"You have to click this Run button to perform following taxonomy-level machine learning analyses."),
                           p("", style = "margin-bottom:-8px")),
                       uiOutput("datTransDownload")),
                column(width = 6, style='padding-left:0px', 
                       box(title = strong("References", style = "color:white"), width = NULL, status = "info", solidHeader = TRUE,
                           DATA_TRANSFORM_REFERENCE,
                           p("", style = "margin-bottom:-8px")))),
        
        ## Decision tree ------
        tabItem(tabName = "dt", br(),
                fluidRow(
                  tabBox(width = 12,
                         tabPanel(
                           title = "Classification",
                           sidebarLayout( 
                             position = "left",
                             sidebarPanel(width = 3,
                                          shinyjs::hidden(
                                            uiOutput("dt_cla_data_input"),
                                            uiOutput("dt_cla_covariate"),
                                            uiOutput("dt_cla_train_setting"),
                                            uiOutput("dt_cla_downloadTabUI"),
                                            uiOutput("dt_cla_reference"))),
                             mainPanel(width = 9,
                                       fluidRow(width = 12, uiOutput("dt_cla_results"))))),
                         tabPanel(
                           title = "Regression",
                           sidebarLayout( 
                             position = "left",
                             sidebarPanel(width = 3,
                                          shinyjs::hidden(
                                            uiOutput("dt_reg_data_input"),
                                            uiOutput("dt_reg_covariate"),
                                            uiOutput("dt_reg_train_setting"),
                                            uiOutput("dt_reg_downloadTabUI"),
                                            uiOutput("dt_reg_reference"))),
                             mainPanel(width = 9,
                                       fluidRow(width = 12, uiOutput("dt_reg_results")))))))),
        
        ## Random Forest ------
        tabItem(tabName = "rf", br(),
                fluidRow(
                  tabBox(width = 12,
                         tabPanel(
                           title = "Classification",
                           sidebarLayout( 
                             position = "left",
                             sidebarPanel(width = 3,
                                          shinyjs::hidden(
                                            uiOutput("rf_cla_data_input"),
                                            uiOutput("rf_cla_covariate"),
                                            uiOutput("rf_cla_train_setting"),
                                            uiOutput("rf_cla_downloadTabUI"),
                                            uiOutput("rf_cla_reference"))),
                             mainPanel(width = 9,
                                       fluidRow(width = 12, uiOutput("rf_cla_results"))))),
                         tabPanel(
                           title = "Regression",
                           sidebarLayout( 
                             position = "left",
                             sidebarPanel(width = 3,
                                          shinyjs::hidden(
                                            uiOutput("rf_reg_data_input"),
                                            uiOutput("rf_reg_covariate"),
                                            uiOutput("rf_reg_train_setting"),
                                            uiOutput("rf_reg_downloadTabUI"),
                                            uiOutput("rf_reg_reference"))),
                             mainPanel(width = 9,
                                       fluidRow(width = 12, uiOutput("rf_reg_results")))))))),
        
        ## Gradient Boosting ------
        tabItem(tabName = "xgb", br(),
                fluidRow(
                  tabBox(width = 12,
                         tabPanel(
                           title = "Classification",
                           sidebarLayout( 
                             position = "left",
                             sidebarPanel(width = 3,
                                          shinyjs::hidden(
                                            uiOutput("xgb_cla_data_input"),
                                            uiOutput("xgb_cla_covariate"),
                                            uiOutput("xgb_cla_train_setting"),
                                            uiOutput("xgb_cla_downloadTabUI"),
                                            uiOutput("xgb_cla_reference"))),
                             mainPanel(width = 9,
                                       fluidRow(width = 12, uiOutput("xgb_cla_results"))))),
                         tabPanel(
                           title = "Regression",
                           sidebarLayout( 
                             position = "left",
                             sidebarPanel(width = 3,
                                          shinyjs::hidden(
                                            uiOutput("xgb_reg_data_input"),
                                            uiOutput("xgb_reg_covariate"),
                                            uiOutput("xgb_reg_train_setting"),
                                            uiOutput("xgb_reg_downloadTabUI"),
                                            uiOutput("xgb_reg_reference"))),
                             mainPanel(width = 9,
                                       fluidRow(width = 12, uiOutput("xgb_reg_results"))))))))
      )
    )
  )
}
