# degooglepdf
Download view only protected files from Google Drive. Optimized for heavy files.

## Howto
1. Open the desired file at Google Drive in your web browser
2. Open the browser's JS console and copy-paste the script from `downloader.js` 
3. Watch the script scroll through the document and wait for the download
4. Run `mkpdf.sh [file]` to create a PDF file

## Technical details
The browser part `downloader.js` automatically scrolls the displayed PDF to makes sure all pages are being loaded.
Then the pages (stored in base64-encoded PNG format) will be archived and provided as download.

The shell part `mkpdf.sh` extracts the images from the archive, processes and then combines them to a proper PDF file.

## Application
Someone may have uploaded a PDF file to their Google Drive, but set it to view-only mode. This constellation is problematic in several situations:
* Offline viewing
* Viewing without Google tracking
* Permanent archival
* Uploader is gatekeeping content they didn't create

## Inspiration
* Original idea: https://codingcat.codes/2019/01/09/download-view-protected-pdf-google-drive-js-code/
* Browser part based on: https://github.com/zeltox/Google-Drive-PDF-Downloader
* Shell part based on: https://github.com/zeltox/Google-Drive-PDF-Downloader/issues/10#issuecomment-862705248

## Requirements
* Webbrowser with JS console
* sed
* ImageMagick (`convert`)
