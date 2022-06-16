#Set Variables
$LocalSource = "C:\Users\Files\"
$S3BucketName = "my-s3-bucket"
$S3KeyPrefix = "Folder\SubFolder\"
$S3StorageClass = "GLACIER"


#Upload File To S3
Write-S3Object -BucketName $S3BucketName -Folder $LocalSource -KeyPrefix $S3KeyPrefix -StorageClass $S3StorageClass