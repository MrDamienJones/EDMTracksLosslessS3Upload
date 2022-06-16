#Load Variables Via Dot Sourcing
. .\EDMTracksLosslessS3Upload-Variables.ps1


#Upload File To S3
Write-S3Object -BucketName $ExternalS3BucketName -Folder $ExternalLocalSource -KeyPrefix $ExternalS3KeyPrefix -StorageClass $ExternalS3StorageClass