##################################
####### EXTERNAL VARIABLES #######
##################################


#Load External Variables Via Dot Sourcing
. .\EDMTracksLosslessS3Upload-Variables.ps1

#Start Transcript
Start-Transcript -Path $ExternalTranscriptPath -IncludeInvocationHeader


###############################
####### LOCAL VARIABLES #######
###############################


#Get count of items in $ExternalLocalSource
#Get list of filenames in $ExternalLocalSource
$LocalSourceCount = (Get-ChildItem -Path $ExternalLocalSource | Measure-Object).Count

#Get list of extensions in $ExternalLocalSource
$LocalSourceObjectFileExtensions = Get-ChildItem -Path $ExternalLocalSource | ForEach-Object -Process { [System.IO.Path]::GetExtension($_) }

#Get list of filenames in $ExternalLocalSource
$LocalSourceObjectFileNames = Get-ChildItem -Path $ExternalLocalSource | ForEach-Object -Process { [System.IO.Path]::GetFileName($_) }

#Counter for successful uploads
$UploadCountSuccess = 0

#Counter for failed uploads
$UploadCountFail = 0


##########################
####### OPERATIONS #######
##########################


#Check there are files in local folder.
Write-Output "Counting files in local folder."

#If local folder less than 1, output this and stop the script.  
If ($LocalSourceCount -lt 1) {
    Write-Output "No Local Files Found.  Exiting."
    Start-Sleep -Seconds 10
    Stop-Transcript
    Exit
}
#If files are found, output the count and continue.
Else {
    Write-Output "$LocalSourceCount Local Files Found"          
}


#Check extensions are valid for each file.
Write-Output " "
Write-Output "Checking extensions are valid for each local file."

ForEach ($LocalSourceObjectFileExtension In $LocalSourceObjectFileExtensions) {

    #If any extension is unacceptable, output this and stop the script. 
    If ($LocalSourceObjectFileExtension -NotIn ".flac", ".wav", ".aif", ".aiff") {
        Write-Output "Unacceptable $LocalSourceObjectFileExtension file found.  Exiting."
        Start-Sleep -Seconds 10
        Stop-Transcript
        Exit
    }
    #If extension is fine, output the extension for each file and cotinue.
    Else {
        Write-Output "Acceptable $LocalSourceObjectFileExtension file."
    }
}


#Check if local files already exist in S3 bucket.
Write-Output " "
Write-Output "Checking if local files already exist in S3 bucket."

#Do following actions for each file in local folder
ForEach ($LocalSourceObjectFileName In $LocalSourceObjectFileNames) {

    #Create S3 object key using $ExternalS3KeyPrefix and current object's filename
    $LocalSourceObjectFileNameS3Key = $ExternalS3KeyPrefix + $LocalSourceObjectFileName 

    #Output that S3 upload check is starting
    Write-Output "Checking S3 bucket for $LocalSourceObjectFileName"
      
    #Attempt to get S3 object data using $LocalSourceObjectFileNameS3Key
    $LocalSourceObjectFileNameS3Check = Get-S3Object -BucketName $ExternalS3BucketName -Key $LocalSourceObjectFileNameS3Key

    #If local file found in S3, output this and stop the script.
    If ($null -ne $LocalSourceObjectFileNameS3Check) {
        Write-Output "File already exists in S3 bucket: $LocalSourceObjectFileName.  Please review.  Exiting."
        Start-Sleep -Seconds 10
        Stop-Transcript
        Exit
    }
    #If local file not found in S3, report this and continue.
    Else {
        Write-Output "$LocalSourceObjectFileName does not currently exist in S3 bucket."
    }
}


#Output that S3 uploads are starting - count and file names
Write-Output " "
Write-Output "Starting S3 Upload Of $LocalSourceCount Local Files."
Write-Output "These files are as follows: $LocalSourceObjectFileNames"
Write-Output " "


#Do following actions for each file in local folder
ForEach ($LocalSourceObjectFileName In $LocalSourceObjectFileNames) {

    #Create S3 object key using $ExternalS3KeyPrefix and current object's filename
    $LocalSourceObjectFileNameS3Key = $ExternalS3KeyPrefix + $LocalSourceObjectFileName 

    #Create local filepath for each object for the file move
    $LocalSourceObjectFilepath = $ExternalLocalSource + "\" + $LocalSourceObjectFileName

    #Output that S3 upload is starting
    Write-Output "Starting S3 Upload Of $LocalSourceObjectFileName"

    #Write object to S3 bucket
    Write-S3Object -BucketName $ExternalS3BucketName -File $LocalSourceObjectFilepath -Key $LocalSourceObjectFileNameS3Key -StorageClass $ExternalS3StorageClass

    #Output that S3 upload check is starting
    Write-Output "Starting S3 Upload Check Of $LocalSourceObjectFileName"
      
    #Attempt to get S3 object data using $LocalSourceObjectFileNameS3Key
    $LocalSourceObjectFileNameS3Check = Get-S3Object -BucketName $ExternalS3BucketName -Key $LocalSourceObjectFileNameS3Key

    #If $LocalSourceObjectFileNameS3Key doesn't exist in S3, move to local Fail folder.
    If ($null -eq $LocalSourceObjectFileNameS3Check) {
        Write-Output "S3 Upload Check FAIL: $LocalSourceObjectFileName.  Moving to local Fail folder"
        $UploadCountFail = $UploadCountFail + 1
        Move-Item -Path $LocalSourceObjectFilepath -Destination $ExternalLocalDestinationFail
    }
    #If $LocalSourceObjectFileNameS3Key does exist in S3, move to local Success folder.
    Else {
        Write-Output "S3 Upload Check Success: $LocalSourceObjectFileName.  Moving to local Success folder"
        $UploadCountSuccess = $UploadCountSuccess + 1
        Move-Item -Path $LocalSourceObjectFilepath -Destination $ExternalLocalDestinationSuccess           
    }
}


#Stop Transcript
Write-Output " "
Write-Output "$LocalSourceCount files found.  $UploadCountSuccess successful uploads.  $UploadCountFail failed uploads"
Write-Output "All files processed.  Exiting."
Start-Sleep -Seconds 10
Stop-Transcript