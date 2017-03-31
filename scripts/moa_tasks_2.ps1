Import-Module –Name "F:\Google Drive\Projects\PhD\datastreams-concept-drift\moa_tasks_combination-module.psm1" -Verbose


$outPath = "F:\moa_out"

#Go to moa workspace 
#cd $moaPath


$wekaPath = "C:\Users\Andrzej\.m2\repository\nz\ac\waikato\cms\weka\weka-dev\3.9.0\weka-dev-3.9.0.jar"
$moaPath = "F:\Google Drive\Projects\PhD\datastreams-concept-drift\moa\moa\target\moa-2016.10-SNAPSHOT.jar"
$sizeOfag = "F:\Google Drive\Projects\PhD\datastreams-concept-drift\master's thesis\moa\workspace\sizeofag.jar"
$realDatasetsPath = "F:\moa_in"


$moa = "java -cp ""$moaPath;$wekaPath""  moa.DoTask" # -javaagent:""$sizeOfag""


#tasks
$evaluatePrequential = "EvaluatePrequential"
$evaluatePrequentialRegression = "EvaluatePrequentialRegression"
$evaluateConceptDrift = "EvaluateConceptDrift"
$evaluateInterleavedChunks = "EvaluateInterleavedChunks"
$evaluateInterleavedTestThenTrain = "EvaluateInterleavedTestThenTrain"

$tasks = $evaluateInterleavedTestThenTrain #$evaluatePrequential,  $evaluatePrequentialRegression 




#classifier type
$driftDetection = "drift.DriftDetectionMethodClassifier"

$detectionTypes = $driftDetection


$localDriftDetection = "drift.LocalDriftDetectionMethodClassifier"



#learning methods 
$majorityClass = "functions.MajorityClass"
$bayes = "bayes.NaiveBayes"
$hoeffdingTree = "trees.HoeffdingTree"
$active = "active.ActiveClassifier" 

$learningMethods =  $hoeffdingTree , $bayes #$active, $majorityClass


#detectors
$eddm = "EDDM"
$ddm = "DDM"
$adwin = "ADWINChangeDetector"
$cusum = "CusumDM"
$ewmaChart = "EWMAChartDM"
$geometricMovingAverageDM = "GeometricMovingAverageDM"
$stepd = "STEPD"
$phl = "PageHinkleyDM"

$detectors = $eddm, $ddm, $adwin, $cusum, $ewmaChart, $stepd, $phl #$geometricMovingAverageDM

#artificial generators
$hyperplane = "generators.HyperplaneGenerator -k 1 -t 0.68 -n 20 -s 15"
$agrewal = "generators.AgrawalGenerator" 
$rbf = "generators.RandomRBFGenerator"
$rbfDrift = "generators.RandomRBFGeneratorDrift"
$randomTree = "generators.RandomTreeGenerator"
$sea = "generators.SEAGenerator"
$stagger = "generators.STAGGERGenerator -n 5000"
$waveform = "generators.WaveformGenerator"
$waveformDrift = "generators.WaveformGeneratorDrift"
$led = "generators.LEDGenerator"
$ledDrift = "generators.LEDGeneratorDrift"

$generators =  $hyperplane, $rbf, $agrewal , $stagger, $randomTree, $sea, $waveform,  $led  # , $rbfDrift, $ledDrift, $waveformDrift,

#realDatasets
$electricity = "elecNormNew.arff"
$airline = "airlines.arff"

$realDatasets = $electricity, $airline

$performanceEvaluator = "BasicClassificationPerformanceEvaluator"




