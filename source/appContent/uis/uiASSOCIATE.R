#here the UI part for enrichment association. Server parts are in serverROI.R
tabASSOCIATE<-tabItem (tabName = "ASSOCIATEblock",


    #BAM association tab
      fluidRow(


        box(width=7,collapsible = TRUE,status = "primary",solidHeader = TRUE,
          title=boxHelp(ID="msg_associateEnrichments_associateRemove",title="Associate/remove enrichments"),

          fluidRow(
            column(width=6,
              HTML("<b>Choose ROI(s):</b><br>"),
              wellPanel(id = "logPanel",style = "overflow-y:scroll; overflow-x:scroll; max-height: 500px; max-width: 300px; background-color: #ffffff;",
                checkboxGroupInput("selectROItoBAMassociate",label=NULL,NULL)
              )
            
            ),
            column(width=6,
              HTML("<h3>Associate enrichment(s) to ROI(s)</h3><br>"),
              HTML("<b>Select enrichment(s) to associate to selected ROI(s):</b><br>"),
              wellPanel(id = "logPanel",style = "overflow-y:scroll; overflow-x:scroll; max-height: 180px; max-width: 300px; background-color: #ffffff;",
                checkboxGroupInput("selectBAMtoassociate", NULL,choices=NULL)
              ),
              uiOutput("radioForNorm"),
              uiOutput("menuForNorm"),
              HTML("<b>Number of cores:</b>"),
              numericInput(inputId = 'coresCoverage',label=NULL,min = 1, max = nc, step = 1,value=1),
              HTML("<i>WARNING</i>: time consuming (some minutes)<br>"),
              actionButton("confirmBAMassociate", "Associate!"),
              HTML("<br><br>"),
              HTML('<hr size=3>'),
              HTML("<br>"),
              HTML("<h3>Enrichments associated to ROI(s)</h3><br>"),
              HTML("<b>Select enrichment(s) to remove from selected ROI(s):</b><br>"),
              wellPanel(id = "logPanel",style = "overflow-y:scroll; overflow-x:scroll; max-height: 180px; max-width: 300px; background-color: #ffffff;",
                checkboxGroupInput("selectBAMtoDeassociate", NULL,choices=NULL)
              ),
              actionButton("confirmBAMDeassociate", "Remove")            
            )
          )
        ),

        box(width=5,collapsible = TRUE,status = "primary",solidHeader = TRUE,
          title=boxHelp(ID="msg_renameEnrichments_renameOrderEnrichments",title="Rename/reorder enrichments"),
          selectInput("selectROIforBAMrename",label="Select ROI for rename/reorder enrichments:",NULL),
          HTML("<br>"),

          radioButtons("selectRenameOrReorder",label=NULL ,
                                        choices=c("Rename an enrichment"="rename",
                                                  "Reorder enrichments in the ROI"="reorder"),
                                        selected="rename"
                          ),           

          uiOutput("RenameReorder")

        )
      )




       
)




