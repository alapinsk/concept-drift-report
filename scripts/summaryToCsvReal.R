#libraries
library(plyr)
library(ggplot2)
library(pastecs)

#Load data
realStreams <- c("airlines",
                "elecNormNew")


for(realStream in realStreams)
{
  path <- paste("F:/moa_out/real/", realStream, "/", sep="") 
  files <- list.files(path=path, pattern="*.csv")
  plot_path <- paste("F:/r_out/real/", realStream, sep="") 
  dir.create(file.path(plot_path), showWarnings = FALSE)
  
  i <- 1
  
  sumTable <-data.frame(method=1,evaluationTimeInCPUSeconds=1,classificationsCorrectPercentageMean=1,
                        classificationsCorrectPercentageMax=1)[-1,] 
  
  
  for(file in files)
  {
    perpos <- which(strsplit(file, "")[[1]]==".")
    dfName <- gsub(" ","",substr(file, 1, perpos-1))
    print(dfName)
    
    title <- gsub("([A-Z])", " \\1", dfName) 
    
    tmpDf <- read.csv(paste(path,file,sep=""),sep= ",", header = T, fileEncoding="UTF-16LE")
    tmpDf <- rename(tmpDf, 
                    c("learning.evaluation.instances" = "learningEvaluationInstances", "evaluation.time..cpu.seconds." = "evaluationTimeInCPUSeconds"
                      ,"model.cost..RAM.Hours." = "modelCostInRAMHours", "classified.instances" = "classifiedInstances"
                      ,"classifications.correct..percent." = "classificationsCorrectPercentage", "Kappa.Statistic..percent." = "KappaStatisticPercentage"
                      ,"Kappa.Temporal.Statistic..percent." = "KappaTemporalStatisticPercentage", "Kappa.M.Statistic..percent." = "KappaMStatisticPercentage"
                      ,"model.training.instances" = "modelTrainingInstances", "model.serialized.size..bytes." = "modelSerializedSizeBytes"
                      ,"Change.detected" = "ChangeDetected", "Warning.detected" = "WarningDetected"
                      ,"labeling.cost" = "labelingCost", "newThreshold" = "newThreshold"
                      ,"maxPosterior" = "maxPosterior", "accuracyBaseLearner..percent." = "accuracyBaseLearnerPercentage")
    )
    
    
    
    
    title <- gsub("([A-Z])", " \\1", dfName) 
    file <- paste(mean(tmpDf$classificationsCorrectPercentage), dfName,".png",sep="")
    
    print(paste(plot_path,"/", file, sep=""))
    
    
    
    #empty dataframe used to construct table
    table1 <-data.frame(model.num=1,intercept=1,intercept.se=1,slope=1,slope.se=1,r.squared=1,p.value=1)[-1,] 
    
    
    sumTable[i,] <- c(dfName,
                      max(tmpDf$evaluationTimeInCPUSeconds),
                      mean(tmpDf$classificationsCorrectPercentage),
                      max(tmpDf$classificationsCorrectPercentage)
    )
    
    i <- i + 1
    
  }
  write.csv(sumTable,file=paste(plot_path,generator,".csv",sep=""))
}