$b = "EvaluateInterleavedTestThenTrain_treesHoeffdingTree_DDM_EWMAChartDM_STEPD_max", "EvaluateInterleavedTestThenTrain_treesHoeffdingTree_DDM_STEPD_PageHinkleyDM_majority","EvaluateInterleavedTestThenTrain_treesHoeffdingTree_DDM_ADWINChangeDetector_EWMAChartDM_max","EvaluateInterleavedTestThenTrain_treesHoeffdingTree_DDM_ADWINChangeDetector_STEPD_max","EvaluateInterleavedTestThenTrain_treesHoeffdingTree_EDDM_DDM_STEPD_max","EvaluateInterleavedTestThenTrain_treesHoeffdingTree_DDM_CusumDM_PageHinkleyDM_min","EvaluateInterleavedTestThenTraintreesHoeffdingTreeDDM","EvaluateInterleavedTestThenTraintreesHoeffdingTreeEDDM","EvaluateInterleavedTestThenTraintreesHoeffdingTreePageHinkleyDM","EvaluateInterleavedTestThenTraintreesHoeffdingTreeCusumDM","EvaluateInterleavedTestThenTraintreesHoeffdingTreeSTEPD","EvaluateInterleavedTestThenTraintreesHoeffdingTreeADWINChangeDetector","EvaluateInterleavedTestThenTraintreesHoeffdingTreeEWMAChartDM","EvaluateInterleavedTestThenTraintreesHoeffdingTree","EvaluateInterleavedTestThenTrain_bayesNaiveBayes_EDDM_DDM_STEPD_majority","EvaluateInterleavedTestThenTrain_bayesNaiveBayes_EDDM_STEPD_PageHinkleyDM_majority","EvaluateInterleavedTestThenTrain_bayesNaiveBayes_EDDM_EWMAChartDM_STEPD_max","EvaluateInterleavedTestThenTrain_bayesNaiveBayes_DDM_STEPD_PageHinkleyDM_majority","EvaluateInterleavedTestThenTrain_bayesNaiveBayes_EDDM_CusumDM_STEPD_majority","EvaluateInterleavedTestThenTrain_bayesNaiveBayes_DDM_CusumDM_PageHinkleyDM_min","EvaluateInterleavedTestThenTrainbayesNaiveBayesDDM","EvaluateInterleavedTestThenTrainbayesNaiveBayesEDDM","EvaluateInterleavedTestThenTrainbayesNaiveBayesPageHinkleyDM","EvaluateInterleavedTestThenTrainbayesNaiveBayesCusumDM","EvaluateInterleavedTestThenTrainbayesNaiveBayesSTEPD","EvaluateInterleavedTestThenTrainbayesNaiveBayesADWINChangeDetector","EvaluateInterleavedTestThenTrainbayesNaiveBayesEWMAChartDM","EvaluateInterleavedTestThenTrainbayesNaiveBayes"

$a = "EvaluateInterleavedTestThenTraintreesHoeffdingTree"



#loop through LocalDriftDetectionMethodClassifier
#Loop through all generators 
foreach($generator in $generators)
{
    foreach($task in $tasks)
    {
        foreach($learningMethod in $learningMethods)
        {
            foreach($detector in $detectors)
            {
                $outFileName = "local"+$task+$learningMethod+$detector -replace ‘[.]’
                $outFilePath = "$outPath\generator\$generator\".Replace("generators.","")
                $outFile = $outFilePath + "$outFileName.csv"
                $c = $moa, """", $task, "-l (","moa.classifiers.$localDriftDetection", "-l", "moa.classifiers.$learningMethod", "-d", $detector, ")", "-s (",$generator, ") -e $performanceEvaluator  -i 100000 -f 1 -q 1", """" -join " "
                $c = $c + " > ""$outFile""" 
                Write-Host $c
                #Write-Host $outFile
                if(!(Test-Path -Path $outFilePath )){
                    New-Item -ItemType directory -Path $outFilePath
                }
                
                #check if file exists
                If (Test-Path $outFile){
                    Write-Host "File", $outFile ,"already exist!"
                }Else{
                    Write-Host "Starting", $outFile
                    " " | Export-Csv $outFile
                    Invoke-Expression $c
                }

                

                # if($a -contains $outFileName)
                # {
                #     Write-Host "Starting", $outFile
                #     " " | Export-Csv $outFile
                #     Invoke-Expression $c
                # }
            }
        }
    }
}





#Loop through all generators 
foreach($generator in $generators)
{
    foreach($task in $tasks)
    {
        foreach($learningMethod in $learningMethods)
        {
                $outFileName = $task+$learningMethod -replace ‘[.]’
                $outFilePath = "$outPath\generator\$generator\".Replace("generators.","")
                $outFile = $outFilePath + "$outFileName.csv"
                $c = $moa, """", $task, "-l", "moa.classifiers.$learningMethod", "-s (",$generator, ") -e $performanceEvaluator  -i 100000 -f 1 -q 1", """" -join " "
                $c = $c + " > ""$outFile""" 
                #Write-Host $c
                #Write-Host $outFile
                if(!(Test-Path -Path $outFilePath )){
                    New-Item -ItemType directory -Path $outFilePath
                }
                
                #check if file exists
                If (Test-Path $outFile){
                    Write-Host "File", $outFile ,"already exist!"
                }Else{
                    Write-Host "Starting", $outFile
                    " " | Export-Csv $outFile
                    Invoke-Expression $c
                }

                # if($a -contains $outFileName)
                # {
                #     Write-Host "Starting", $outFile
                #     " " | Export-Csv $outFile
                #     Invoke-Expression $c
                # }
            
        }
    }
}


