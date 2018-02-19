---
title: "Web map printing solutions"
lang: en
author: Marc Monnerat
date: Februar, 9th 2018
numbersections: true
output:
  pdf_document:
    toc: true
    number_sections: true
link-citations: true
    
header-includes:
  - \usepackage{xcolor}
  - \definecolor{foo}{HTML}{2A5DB0}
  - \hypersetup{colorlinks=false,
            colorlinks=true,
            linkcolor=blue,
            filecolor=magenta,      
            urlcolor=foo,
            allbordercolors={0 0 0}, 
            pdfborderstyle={/S/U/W 1}} 
---






**Abstracts**


_This document explores various alternatives for generating suitable document for printing to be used in a web mapping application._


Current situation
=================

The swiss federal geoportal [map.geo.admin.ch](https://map.geo.admin.ch) uses a customed developped server-side printing application ([service-print]((https://github.com/geoadmin/service-print)) based on a [forked](https://github.com/geoadmin/mapfish-print/tree/2.1.x_geoadmin3) of [MapFish Print v2](http://www.mapfish.org/doc/print/) and a [Python Flask](http://flask.pocoo.org/) application to allow for multiserver use and multipage PDF document generation. Currently, it runs in a Docker auto-scalling group, with one server at night and two during the day.

## Capabilities

* Printing all 2D layers from map.geo.admin.ch, including import GPX/KML and most WMTS/WMS 
* Generating an A4/A3 PDF 1.3 at 150 DPI (not a technical limitation)
* Generating a multipage PDF for Zeitreise (one year per page)
* Synchronous print for single page, asynchronous for multipage
* 247'198 PDF page generated the last 90 days (500-5'000 per day) and 1'383 multipage print (0 to 50 per day)
* Dockerized application running on a auto-scaling cluster (time-based)
* Using an extend version of the standar print procotol used by GeoMapFish/GeoExt/GeoServer
* Merging legends of complex layers (geology) to the end of the PDF document.


## Shortcomings

* Print only 2D map
* Imported WMS and WMTS layers won't be printed if remote server do not support LV95 projection (EPSG:2056).
* WMTS layers are added as indivual tiles to PDF, for every layers (way too much information if some layer are fully opaque) 232 MB for Zeitreise only, 376MB (25 pages)
* Very limited support for Vector. Luckily, imported vector do not support many style
* Symbols size for Raster layer (Vector symbol are adapted to print resolution)
* MapFish v2 is not developped anymore. swisstopo is patching a fork.

## Performances

The 95th percentile for all print jobs are between 3.7 and 5.0 s (only time for generation, without download)

!["90th, 95th and 99th percentile of created.json"](img/mf-v2-timegenerated-percentile.png){ width=250px }\

https://kibana.bgdi.ch/goto/3566fae450682eea244826f2ec49e477

Printing a [standard A4 landscape page at 1:25'000](https://github.com/procrastinatio/mapfish-print-examples/blob/master/specs/lv95_versoix_25000_simple.json)

Generation time (POST to response): 1.14 ± 0.19 s (n=256, every 5 minutes)


Error rate: last month 1'082 errors for 97'988 success (about 1.09%)


What is printing?
================

In the context on web mapping application, printing is generally seen as as a way to generate a file, like an image or a PDF, suitable to be sent to an office printer.
But even in this context, some people may primarly interested in the PDF file, not a paper impression. This is a huge difference.

This is a bit restrictive, as PDF file may be also saved for offline use. The advent of 3D data and application, also brings new possiblities and challenges.



What should be printed?
======================

Since its inception, maps have been decorated with more or less useful features.

!["Îles du Levant - Portulan Benincase 1466 (BNF)"](img/659px-Île_du_Levant._Portulan._Benin‌casa._1466.png){width=250px}\




Map data
--------

### 2D

#### Raster
Source are generally satelite/aerial imagery, and scan of legacy maps (historical maps)
Served usually as WMS and WMTS

#### Vector
Vector are now a few layer as GeoJSON, and imported GPX and KML

Question: rasterize data to print seems obvious, but it is definitely a loss of information.

  * Sync between server tools and

### 3D

* To convert to 2D or not? If so, rasterize or not?
* Render as 3D (export ?) for use with 3D printer or anything else (virtual world, KML, etc.)


### Time (4th dimension)

* Data changing over time (Zeitreise)
* Position changing over time (fly path)

How to render: multipage, movie?

Another challenge: mixing data with different rate of change and/or lacking data.


Non map data
------------

Non-map data provide useful informations

### Logo and corporate identity

Important or not, it gives a professinal look

### Disclaimer/copyright

Providing a clear delimitation between data which are from the geoportal and which data are 3rd party. Some remainder of copyright use.

### Title, note by user

Provide the user to give its work a title and notes

###Legend to the map

Some data are more complexe, and need an explanation. It could be as _simple_ as displaying the classification to a full grown geological explanation of the map.
 
### Scale, scalebar, norh arrow
Useful information for the orientation, and when hiking.

### QRcode, shortlink
Useful to recreate the map in the application online

### Table data (reporting)
Some infomarmation be easier to display as table. Not used in map.geo.admin.ch, but proposed by some printing application

### File metadata (if applicable)
Metadata are something useful for search engine if the main goal is to store the PDF.

### Grid
Various geographical grids, for orientation and use with GPS.

### Information on elements displayed
Could be the location of a search term in the simpliest form or additional information on a highlighted object (tooltips,etc.)





Tools, building bricks
======================


Browser
-------

### Rasterizing

HTML5, _toBlob()_, _toDataURL()_



### Export canvas to a vector format

As SVG or PDF (what libraries?)


Server-side rendering of GIS data
---------------------------------

Either vector or raster.


### Rasterizing of canvas

Challenges:
* Pretty slow
* How do you know the map is fully loaded and rendered?

#### SlimerJS (Firefox based)
* WebGL
* Not truely headless (?)

#### PhantomJS (WebKit based)
* No WebGL support

### Rasterizing/exporting data

* Mapserver
* Mapnik
* GDAL/Rasterio
* OWSlib

Print server
------------
* Mapfish print
* Geoserver print


Integrated print tools
----------------------

Need more testing...

* QGIS print
* ArcGis print
 

Other consideration
===================

* Scale and resolution of result
* WebGL
* Vectors in PDF
* PDF/A
* Legacy client (provide raster tiles)
* Vector style definition
* Mashup with other sorts of infos (diagram, plot, data tables)
* Movie (Zeitreise, Fly along path, etc.)
* Externalize compute power on client
* Performance (sync or async printing)
* WYSIWIG (symbol scaling, which LK to use)
* Grid
* Projection issue (projection of the data, target projection) --> deformation, scale, etc.
* Rasterize as a data protection tool
* High contrast map
* Export to other format
* Use on smartphone and tablet
* Ineractive application/API
* Multserver use, autoscaling, etc.
* KMZ with local file
* GeoPDF


Approaches
==========

Client side printing
--------------------
* WYSIWIG
* No control of resolution


Server side
-----------

Mixed approach
--------------


Integrated approach
-------------------



**Colophon**

This document was created with [pandoc](http://pandoc.org), with the following commands:
   

    $ pandoc -f markdown --latex-engine=xelatex   --number-sections \ 
      --variable mainfont="Gentium"   -V fontsize=10pt   "README.md" \
      --toc -o "web-map-printing.pdf"




