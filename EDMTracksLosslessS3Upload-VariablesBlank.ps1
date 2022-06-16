##################################
####### EXTERNAL VARIABLES #######
##################################

#The local file path for the transcript file
#E.g. "C:\Users\Files\"
$ExternalTranscriptPath =

#The local file path for objects to upload to S3
#E.g. "C:\Users\Files\"
$ExternalLocalSource =

#The S3 bucket to upload objects to
#E.g. "my-s3-bucket"
$ExternalS3BucketName =

#The S3 bucket prefix / folder to upload  objects to (if applicable)
#E.g. "Folder\SubFolder\"
$ExternalS3KeyPrefix =

#The S3 Storage Class to upload to
#E.g. "GLACIER"
$ExternalS3StorageClass =

#The local file path for moving successful S3 uploads to
#E.g. "C:\Users\Files\"
$ExternalLocalDestinationSuccess =

#The local file path for moving failed S3 uploads to
#E.g. "C:\Users\Files\"
$ExternalLocalDestinationFail =