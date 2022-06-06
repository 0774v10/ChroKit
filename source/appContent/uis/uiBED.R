####################################################################################
# TAB BED files
####################################################################################

tabBED <- tabItem(tabName = "BEDblock",
   

  #tabsetPanel(
    #tabPanel("New coordinate files", 
    fluidRow(  
      column(width=8,
        box(width=12,collapsible = TRUE,status = "primary",solidHeader = TRUE,
                title=boxHelp(ID="msg_coordinateFiles_chooseCoordinates",title="New ROI"),

          radioButtons("importROImainchoice",label="Select how to get a new ROI",choices=c(
                                  "Load a file of genomic coordinates (bed/gtf/gff)"="fromfile",
                                  "Get promoters, transcripts, TES coordinates of a list of genes"="fromgenelist",
                                  "Generate ROI from a sequence pattern in the genome"="frompattern"
                            ),selected="fromfile"),            

          HTML("<br><br>"),
          uiOutput("importROIwindowToShow")


        )
  
      ),

      column(width=4,
        box(width=12,collapsible = TRUE,status = "primary",solidHeader = TRUE,
          title=boxHelp(ID="msg_deleteRois_deleteRois",title="Loaded ROIs"),

          HTML("<b>ROI to delete:</b>"),
          wellPanel(id = "logPanel",style = "overflow-y:scroll; overflow-x:scroll; max-height: 300px; background-color: #ffffff;",
            checkboxGroupInput("selectedCustomROItoRemove",NULL,NULL)
          ),
          # HTML("<br>"),
          actionButton("deleteROI", "Delete")
        ),
        box(width=12,collapsible = TRUE,status = "primary",solidHeader = TRUE,
          title=boxHelp(ID="msg_deleteRois_renameRois",title="Rename ROIs"),

          # HTML("<br>"),
          HTML("<b>ROI to rename:</b>"),
          selectInput("selectedCustomROItoRename",label=NULL,NULL),
          # HTML("<br>"),
          textInput("newfilenameROI","New ROI name:",placeholder="type new ROI name here",value=""),
          # HTML("<br>"),
          actionButton("renameROI", "Rename")
        ),
        box(width=12,collapsible = TRUE,status = "primary",solidHeader = TRUE,
          title=boxHelp(ID="msg_deleteRois_reorderRois",title="Reorder ROIs"),

          wellPanel(id = "logPanelROI",style = "overflow-y:scroll; max-height: 300px",
            fluidPage(
              uiOutput("dinamicROI")
            )
          ),
          #button to confirm to reorder
          actionButton("reorderROI","Reorder!")
        )               
      )


        
       
        
    )

        


          
)
