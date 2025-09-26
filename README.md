# PS-ImageToPDF

## 📄 Automated Image-to-PDF Conversion Tool (PowerShell)

**`PS-ImageToPDF`** is a robust, self-contained PowerShell script designed to quickly and reliably combine multiple image files (specifically JPGs) from a directory into a single, cohesive PDF document. It is ideal for digitizing multi-page scans, notes, or documents where maintaining precise numerical order is critical.

***

## 🚀 Key Features

* **Self-Contained Setup:** Automatically checks for and installs the necessary dependency, **ImageMagick**, using the official Windows Package Manager (`winget`). No manual pre-installation steps are needed (administrator rights may be required for the installation).
* **Precise Numeric Sorting:** Files are automatically sorted using **natural numeric order** (e.g., `1.jpg`, `2.jpg`, `10.jpg`) to ensure pages are combined in the correct sequential order.
* **Recursive Processing:** Processes all `.jpg` files found in the current directory and all subdirectories.
* **Clean Output:** Utilizes the powerful `magick` utility for high-quality, reliable PDF generation.

***

## 🛠️ Usage

### Local Execution (Recommended)

1.  **Navigate:** Open PowerShell and use `cd` to navigate to the directory containing your image files.
2.  **Execute:** Run the script:
    ```powershell
    .\SinglePdfFromImages.ps1
    # or with a custom name:
    .\SinglePdfFromImages.ps1 -OutputFileName "MyBook_Final.pdf"
    ```
3.  **Result:** A new PDF file will be created in the same directory.

### Direct Execution from GitHub (Quick Run)

You can run the script directly from the repository using a single command. **Note:** This bypasses the local Execution Policy, so only run scripts you fully trust.

1.  **Navigate** to your target directory.
2.  **Run** one of the following commands:

    ```powershell
    # Use default output name (combined_transcript.pdf)
    iwr https://raw.githubusercontent.com/midhunmonachan/PS-ImageToPDF/main/SinglePdfFromImages.ps1 | iex; SinglePdfFromImages

    # Use a custom output name (e.g., Final.pdf)
    # This downloads the function, then calls it with the custom parameter
    iwr https://raw.githubusercontent.com/midhunmonachan/PS-ImageToPDF/main/SinglePdfFromImages.ps1 | iex; SinglePdfFromImages -OutputFileName 'Final.pdf'
    ```

***
