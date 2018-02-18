---
title: "Web map printing"
lang: en
author: Marc Monnerat
date: 9 février 2018
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


Web map printing solutions
==========================


Abstracts
---------

This document explores varous alternative for generating suitable document for printing
to be used in a web mapping application


Current situation
-----------------

The swiss federal geoportal [map.geo.admin.ch](https://map.geo.admin.ch) uses a customed developped server-side printing application ([service-print]((https://github.com/geoadmin/service-print)) based on a [forked](https://github.com/geoadmin/mapfish-print/tree/2.1.x_geoadmin3) of [MapFish Print v2](http://www.mapfish.org/doc/print/)
and a [Python Flask](http://flask.pocoo.org/) application to allow for multiserver use and multipage PDF document generation. Currently, it runs in a Docker auto-scalling group, with one server at night and two during the day.

### Capabilities

* Printing all 2D layers from map.geo.admin.ch, including import GPX/KML and WMTS/WMS if projection LV95 is supported
* Generating a PDF 1.3 at 150 DPI (not a technical limitation)
* Generating a multipage PDF for Zeitreise (one year per page)
* Synchrone print: file generated in 2-30 seconds
* 247'198 PDF page generated the last 90 days (1'000-5'000 per day) and 1'383 multipage print (0 to 50 per day)
* Dockerized, multi-server, auto-scaling (time-based)
* Printing A4 and A4 at 150 dpi (300 DPI is possible)

### Shortcomings

* WMTS as indivual tiles, for every layers (way too much information if some layer are fully opaque) 232 MB for Zeitreise only, 376MB (25 pages)
* Very limited support for Vector
* Symbols size for Raster layer (Vector symbol are adapted to print resolution)
* Layer which do not support LV95 are not printed

### TODO

Some metrics on performaces



!["90th, 95th and 99th percentile of created.json"](img/mf-v2-timegenerated-percentile.png){ height=250px }\

https://kibana.bgdi.ch/goto/3566fae450682eea244826f2ec49e477

Printing a [standard A4 landscape page at 1:25'000](https://github.com/procrastinatio/mapfish-print-examples/blob/master/specs/lv95_versoix_25000_simple.json)

Generation time (POST to response): 1.02 ± 0.11 s





Type of data
------------

* Raster (WMS and WMTS)
* Vector (GeoJSON, GPX, KML)
  * Rasterize or not
  * Sync between server tools and
* 3D

Approaches
-----------

### Client side printing

### Server side
### Mixed approach


Other consideration
-------------------

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
* Projection issue (projection of the data, target projection)
* Rasterize as a data protection tool
* High contrast map
* Export to other format
* Use on smartphone and tablet
* Ineractive application/API
* Mutliserver use

Client-side

* WYSIWIG
* No control of resolution

Rasterizing

* SlimerJS
* PhatomJS (WebKit based)

* Mapserver
* Geoserver
* Mapnik

Tools
-----

* QGIS print
* Mapfish print
* Geoserver print
* ArcGis print
* Mapnik
* Mapserver

#<i class="fa fa-map" aria-hidden="true"></i> Colophon

This document was created with [pandoc](http://pandoc.org), with the following commands:
   

    $ pandoc -f markdown --latex-engine=xelatex   --number-sections \ 
      --variable mainfont="Gentium"   -V fontsize=10pt   "README.md" \
      --toc -o "web-map-printing.pdf"
