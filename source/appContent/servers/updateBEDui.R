################################################################################
################################################################################
################################################################################
################################################################################
# update UI for coordinate files section
################################################################################
################################################################################
################################################################################
################################################################################
#show head selected files, between file choosing process and file confirmation/new GRange
#use rendereTable instead of renderDataTable according to your needs
output$fileHead <- renderDataTable({

  if (!is.null(BEDvariables$tempBED)& BEDvariables$opened){
    as.matrix(BEDvariables$tempBED)

  }else{
    NULL
    #as.matrix(data.frame("BED_file_now_not_selected_or_not_valid..."))
  }
  
},options=list(pagingType = "simple",pageLength = 5,lengthChange=FALSE,searching=FALSE))

# #show BED file name history
# output$showBEDfiles<-renderText({
#   paste(as.list(BEDvariables$BEDfilehistory),collapse="<br>")
# })


# #show current problem or not in opening the file, if any over file preview
# output$showproblem<-renderText({
#   paste(logvariables$currentproblem,collapse="\n")
# })

#show current file opened
output$showcurrentfile<-renderText({
  paste("File content: <b>",BEDvariables$sfn,"</b>",sep="")
})

# #update checkbox input of the files to be deleted, if BEDfilehistory changes
# observe({
#     historylist=as.list(GRvariables$names)
#     names(historylist)=GRvariables$names
#     updateCheckboxGroupInput(session,inputId="selectedBEDtoRemove",label="Coordinates to delete:",
#                                 choices = historylist)    
# })


#react to main radiobutton (from where ROI?)
observe({
  if(!is.null(input$importROImainchoice)){
    if(input$importROImainchoice=="fromfile"){
      output$importROIwindowToShow<-renderUI({
        list(
          column(width=4,
            HTML("<h3>Open file:</h3><br>"),
            radioButtons("loadBEDsource",NULL,choices=c(
                                                      "Choose file from filesystem"="filesystem",
                                                      "Manually type the path of the file"="path"
                                                            ),selected="filesystem"),
            uiOutput("loadBEDsource"),
            HTML("<br>"),
            HTML('<hr size=3>'),
            HTML("<h4>Parameters:</h4>"),
            checkboxInput("readheader","Header",value=TRUE),
            numericInput(inputId = 'skiplines',label="Lines to skip:",min = 0, step = 1,value=0)
            
          ),
          column(width=8,
            HTML("<h3>File preview</h3>"),
            HTML("<br>"),
            htmlOutput("showcurrentfile"),
            dataTableOutput("fileHead"),
            HTML("<br><br>"),
            #open button and cancel button
            fluidRow(
              column(4,uiOutput('cancelfilebutton')),
              column(2,uiOutput('openfilebutton'))
            )          
          )

        )

      })
    }else if(input$importROImainchoice=="fromgenelist"){
      output$importROIwindowToShow<-renderUI({
        list(
          column(width=6,  
            HTML("<h3>Genes to import</h3>"),

            radioButtons("loadGenelistsource",NULL,choices=c(
                                                      "Paste IDs/symbols"="paste",
                                                      "Choose gene list from filesystem"="filesystem",
                                                      "Manually type the path of the file"="path"
                                                            ),selected="paste"),
            uiOutput("loadGenelistsource")
          ),
          column(width=6,
            HTML("<h3>Parameters</h3>"),
            HTML("<br>"),
            radioButtons("symbolORid","What kind of identifiers are you importing?",choices=c(
                                                      "ENTREZ IDs"="entrez",
                                                      "ENSEMBL IDs"="ensembl",
                                                      "Symbols"="symbol",
                                                      "RefSeq IDs"="refseq"
                                                            ),selected="symbol"),
            HTML("<br>"),
            HTML("<b>Max length for transcripts:</b>"),
            numericInput(inputId = 'thresholdTranscripts',label=NULL,min = 0, step = 100000,value=200000)       
          )
        )
      })
    }else{
      output$importROIwindowToShow<-renderUI({
        list(
          #warning in case BSgenome DB not present (copy of what seen in extract pattern from modifyROI)
          uiOutput("showWarningBSgenome2"),
          #motif text input (copy of that in motifyROI)
          textInput("PatternToSearch2",label="Select pattern (IUPAC nomenclature)",placeholder="ATCNYGG"),
          #new ROI name
          textInput("ROInamePattern2",label="Name of the ROI",placeholder="type new ROI name here"),
          actionButton("ExtractPatternROI2","Create ROI") 
        )
      })
    }
  }else{
    output$importROIwindowToShow<-renderUI({NULL})
  }
})