#Loop through all real datasets 
foreach($realDataset in $realDatasets)
{
    foreach($task in $tasks)
    {
        foreach($learningMethod in $learningMethods)
        {
            foreach($detector in $detectors)
            {
                $outFileName = "local"+$task+$learningMethod+$detector -replace ‘[.]’
                $outFilePath = "$outPath\real\$realDataset\".Replace(".arff","")
                $outFile = $outFilePath + "$outFileName.csv"
                $c = $moa, """", $task, "-l (","moa.classifiers.$localDriftDetection", "-l", "moa.classifiers.$learningMethod", "-d", $detector, ")", "-s (generators.multilabel.MultilabelArffFileStream -f ", "$realDatasetsPath\$realDataset", ")  -e $performanceEvaluator  -f 1 -q 1", """" -join " "
                $c = $c + " > ""$outFile""" 
                Write-Host $c
                Write-Host $outFile
                if(!(Test-Path -Path $outFilePath )){
                    New-Item -ItemType directory -Path $outFilePath
                }
                
                #check if file exists
                If (Test-Path $outFile){
                    Write-Host "File " + $outFile + " already exist!"
                }Else{
                    Write-Host "Starting", $outFile
                    " " | Export-Csv $outFile
                    Invoke-Expression $c
                }

                # if($a -contains $outFileName)
                # {
                #     Write-Host "Starting", $outFile
                #     " " | Export-Csv $outFile
                #     Invoke-Expression $c
                # }
            }
        }
    }
}



#Loop through all real datasets 
foreach($realDataset in $realDatasets)
{
    foreach($task in $tasks)
    {
        foreach($learningMethod in $learningMethods)
        {
                $outFileName = $task+$learningMethod -replace ‘[.]’
                $outFilePath = "$outPath\real\$realDataset\".Replace(".arff","")
                $outFile = $outFilePath + "$outFileName.csv"
                $c = $moa, """", $task, "-l", "moa.classifiers.$learningMethod", "-s (generators.multilabel.MultilabelArffFileStream -f ", "$realDatasetsPath\$realDataset", ")  -e $performanceEvaluator  -f 1 -q 1", """" -join " "
                $c = $c + " > ""$outFile""" 
                Write-Host $c
                Write-Host $outFile
                if(!(Test-Path -Path $outFilePath )){
                    New-Item -ItemType directory -Path $outFilePath
                }
                
                #check if file exists
                If (Test-Path $outFile){
                    Write-Host "File " + $outFile + " already exist!"
                }Else{
                    Write-Host "Starting", $outFile
                    " " | Export-Csv $outFile
                    Invoke-Expression $c
                }

                # if($a -contains $outFileName)
                # {
                #     Write-Host "Starting", $outFile
                #     " " | Export-Csv $outFile
                #     Invoke-Expression $c
                # }
            
        }
    }
}





#Loop through all generators 
foreach($generator in $generators)
{
    foreach($task in $tasks)
    {
        foreach($learningMethod in $learningMethods)
        {
            foreach($detector in $detectors)
            {
                $outFileName = $task+$learningMethod+$detector -replace ‘[.]’
                $outFilePath = "$outPath\generator\$generator\".Replace("generators.","")
                $outFile = $outFilePath + "$outFileName.csv"
                $c = $moa, """", $task, "-l (","moa.classifiers.$driftDetection", "-l", "moa.classifiers.$learningMethod", "-d", $detector, ")", "-s (",$generator, ") -e $performanceEvaluator  -i 100000 -f 1 -q 1", """" -join " "
                $c = $c + " > ""$outFile""" 
                #Write-Host $c
                #Write-Host $outFile
                if(!(Test-Path -Path $outFilePath )){
                    New-Item -ItemType directory -Path $outFilePath
                }
                
                #check if file exists
                If (Test-Path $outFile){
                    Write-Host "File", $outFile ,"already exist!"
                }Else{
                    Write-Host "Starting", $outFile
                    " " | Export-Csv $outFile
                    Invoke-Expression $c
                }

                # if($a -contains $outFileName)
                # {
                #     Write-Host "Starting", $outFile
                #     " " | Export-Csv $outFile
                #     Invoke-Expression $c
                # }
            }
        }
    }
}

