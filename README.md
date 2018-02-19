---
title: "Web map printing solutions"
lang: en
author: Marc Monnerat
date: Februar, 9th 2018
output:
  pdf_document:
    toc: false
    number_sections: false
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






Abstracts
=========

This document explores various alternatives for generating suitable document for printing to be used in a web mapping application


Current situation
=================

The swiss federal geoportal [map.geo.admin.ch](https://map.geo.admin.ch) uses a customed developped server-side printing application ([service-print]((https://github.com/geoadmin/service-print)) based on a [forked](https://github.com/geoadmin/mapfish-print/tree/2.1.x_geoadmin3) of [MapFish Print v2](http://www.mapfish.org/doc/print/) and a [Python Flask](http://flask.pocoo.org/) application to allow for multiserver use and multipage PDF document generation. Currently, it runs in a Docker auto-scalling group, with one server at night and two during the day.

## Capabilities

* Printing all 2D layers from map.geo.admin.ch, including import GPX/KML and most WMTS/WMS 
* Generating an A4/A3 PDF 1.3 at 150 DPI (not a technical limitation)
* Generating a multipage PDF for Zeitreise (one year per page)
* Synchronous print for single page, asynchronous for multipage
* 247'198 PDF page generated the last 90 days (1'000-5'000 per day) and 1'383 multipage print (0 to 50 per day)
* Dockerized application running on a auto-scaling cluster (time-based)
* Using an extend version of the standar print procotol used by GeoMapFish/GeoExt/GeoServer


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

Generation time (POST to response): 1.02 ± 0.11 s


Error rate?



What should be printed?
======================

Map data
--------

### 2D

* Raster (WMS and WMTS)
* Vector (GeoJSON, GPX, KML)
  * Rasterize or not
  * Sync between server tools and

### 3D


### Time

How to render: multipage, movie?

* Data changing over time (Zeitreise)
* Position changing over time (fly path)

Non map data
------------
* Logo and corporate design
* Disclaimer/copyright
* Title, note by user
* Legend to the map
* Scale, scalebar, norh arrow
* QRcode
* Table data (reporting)
* File metadata (if applicable)





Tools, building bricks
======================

Server-side rendering of GIS data, either vector or raster.


Rasterizing of canvas
---------------------

* SlimerJS (Firefox based)
* PhatomJS (WebKit based)


* Mapserver
* Mapnik
* GDAL/Rasterio
* OWSlib

Integrated print tools
----------------------

* QGIS print
* Mapfish print
* Geoserver print
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



Colophon
--------

This document was created with [pandoc](http://pandoc.org), with the following commands:
   

    $ pandoc -f markdown --latex-engine=xelatex   --number-sections \ 
      --variable mainfont="Gentium"   -V fontsize=10pt   "README.md" \
      --toc -o "web-map-printing.pdf"




