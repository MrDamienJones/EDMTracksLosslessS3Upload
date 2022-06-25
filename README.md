# EDMTracksLosslessS3Upload

EDMTracksLosslessS3Upload is a PowerShell script for uploading local lossless music files to Amazon S3.  The script includes:

- Recording outputs using the `Start-Transcript` cmdlet.
- Checking there are files in the local folder.
- Checking the files are lossless music.  
- Checking if the files are already present in S3.
- Checking if uploads have been successful.
- Moving files to different locations depending on successful or failing upload check.


This document is supported by [Uploading Music Files To Amazon S3 (PowerShell Mix)](https://www.amazonwebshark.com/uploading-music-files-to-amazon-s3-powershell-mix) on [amazonwebshark.com](https://www.amazonwebshark.com).

Please use the most recent version.  Previous versions are included for completeness.


## Prerequisites 
This document assumes the following are already in place:

- Either Windows PowerShell 5.1 or PowerShell Core 6.0 are installed on the machine containing the music files.
- The steps listed on [Prerequisites for Setting up the AWS Tools for PowerShell](https://docs.aws.amazon.com/powershell/latest/userguide/pstools-getting-set-up-prereq.html) have been completed.
- AWS Tools for PowerShell has been installed on [Windows](https://docs.aws.amazon.com/powershell/latest/userguide/pstools-getting-set-up-windows.html), [Linux or macOS](https://docs.aws.amazon.com/powershell/latest/userguide/pstools-getting-set-up-linux-mac.html).
- [Sufficient AWS Credentials](https://docs.aws.amazon.com/powershell/latest/userguide/specifying-your-aws-credentials.html) are in place to allow write access to the target S3 bucket.


## Installation

Note that these instructions are for Windows, but these steps should broadly be the same across other operating systems.

- Clone the repo.
- Make a copy of `EDMTracksLosslessS3Upload-VariablesBlank.ps1` and save it as `EDMTracksLosslessS3Upload-Variables.ps1`.  Store this in the same folder as everything else.
- Create a `.log` file for the transcript.  Add the filepath for this to the `$ExternalTranscriptPath` parameter in `EDMTracksLosslessS3Upload-Variables.ps1`.
- Access the folder where the music files are stored.  Add the filepath for this to the `$ExternalLocalSource` parameter in `EDMTracksLosslessS3Upload-Variables.ps1`.
- Access the S3 bucket that the music files will be uploaded to.  Add this to the `$ExternalS3BucketName` parameter in `EDMTracksLosslessS3Upload-Variables.ps1`.
- Access the S3 bucket prefix that the music files will be uploaded to.  Add this to the `$ExternalS3KeyPrefix` parameter in `EDMTracksLosslessS3Upload-Variables.ps1`.
- Choose the storage class for S3 to use.  Add this to the `$ExternalS3StorageClass` parameter in `EDMTracksLosslessS3Upload-Variables.ps1`.
- Create a folder that PowerShell will move successful uploads to.  Add the filepath for this to the `$ExternalLocalDestinationSuccess` parameter in `EDMTracksLosslessS3Upload-Variables.ps1`.
- Create a folder that PowerShell will move failed uploads to.  Add the filepath for this to the `$ExternalLocalDestinationFail` parameter in `EDMTracksLosslessS3Upload-Variables.ps1`.


## Usage

When everything is in place, run the PowerShell script.  PowerShell will then move through the script, producing outputs as work is completed.  A typical example of a successful transcript is as follows:

```
**********************
Transcript started, output file is C:\Users\Files\EDMTracksLosslessS3Upload.log
Counting files in local folder.
2 Local Files Found

Checking extensions are valid for each local file.
Acceptable .flac file.
Acceptable .flac file.

Checking if local files already exist in S3 bucket.
Checking S3 bucket for MarkOtten-Tranquility-OriginalMix.flac
MarkOtten-Tranquility-OriginalMix.flac does not currently exist in S3 bucket.
Checking S3 bucket for StephenJKroos-Micrsh-OriginalMix.flac
StephenJKroos-Micrsh-OriginalMix.flac does not currently exist in S3 bucket.

Starting S3 Upload Of 2 Local Files.
These files are as follows: MarkOtten-Tranquility-OriginalMix StephenJKroos-Micrsh-OriginalMix.flac

Starting S3 Upload Of MarkOtten-Tranquility-OriginalMix.flac
Starting S3 Upload Check Of MarkOtten-Tranquility-OriginalMix.flac
S3 Upload Check Success: MarkOtten-Tranquility-OriginalMix.flac.  Moving to local Success folder
Starting S3 Upload Of StephenJKroos-Micrsh-OriginalMix.flac
Starting S3 Upload Check Of StephenJKroos-Micrsh-OriginalMix.flac
S3 Upload Check Success: StephenJKroos-Micrsh-OriginalMix.flac.  Moving to local Success folder

All files processed.  Exiting.
**********************
Windows PowerShell transcript end
End time: 20220617153926
**********************
```


## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss the changes.

Please bear in mind that this script was written for my fairly precise needs.  I'm happy for this script (or any of the previous versions) to be used as a basis for similar scripts.


## License
[MIT](https://choosealicense.com/licenses/mit/)

## Credits

- README Template provided by [makeareadme.com](https://www.makeareadme.com/)