#Loop through all real datasets 
foreach($realDataset in $realDatasets)
{
    foreach($task in $tasks)
    {
        foreach($learningMethod in $learningMethods)
        {
            foreach($detector in $detectors)
            {
                $outFileName = $task+$learningMethod+$detector -replace ‘[.]’
                $outFilePath = "$outPath\real\$realDataset\".Replace(".arff","")
                $outFile = $outFilePath + "$outFileName.csv"
                $c = $moa, """", $task, "-l (","moa.classifiers.$driftDetection", "-l", "moa.classifiers.$learningMethod", "-d", $detector, ")", "-s (generators.multilabel.MultilabelArffFileStream -f ", "$realDatasetsPath\$realDataset", ")  -e $performanceEvaluator  -f 1 -q 1", """" -join " "
                $c = $c + " > ""$outFile""" 
                Write-Host $c
                Write-Host $outFile
                if(!(Test-Path -Path $outFilePath )){
                    New-Item -ItemType directory -Path $outFilePath
                }
                
                #check if file exists
                If (Test-Path $outFile){
                    Write-Host "File " + $outFile + " already exist!"
                }Else{
                    Write-Host "Starting", $outFile
                    " " | Export-Csv $outFile
                    Invoke-Expression $c
                }

                # if($a -contains $outFileName)
                # {
                #     Write-Host "Starting", $outFile
                #     " " | Export-Csv $outFile
                #     Invoke-Expression $c
                # }
            }
        }
    }
}



####
# Ensemble Methods
####

$detectors = $ensembles = Get-Combination $detectors 3
forEach($ensemble in $ensembles)
{
    Write-Host $ensemble
}


$types = "min", "max", "majority"

#Loop through all generators 
foreach($generator in $generators)
{
    foreach($task in $tasks)
    {
        foreach($learningMethod in $learningMethods)
        {
            foreach($ensemble in $ensembles)
            {
                forEach($type in $types)
                {
                    $outFile = $task+","+$learningMethod+","+$ensemble+","+$type -replace ‘[.]’
                    $outFileName = $outFile.Replace(",","_")
                    $outFilePath = "$outPath\generator\$generator\".Replace("generators.","")
                    $outFile = $outFilePath + "$outFileName.csv"
                    $c = $moa, """", $task, "-l (","moa.classifiers.$driftDetection", "-l", "moa.classifiers.$learningMethod", "-d (EnsembleDriftDetectionMethods -c", $ensemble, "-l", $type,"))", "-s (",$generator, ") -e $performanceEvaluator  -i 100000 -f 1 -q 1", """" -join " "
                    $c = $c + " > ""$outFile""" 
                    # Write-Host $c
                    # Write-Host $outFile
                    if(!(Test-Path -Path $outFilePath )){
                        New-Item -ItemType directory -Path $outFilePath
                    }
                    
                    #check if file exists
                    If (Test-Path $outFile){
                        Write-Host "File", $outFile ,"already exist!"
                    }Else{
                        Write-Host "Starting", $outFile
                        " " | Export-Csv $outFile
                        Invoke-Expression $c
                    }

                    # if($a -contains $outFileName)
                    # {
                    #     Write-Host "Starting", $outFile
                    #     " " | Export-Csv $outFile
                    #     Invoke-Expression $c
                    # }
                }
                
            }
        }
    }
}



#Loop through all generators 
foreach($realDataset in $realDatasets)
{
    foreach($task in $tasks)
    {
        foreach($learningMethod in $learningMethods)
        {
            foreach($ensemble in $ensembles)
            {
                forEach($type in $types)
                {
                    $outFile = $task+","+$learningMethod+","+$ensemble+","+$type -replace ‘[.]’
                    $outFileName = $outFile.Replace(",","_")
                    $outFilePath = "$outPath\real\$realDataset\".Replace(".arff","")
                    $outFile = $outFilePath + "$outFileName.csv"
                    $c = $moa, """", $task, "-l (","moa.classifiers.$driftDetection", "-l", "moa.classifiers.$learningMethod", "-d (EnsembleDriftDetectionMethods -c", $ensemble, "-l", $type,"))", "-s (generators.multilabel.MultilabelArffFileStream -f ", "$realDatasetsPath\$realDataset", ") -e $performanceEvaluator  -i 100000 -f 1 -q 1", """" -join " "
                    $c = $c + " > ""$outFile""" 
                    # Write-Host $c
                    # Write-Host $outFile
                    if(!(Test-Path -Path $outFilePath )){
                        New-Item -ItemType directory -Path $outFilePath
                    }
                    
                    #check if file exists
                    If (Test-Path $outFile){
                        Write-Host "File", $outFile ,"already exist!"
                    }Else{
                        Write-Host "Starting", $outFile
                        " " | Export-Csv $outFile
                        Invoke-Expression $c
                    }

                    # if($a -contains $outFileName)
                    # {
                    #     Write-Host "Starting", $outFile
                    #     " " | Export-Csv $outFile
                    #     Invoke-Expression $c
                    # }
                }
                
            }
        }
    }
}