#react to radiobutton, whether to choose from filesystem the coordinate file
observe({
  if (!is.null(input$loadBEDsource)){
    if(input$loadBEDsource=="filesystem"){
      output$loadBEDsource<-renderUI({
        shinyFilesButton('file', 'Select a file', 'Please select a file', FALSE)
      })
    }else{
      output$loadBEDsource<-renderUI({
        list(
          textInput("BEDfrompath",NULL,value="",placeholder = "/path/to/BEDorGTF"),
          actionButton("confirmImportBEDfrompath", "Open file")
        )
      })
    }
  }else{
    output$loadBEDsource<-renderUI({NULL})
  }
})


#react to radiobutton, whether to choose from filesystem or other source the genelist file
observe({
  if (!is.null(input$loadGenelistsource)){

    if(input$loadGenelistsource=="paste"){
      output$loadGenelistsource<-renderUI({
        list(
          HTML("<b>Paste IDs/symbols here:</b><br>"),
          textAreaInput("pastedGENELISTS",NULL,value="",height=150),
          textInput("nameGENELISTS",NULL,placeholder="genelist name",value=""),
          actionButton("createGENELISTSfrompaste", "Import")  
        )
      })
    }else if (input$loadGenelistsource=="filesystem"){
      output$loadGenelistsource<-renderUI({
        shinyFilesButton('fileGENELISTS', 'Open gene list text file', 'Please select a txt file', FALSE)
      })
    }else{
      output$loadGenelistsource<-renderUI({
        list(
          textInput("GENELISTSfrompath",NULL,value=NULL,placeholder = "/path/to/geneList.txt"),
          actionButton("createGENELISTSfrompath", "Open gene list")
        )
      })
    }


  }else{
    output$loadGenelistsource<-renderUI({NULL})
  }

})




#create/hide "Open it!" button and cancel button for opening coord. file, only when file is opened
#or changed but always valid and opened
observe({
  if(!is.null(BEDvariables$tempBED) & !is.null(BEDvariables$tempBEDname)){
    output$openfilebutton<-renderUI({
      actionButton("confirmation", "Confirm and import as ROI")
    })
    output$cancelfilebutton<-renderUI({
      actionButton("cancellation", "Cancel")
    })      
  }else{
    output$openfilebutton<-renderText({
      c("")
    })
    output$cancelfilebutton<-renderUI({
      c("")
    })
  } 
})



##react to lines to skip (temp already there) and header (TRUE/FALSE), keeping the same file name
##until cancel
observe({
  input$readheader
  input$skiplines
  #now check: if file selected (sfn and tempbed must not be null or false), re-read the BED/GTF
  #otherwise skip (withOUT error popup).
  if(!is.null(isolate(BEDvariables$tempBED)) & !is.null(isolate(BEDvariables$sfn)) & !is.null(BEDvariables$completepath) & isvalid(input$skiplines)){
    tryCatch({
      BEDvariables$tempBED=readBEDGTFF(BEDvariables$completepath,Header=input$readheader,Skip=input$skiplines)
    },warning = function( w ){
      #if read file is not success, do not throw the file! simply keep the same as before with popup!
      sendSweetAlert(
        session = session,
        title = "Error in opening file",
        text = "Try to change 'Header' or 'lines to skip' parameters",
        type = "error"
      ) 
    },error = function( err ){
      sendSweetAlert(
        session = session,
        title = "Error in opening file",
        text = "Try to change 'Header' or 'lines to skip' parameters",
        type = "error"
      )       
    })
    #this way, if new header/lines to skip are not ok, keep the previous that were valid

  }else{

  }
})







######################################################################################
######################################################################################
######################################################################################
#RENAME ROI
######################################################################################
######################################################################################
######################################################################################


#update text field for renaming the ROI, if ROIvariables$names changed
observe({
  
  nomi=unlist(lapply(ROIvariables$listROI,getName))
  updateTextInput(session,inputId="newfilenameROI",label="New ROI name:",value="")    
})

######################################################################################
######################################################################################
######################################################################################
#reorder ROI
######################################################################################
######################################################################################
######################################################################################

#reorder ROI
observeEvent(ROIvariables$listROI,{
  
  output$dinamicROI<-renderUI({
    if (!is.null(ROIvariables$listROI) & length(ROIvariables$listROI)>=1){
      lista=list()
      nomi=unlist(lapply(ROIvariables$listROI,getName))
      choicelist=as.list(1:length(nomi))
      names(choicelist)=as.character(1:length(nomi))
      for (i in 1:length(nomi)){
        lista[[i]]=fluidRow(column(3,
                                selectInput(inputId = paste("reorderoptionROI",i,sep=""), label = NULL, 
                              choices = choicelist,selected=i)),
                column(4,HTML(nomi[i])))
      }
      return(lista)       
    }else{
      return(HTML("No ROI..."))
    }

  })   
})
