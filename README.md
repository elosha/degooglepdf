# degooglepdf
Download **view only protected** PDF files from Google Drive. Optimized for **large** and **high quality** files.

## Application
Someone may have uploaded a PDF file to their Google Drive, but set it to view-only mode. This is problematic in several totally legitimate situations:
* Offline viewing
* Viewing without Google tracking
* Permanent archival
* Uploader is gatekeeping content they didn't create

## Requirements
* Webbrowser with JS console (Mozilla, Webkit-based, all fine)
* Unix-like userland (`bash`, `sed`)
* ImageMagick (`convert`)
Hint: GNU/Linux users have that, Mac users just need to install ImageMagick via MacPorts or Homebrew.

## Howto
1. Open the desired file at Google Drive in your web browser
2. Open the browser's JS console and copy-paste the script from `downloader.js`
3. Watch the script scroll through the document and wait for the download
4. Run `mkpdf.sh [file]` to create a PDF file

## Hints

### Incomplete PDFs may occur

Check resulting PDF files for completeness. This could happen if pages take too long to load on your internet connection. If in doubt, re-run the downloader again in the same session to load the missing pages.

### Fix up the pages before creating a PDF

5. Manipulate the images in the folder that matches your file
6. Run `mkpdf.sh [file]` again and press "y" when asked to use those existing files

### Try other page resolutions
Tweak the JS variable `devicePixelRatio` for optimum page sizes. Try values 1, 2, 3 or 4. Which is the best setting? That depends on your actual screen dpi, browser window size and document quality.

But keep in mind, printing resolution has technical limits, so don't set it too high. Zoom in and trust your eye when the result is good enough: Many scans were scanned in a higher resolution that they were originally printed in (usually 300dpi). ;)

## Technical details
The browser part `downloader.js` first simulates a high DPI display to request high resolution pages.
It then automatically scrolls the displayed PDF to make sure all pages are being loaded.
Then the pages (stored as JPEGs in base64-encoded format) will be archived and provided as download.

The bash script `mkpdf.sh` extracts all images from the archive, processes and then combines them to a proper PDF file.

## Inspiration
* Original idea: https://codingcat.codes/2019/01/09/download-view-protected-pdf-google-drive-js-code/
* Browser part based on: https://github.com/zeltox/Google-Drive-PDF-Downloader