####
# Ensemble Methods
####

$detectors = $ensembles = Get-Combination $detectors 8
forEach($ensemble in $ensembles)
{
    Write-Host $ensemble
}


$types = "min", "max", "majority"

#Loop through all generators 
foreach($generator in $generators)
{
    foreach($task in $tasks)
    {
        foreach($learningMethod in $learningMethods)
        {
            foreach($ensemble in $ensembles)
            {
                forEach($type in $types)
                {
                    $outFile = $task+","+$learningMethod+","+$ensemble+","+$type -replace ‘[.]’
                    $outFileName = $outFile.Replace(",","_")
                    $outFilePath = "$outPath\generator\$generator\".Replace("generators.","")
                    $outFile = $outFilePath + "$outFileName.csv"
                    $c = $moa, """", $task, "-l (","moa.classifiers.$driftDetection", "-l", "moa.classifiers.$learningMethod", "-d (EnsembleDriftDetectionMethods -c", $ensemble, "-l", $type,"))", "-s (",$generator, ") -e $performanceEvaluator  -i 100000 -f 1 -q 1", """" -join " "
                    $c = $c + " > ""$outFile""" 
                    # Write-Host $c
                    # Write-Host $outFile
                    if(!(Test-Path -Path $outFilePath )){
                        New-Item -ItemType directory -Path $outFilePath
                    }
                    
                    #check if file exists
                    If (Test-Path $outFile){
                        Write-Host "File", $outFile ,"already exist!"
                    }Else{
                        Write-Host "Starting", $outFile
                        " " | Export-Csv $outFile
                        Invoke-Expression $c
                    }

                    # if($a -contains $outFileName)
                    # {
                    #     Write-Host "Starting", $outFile
                    #     " " | Export-Csv $outFile
                    #     Invoke-Expression $c
                    # }
                }
                
            }
        }
    }
}



#Loop through all generators 
foreach($realDataset in $realDatasets)
{
    foreach($task in $tasks)
    {
        foreach($learningMethod in $learningMethods)
        {
            foreach($ensemble in $ensembles)
            {
                forEach($type in $types)
                {
                    $outFile = $task+","+$learningMethod+","+$ensemble+","+$type -replace ‘[.]’
                    $outFileName = $outFile.Replace(",","_")
                    $outFilePath = "$outPath\real\$realDataset\".Replace(".arff","")
                    $outFile = $outFilePath + "$outFileName.csv"
                    $c = $moa, """", $task, "-l (","moa.classifiers.$driftDetection", "-l", "moa.classifiers.$learningMethod", "-d (EnsembleDriftDetectionMethods -c", $ensemble, "-l", $type,"))", "-s (generators.multilabel.MultilabelArffFileStream -f ", "$realDatasetsPath\$realDataset", ") -e $performanceEvaluator  -i 100000 -f 1 -q 1", """" -join " "
                    $c = $c + " > ""$outFile""" 
                    # Write-Host $c
                    # Write-Host $outFile
                    if(!(Test-Path -Path $outFilePath )){
                        New-Item -ItemType directory -Path $outFilePath
                    }
                    
                    #check if file exists
                    If (Test-Path $outFile){
                        Write-Host "File", $outFile ,"already exist!"
                    }Else{
                        Write-Host "Starting", $outFile
                        " " | Export-Csv $outFile
                        Invoke-Expression $c
                    }

                    # if($a -contains $outFileName)
                    # {
                    #     Write-Host "Starting", $outFile
                    #     " " | Export-Csv $outFile
                    #     Invoke-Expression $c
                    # }
                }
                
            }
        }
    }
}





