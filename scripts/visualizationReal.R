#libraries
library(plyr)
library(ggplot2)

#Load data
realStream <- "airlines" 

path <- paste("F:/moa_out/real/", realStream, "/", sep="") 
files <- list.files(path=path, pattern="*.csv")
plot_path <- paste("F:/r_out/real/", realStream, sep="") 
dir.create(file.path(plot_path), showWarnings = FALSE)


files1 <- rev(files)
files <- c("EvaluateInterleavedTestThenTrainbayesNaiveBayesPageHinkleyDM")

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
  
  #assign(
  #  dfName, tmpDf
  #)
  file <- paste(mean(tmpDf$classificationsCorrectPercentage), dfName,".png",sep="")
  
  fileWithPath <- paste(plot_path,"/", file, sep="")
  print(fileWithPath)
  
  #if(!file.exists(fileWithPath)){
    
    
    
    
    
    
    
    ggplot(aes(x = learningEvaluationInstances, y = classificationsCorrectPercentage), data = tmpDf) + geom_line() + 
      ggtitle(paste(title, sep=""))+ labs(x="Instance number",y="Accuracy")  + ylim(0,100) + 
      theme(plot.title = element_text(size = rel(0.5)))
    #save plot 
    ggsave(filename=file, path=plot_path)
  #}
  
  
  
}


