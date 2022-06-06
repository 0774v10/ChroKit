tabROI<-tabItem (tabName = "ROIblock",
  tabsetPanel(type="pills",
    tabPanel("Overlaps",
      fluidRow(
        box(width=3,collapsible = TRUE,status = "primary",solidHeader = TRUE,
          title=boxHelp(ID="msg_newRois_options",title="Options"),
          #minimum overlap (true for all the blocks)
          HTML("<b>Minimum number of bp to consider for overlaps:</b>"),
          numericInput(inputId = 'minOverlapNEWROI',label=NULL,min = 1, step = 5,value=1),
          checkboxInput("StrandSpecOverlapNEWROI", label="Strand-specific overlaps",value = FALSE, width = NULL),
          textInput("ROIname",label="Name of the ROI",placeholder="type new ROI name here"),
          # resize width from the center (work also on the summit, when BAM is available)
          #button for "create ROI" (check if some BED files are selected, otherwise msg in logs: not possible)
          actionButton("maketheROI", "Build the ROI!")            
        ), 
             
        box(width=9,collapsible = TRUE,status = "primary",solidHeader = TRUE,
                      title=boxHelp(ID="msg_newRois_ROIcombination",title="Combination of ROIs"),
          fluidRow(
            column(width=4,
              HTML("<h4><b>Choose the reference ROI:</b></h4>"),
              HTML("Select ROI(s):"),
              wellPanel(id = "logPanel",style = "overflow-y:scroll; overflow-x:scroll; max-height: 400px; max-width: 300px; background-color: #ffffff;",
                checkboxGroupInput("selectedROIs",NULL,NULL)
              ),
              # radiobutton for union/intersection
              uiOutput("RadiobuttonStartingROI")          
            ),
            column(width=4,
              HTML("<h4><b>...that overlaps with:</b></h4>"),  
              uiOutput("columnOverlap"),
              uiOutput("overlapcriteria") 
            ),
            column(width=4,
              HTML("<h4><b>...that doesn't overlap with:</b></h4>"),
              uiOutput("columnNotOverlap"),
              uiOutput("notoverlapcriteria")
            )
          )  

        )
 
      )
    ),
    


    # RESIZE ROIs
    tabPanel("Modify ROIs",

      fluidRow(
        box(width=4,collapsible = TRUE,status = "primary",solidHeader = TRUE,
          title=boxHelp(ID="msg_modifyRois_resize",title="Resize"),
          selectInput("selectROItoresize",label="Select ROI to resize:",NULL),

          #other options if needed
          radioButtons("chooseResizeType",label=NULL,choices=c(
                              "Resize using fixed value"="fixedVal",
                              "Resize using percentage of range width"="percentageVal"
                            ),selected="fixedVal"),   

          radioButtons("choosePointResize",label="Choose fixed point for resize:",choices=c(
                              "From midpoint/TSS"="fromMid",
                              "From starts"="fromStart",
                              "From ends"="fromEnd"
                            ),selected="fromMid"),
          
          uiOutput("showFixedMenuResize"),

          textInput("ROInameResize",label="Name of the ROI",placeholder="type new ROI name here"),
          actionButton("resizeROI","Create ROI")
        ),

        box(width=4,collapsible = TRUE,status = "primary",solidHeader = TRUE,
          title=boxHelp(ID="msg_modifyRois_summit",title="Center on summit"),

          selectInput("selectROItoCenterSummit",label="Select ROI to center on summit:",NULL),
          selectInput("selectBAMtoCenterSummit",label="Select enrichment to use for summit:",NULL),
          textInput("ROInameSummit",label="Name of the ROI",placeholder="type new ROI name here"),
          actionButton("SummitROI","Create ROI")
        ),

        box(width=4,collapsible = TRUE,status = "primary",solidHeader = TRUE,
          title=boxHelp(ID="msg_modifyRois_sample",title="Random sample"),

          selectInput("selectROItoSample",label="Select ROI to sample:",NULL),
          sliderInput('quantileThreshSample',label="Fraction to keep:",min = 0, max = 1, value = 0.3,step=0.05),
          numericInput(inputId = 'numberSample',label=NULL,min = 0, max = 0, step = 50,value=0),
          textInput("ROInameSample",label="Name of the ROI",placeholder="type new ROI name here"),
          actionButton("SampleROI","Create ROI")
        )

        

      ),




      fluidRow(

        box(width=4,collapsible = TRUE,status = "primary",solidHeader = TRUE,
          title=boxHelp(ID="msg_modifyRois_width",title="Filter for width"),

          selectInput("selectROItoFilterWIDTH",label="Select ROI to filter:",NULL),
          sliderInput('quantileThreshFilterWIDTH',label="Quantile intervals:",min = 0, max = 1, value = c(0,0.9),step=0.002),
          fluidRow(
            column(width=4,HTML("<b>MIN width</b>")),
            column(width=4),
            column(width=4,HTML("<b>MAX width</b>"))
          ),
          fluidRow(
            column(width=4,
              numericInput(inputId = 'absoluteFilter1WIDTH',label=NULL,min = 0, max = 0, step = 50,value=0)
            ),
            column(width=4,
              HTML("<h4>      &lt; --- &gt; </h4>")
            ),
            column(width=4,
              numericInput(inputId = 'absoluteFilter2WIDTH',label=NULL,min = 0, max = 0, step = 50,value=0) 
            )
          ),

          textInput("ROInameFilterWIDTH",label="Name of the ROI",placeholder="type new ROI name here"),
          actionButton("FilterROIWIDTH","Create ROI")

        ),


        box(width=4,collapsible = TRUE,status = "primary",solidHeader = TRUE,
          title=boxHelp(ID="msg_modifyRois_enrichment",title="Filter for enrichment"),

          selectInput("selectROItoFilter",label="Select ROI to filter:",NULL),
          selectInput("selectBAMtoFilter",label="Select enrichment to use for filtering:",NULL),
          sliderInput('quantileThreshFilter',label="Quantile intervals:",min = 0, max = 1, value = c(0,0.9),step=0.002),
          fluidRow(
            column(width=4,HTML("<b>MIN enrichment</b>")),
            column(width=4),
            column(width=4,HTML("<b>MAX enrichment</b>"))
          ),
          fluidRow(
            column(width=4,
              numericInput(inputId = 'absoluteFilter1',label=NULL,min = 0, max = 0, step = 50,value=0)
            ),
            column(width=4,
              HTML("<h4>      &lt; --- &gt; </h4>")
            ),
            column(width=4,
              numericInput(inputId = 'absoluteFilter2',label=NULL,min = 0, max = 0, step = 50,value=0) 
            )
          ),

          textInput("ROInameFilter",label="Name of the ROI",placeholder="type new ROI name here"),
          actionButton("FilterROI","Create ROI")

        ),

        box(width=4,collapsible = TRUE,status = "primary",solidHeader = TRUE,
          title=boxHelp(ID="msg_modifyRois_pattern",title="Extract patterns"),

          # radioButtons("choiceWherePattern",label="Choose where to search for the pattern:" ,
          #                          choices=c("From a ROI"="fromROI",
          #                                    "From the entire genome (SLOW!)"="fromGenome"),
          #                          selected="fromROI"
          # ),
          selectInput("selectROItoExtractPattern",label="ROI to extract pattern from:",NULL),
          #warning in case BSgenome DB not present
          uiOutput("showWarningBSgenome"),
          #motif text input
          textInput("PatternToSearch",label="Select pattern (IUPAC nomenclature)",placeholder="ATCNYGG"),
          #menu or text to choose if both strands or strand in range
          uiOutput("showStrandOptsPattern"),
          #name of the new motif
          textInput("ROInamePattern",label="Name of the ROI",placeholder="type new ROI name here"),
          actionButton("ExtractPatternROI","Create ROI")

        )




      )


    ),






        
    #for each ROI, show features (density plot of the width and /or barplot of ranges number)
    tabPanel("View ROI",
      fluidRow(
        box(width=3,collapsible = TRUE,status = "primary",solidHeader = TRUE,
          title=boxHelp(ID="msg_viewRois_selectRoi",title="ROI selection"),

          HTML("<b>Select ROI to view:</b>"),
          wellPanel(id = "logPanel",style = "overflow-y:scroll; overflow-x:scroll; max-height: 300px; max-width: 300px; background-color: #ffffff;",
            checkboxGroupInput("confirmviewROI", label=NULL,choices=NULL)
          ),
          
          actionButton("updatechoiceROI", "View")
        ),
        box(width=6,collapsible = TRUE,status = "primary",solidHeader = TRUE,
          title=boxHelp(ID="msg_viewRois_visualization",title="Visualization"),

          tabBox(width=12,
            tabPanel("width distribution",
              plotOutput('viewROIwidth'),
              htmlOutput("saveviewpeakswidthROI")
            ),
            tabPanel("intervals number",
              plotOutput("viewpeaksnumberROI"),
              htmlOutput("saveviewpeaksnumberROI")
             
            ) 
          )
        ), 
        
        box(width=3,collapsible = TRUE,status = "primary",solidHeader = TRUE,
            title=boxHelp(ID="msg_viewRois_information",title="Information"),

            HTML("<br>"),
            sliderInput("quantileROIwidth",label="Select quantile of the width distribution:",min=0,max=1,value=.5,step=0.01),
            htmlOutput("viewROIstat"),
            HTML("<br>"),
            HTML("<b>Notes of the ROI:</b>"),
            wellPanel(id = "logPanel",style = "overflow-y:scroll; overflow-x:scroll; max-height: 200px; max-width: 300px; background-color: #ffffff;",
              htmlOutput("viewROIsource")
            )
        )
      )
    ),


    #for each ROI, show features (density plot of the width and /or barplot of ranges number)
    tabPanel("Get ROI",
      fluidRow(
        box(width=3,collapsible = TRUE,status = "primary",solidHeader = TRUE,
          title=boxHelp(ID="msg_getRois_roiSelection",title="ROI selection"),

          HTML("<b>Select ROI:</b>"),
          selectInput("listgetROI",NULL,choices=NULL),

          radioButtons("choosegetROItype",label=NULL,choices=c(
                              "Features for each genomic range"="eachRange",
                              "Gene list inside genomic window"="genesWindow",
                              "Edit notes of the ROI"="editNotes"
                            ),selected="eachRange"),   
          uiOutput("showROIoptionsToGET")      

          # uiOutput("showROIoptionsToViewRANGE"),
          # uiOutput("showROIoptionsToViewMETADATA"),
          # uiOutput("showROIoptionsToViewENRICHMENTS"),
          # #checkboxInput("putEnrichments", label="Put available enrichments",value = TRUE, width = NULL),
          # actionButton("showdataframeROI", "Preview ROI"),

          # HTML("<br><br><br><br>"),
          # uiOutput("showWindowAnnotation")

        ),

        
        box(width=9,collapsible = TRUE,status = "primary",solidHeader = TRUE,
          title=boxHelp(ID="msg_getRois_preview",title="Preview"),

          htmlOutput("previewROItodownload"),
          htmlOutput("previewROItodownloadbutton")
          
        )
      )
    ),





    




    tabPanel("Prepare ROI for heatmap",
      fluidRow(
        column(width=6,
          box(width=12,collapsible = TRUE,status = "primary",solidHeader = TRUE,
                  title=boxHelp(ID="msg_PredefPipeline_parameters",title="ROI preparation for heatmap"),

            #ROI menu
            selectInput("selectROIpredefPipeline",label="Select ROI for preparation:",NULL),
            HTML("<br>"),
            HTML('<hr size=3>'),
            HTML("<br>"),
            #subsample %
            sliderInput('quantileThreshPredefPipeline',label="% genomic ranges to keep:",min = 0, max = 1, value = 0.3,step=0.05),
            #this below allows absolute number input
            #numericInput(inputId = 'numberSamplePredefPipeline',label=NULL,min = 0, max = 0, step = 50,value=0),              

            #output UI with absolute number calculated (give warning if > 50k)
            uiOutput("textNumRangesPredefPipeline"),
            HTML("<br>"),
            HTML('<hr size=3>'),
            HTML("<br>"),
            #decide if center on summit (Yes/No); if Yes, menu with enrichment associated
            radioButtons("choiceSummitPredefPipeline",label="Do you want to center on summit?" ,
                                      choices=c("Yes"="Yes",
                                                "No"="No"),
                                      selected="No"
            ),
            uiOutput("menuSummitPredefPipeline"),       
            #selectInput("selectBAMtoCenterPredefPipeline",label="Enrichment to use for summit:",NULL),
            HTML("<br>"),
            HTML('<hr size=3>'),
            HTML("<br>"),
            #set intervals from midpoint/summit
            fluidRow(
              column(width=4,HTML("<b>Upstream</b>")),
              column(width=4),
              column(width=4,HTML("<b>Downstream</b>"))
            ),
            fluidRow(
              column(width=4,
                numericInput(inputId = 'sliderUpstreamPredefPipeline',label=NULL,min = 0, max = 20000, step = 50,value=2000) 
              ),
              column(width=4,
                HTML("<h4>Center</h4>")
              ),
              column(width=4,
                numericInput(inputId = 'sliderDownstreamPredefPipeline',label=NULL,min = 0, max = 20000, step = 50,value=2000) 
              )
            ),        

            HTML("<br>"),
            HTML('<hr size=3>'),
            HTML("<br>"),
            #select enrichment files for final ROI (from enrichmnt opened, "re-do" association)
            uiOutput("menuEnrichPredefPipeline"),
            # wellPanel(id = "logPanel",style = "overflow-y:scroll; overflow-x:scroll; max-height: 180px; max-width: 300px; background-color: #ffffff;",
            #         checkboxGroupInput("selectBAMassociatePredefPipeline", NULL,choices=NULL)
            # ),
            #number of cores for this association:
            HTML("<b>Number of cores:</b>"),
            numericInput(inputId = 'coresPredefPipeline',label=NULL,min = 1, max = nc, step = 1,value=1),

            HTML("<br>"),
            HTML('<hr size=3>'),
            HTML("<br>"), 


            HTML("<b>New ROI name:</b>"),
            textInput("ROInamePredefPipeline",label=NULL,placeholder="type new ROI name here"),
            actionButton("PrepareROIpredefPipeline","Create ROI")
          )      
        ),
        column(width=6)
        
      )
      
     

    )    



  )         
)




