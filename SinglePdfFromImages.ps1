function SinglePdfFromImages {
    <#
    .SYNOPSIS
    Converts and combines all JPG files in a directory into a single PDF, sorted numerically.

    .DESCRIPTION
    The function finds all JPG files recursively, sorts them numerically (e.g., 1.jpg, 2.jpg, 10.jpg),
    and uses the ImageMagick utility to merge them into a single PDF file. It installs ImageMagick
    via 'winget' if necessary.

    .PARAMETER OutputFileName
    Specifies the name of the output PDF file. Defaults to 'combined_document.pdf'.
    
    .NOTES
    Requires ImageMagick. If not found, it attempts installation via 'winget', which needs
    administrative rights.
    #>
    param(
        [string]$OutputFileName = "combined_document.pdf"
    )

    $CurrentPath = (Get-Location).Path
    Write-Host "Starting JPG to PDF conversion in: $CurrentPath" -ForegroundColor Cyan

    # --- 1. CHECK AND INSTALL IMAGEMAGICK ---
    if (-not (Get-Command magick -ErrorAction SilentlyContinue)) {
        Write-Host "ImageMagick not found. Attempting install via winget..." -ForegroundColor Yellow

        if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
            Write-Error "Administrator privileges are required for installation. Please re-run as administrator."
            return
        }
        
        if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
            Write-Error "Windows Package Manager (winget) not found. Please install ImageMagick manually."
            return
        }

        try {
            & winget install ImageMagick.ImageMagick -e --silent --accept-package-agreements
            if (-not (Get-Command magick -ErrorAction SilentlyContinue)) {
                throw "'magick' command is not found in the PATH after installation."
            }
            Write-Host "ImageMagick installed successfully." -ForegroundColor Green
        } catch {
            Write-Error "ImageMagick installation failed: $($_.Exception.Message)"
            return
        }
    } else {
        Write-Host "ImageMagick found and ready." -ForegroundColor Green
    }
    
    # --- 2. FILE GATHERING AND NUMERIC SORTING ---

    $JpgFiles = Get-ChildItem -Path $CurrentPath -Filter "*.jpg" -File -Recurse | 
        Sort-Object { 
            # Implements a robust natural/numeric sort (1, 2, 10) by extracting the last number in the filename.
            if ($_.BaseName -match '\d+') { 
                [int]($matches.Values | Select-Object -Last 1) 
            } else { 
                $_.BaseName 
            }
        }

    if ($JpgFiles.Count -eq 0) {
        Write-Host "No JPG files found to convert. Exiting." -ForegroundColor Yellow
        return
    }

    # --- 3. EXECUTE CONVERSION ---
    
    $OutputFilePath = "$CurrentPath\$OutputFileName"
    $InputFiles = $JpgFiles | Select-Object -ExpandProperty FullName
    
    # Construct the argument list: [ "1.jpg", "2.jpg", "output.pdf" ]
    $ArgumentList = @($InputFiles) + @($OutputFilePath)

    Write-Host "Found $($JpgFiles.Count) files. Starting PDF conversion..." -ForegroundColor Green

    try {
        & magick $ArgumentList
        
        Write-Host "`n==========================================================" -ForegroundColor Green
        Write-Host "SUCCESS: Combined $($JpgFiles.Count) JPG files into '$OutputFileName'." -ForegroundColor Green
        Write-Host "File created at: $OutputFilePath" -ForegroundColor Green
        Write-Host "==========================================================" -ForegroundColor Green
        
    } catch {
        Write-Error "PDF Conversion failed: $($_.Exception.Message)"
    }
}

# --- EXECUTION BLOCK ---
SinglePdfFromImages -OutputFileName "combined_transcript.pdf"
