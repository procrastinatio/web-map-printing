---
title: "Web map printing solutions"
subtitle:
    - This is a test for using YAML for metadata.
lang: en
keywords:  "web mapping, printing, pdf, canvas, webgl"
author:
   - Marc Monnerat

papersize: a4
numbersections: true
fontsize: 10pt
mainfont: "Noto Serif"
monofont: "Noto Mono"
monofontoptions: [ Scale=0.7, Colour=AA0000, Numbers=Lining, Numbers=SlashedZero, ]
toc-depth: 3
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


_This document explores various alternatives for generating suitable document for printing to be used in a web mapping application. _


!["XEROX Parc Map Viewer"](img/xerox_parc_map_viewer_june_1993.jpg){ width=250px }\



Current situation
=================

The swiss federal geoportal [map.geo.admin.ch](https://map.geo.admin.ch) uses a customed developped server-side printing application ([service-print]((https://github.com/geoadmin/service-print)) based on a [forked](https://github.com/geoadmin/mapfish-print/tree/2.1.x_geoadmin3) of [MapFish Print v2](http://www.mapfish.org/doc/print/) and a [Python Flask](http://flask.pocoo.org/) application to allow for multiserver use and multipage PDF document generation. Currently, it runs in a Docker auto-scalling group, with one server at night and two during the day.

## Capabilities

* Printing all 2D layers from map.geo.admin.ch, including import GPX/KML and most WMTS/WMS 
* Generating an A4/A3 PDF 1.3 at 150 DPI (not a technical limitation)
* Generating a multipage PDF for Zeitreise (one year per page, about 20 pages)
* Synchronous print for single page, asynchronous for multipage
* 247'198 PDF page generated the last 90 days (500-5'000 per day) and 1'383 multipage print (0 to 50 per day)
* Dockerized application running on a auto-scaling cluster (time-based)
* Using an extend version of the standar print procotol used by GeoMapFish/GeoExt/GeoServer
* Merging legends of complex layers (geology) to the end of the PDF document.


## Shortcomings

* Print only 2D map
* Imported WMS and WMTS layers won't be printed if remote server do not support LV95 projection (EPSG:2056). These layers may be still displayed in the application
* WMTS layers are added as indivual tiles to PDF, for every layers (way too much information if some layer are fully opaque) 232 MB for Zeitreise only, 376MB (25 pages)
* Very limited support for Vector. Luckily, imported vector do not support many styles.
* Symbols size for Raster layer (Vector symbol are adapted to print resolution)
* MapFish v2 is not developped anymore. swisstopo is patching a fork.
* Support for retry and multiserver is sub-optimal.

## Performances

### Averall print jobs

The 95th percentile for all print jobs are between 3.7 and 5.0 s (only time for generation, without download)

!["90th, 95th and 99th percentile of created.json"](img/mf-v2-timegenerated-percentile.png){ width=250px }\

https://kibana.bgdi.ch/goto/3566fae450682eea244826f2ec49e477

Error rate: last month 1'082 errors for 97'988 success (about 1.09%)

### Simple print job (cron)

Printing a [standard A4 landscape page at 1:25'000](https://github.com/procrastinatio/mapfish-print-examples/blob/master/specs/lv95_versoix_25000_simple.json)

Generation time (POST to json response): 1.21 ? 0.05 s (n=4578, every 5 minutes)

Errors: 22 out of 4578 jobs (0.48%) 



### Pingdom

Same spec file as above sent every 5 minutes from Pingdom

692 ms average response time (time to get JSON response)
1.17 s max response time
7 outages totalising 35 minutes
uptime 99.83%



What is printing?
================

In the context on web mapping application, printing is generally seen as as a way to generate a file, like an image or a PDF, suitable to be sent to an office printer.
But even in this context, some people may primarly interested in the PDF file, for instance for archiving or offile use, not a paper impression.

The advent of 3D data and 3D capable application as well as the generalisation of vector data also brings new possiblities and challenges for printing.



What should be printed?
======================

Since their inceptions, maps have been decorated with more or less useful features.

!["Îles du Levant - Portulan Benincase 1466 (BNF)"](img/Ile_du_Levant_Portulan_Benincasa_1466.png){width=250px}\




Map data
--------

In the GIS world, 

### 2D

#### Raster
Source are generally satelite/aerial imagery, and scan of legacy (printed) maps (historical maps)
Served usually served as OGC WMS and WMTS

#### Vector

In [map.geo.admin.ch][], there are now about 22 vector layers, loaded as GeoJSON (_e.g._ [Water temperature river](https://map.geo.admin.ch/?lang=en&topic=ech&bgLayer=ch.swisstopo.pixelkarte-farbe&layers=ch.bafu.hydroweb-messstationen_temperatur). Vector files like GPX and KML may also be imported.

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

Providing a clear delimitation between data which are from the geoportal and which data are 3rd party. Some reminder of copyright use.


### Title, note by user

Provide the user to give its work a title and notes


### Legend to the map

Some data are more complexe, and need an explanation. It could be as _simple_ as displaying the classification or add a complexe an lengthy explanation in the case of a geocolical map to the generated PDF.
 
 
### Scale, scalebar, north arrow

Useful information for the orientation, and when hiking.


### QRcode, shortlink

Useful to recreate the map in the application online

### Table data (reporting)

Some information be easier to display as table. Not used in [map.geo.admin.ch][], but proposed by some printing application (


### File metadata (if applicable)

Metadata are something useful for search engine if the main goal is to store the PDF.


### Grid

Various geographical grids, for orientation and use with GPS.


### Information on elements displayed

Could be the location of a search term in the simpliest form (Google Map-like marker) or additional information on a highlighted object (tooltips,etc.)



Tools, building bricks
======================


Browser
-------


### @media print

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

#### Mapserver

[Cartographical Symbol Construction with MapServer][]

Mapserver is hower able to render to vector format like SVG and PDF (when using [PDFlib][])

#### Mapnik

Map Markup Language file) is a YAML or JSON
Mapnik XML, Cascadenik MML, Carto MML 
[Mapnik][] was the original tool to generate [OSM][] tiles for the so-called slippy map. Mapnik is also able to genrate PDF when compiled with [Cairo][].

It uses [Mapnik XML][] as configuration, also for styles. [Cascading Sheets Of Style for Mapnik][Cascadenik] aka [Cascadenik][] is a preprocessor for Mapnik, using cascading style sheet for map definition.
 
[CartoCSS] is a language for map design. It is similar in syntax to CSS, but builds upon it with specific abilities to filter map data and by providing things like variables. It targets the Mapnik renderer and is able to generate Mapnik XML or a JSON variant of Mapnik XML.

It is now deprecated ([The end of CartoCSS]) by its parent company, [Mapbox][].

#### Tileserver GL

A [Mapbox Style Specification][] is a document that defines the visual appearance of a map: what data to draw, the order to draw it in, and how to style the data when drawing it. A style document is a JSON object with specific root level and nested properties. This specification defines and describes these properties.


Vector and raster maps with GL styles. Server side rendering by Mapbox GL Native. Map tile server for Mapbox GL JS, Android, iOS, Leaflet, OpenLayers, GIS via WMTS, 
[Tileserver GL]


### Other tools

#### GDAL/Rasterio

#### OWSlib



Print server
------------

### Mapfish print

The purpose of [Mapfish Print 3] is to create reports that contain maps (and map related components) within them.
The project is a Java based servlet/library/application based on the mature [Jasper Reports Library][].

### Geoserver print

The [Geoserver Printing Module][] allows easy hosting of the Mapfish printing service within a GeoServer instance. The Mapfish printing module provides an HTTP API for printing that is useful within JavaScript mapping applications. User interface components for interacting with the print service are available from the Mapfish and GeoExt projects.

Integrated print tools
----------------------

Need more testing...


### QGIS print

### ArcGis print

ArcGIS Enterprise includes a geoprocessing service called PrintingTools. Web applications invoke the PrintingTools service and get a printable document in return (see [Printing in Web application][]):


 

Other considerations
====================

## Scale and resolution

Are scale and print quality of the result important? Difference in resolution may be important between screen and paper.


## WebGL


## Vectors in PDF

Must vector layers rendered as vector or must be rasterized?


## Need for User defined style

With vector data, it is easy to apply user defined style, though defining styles for complexes dataset is a daring undertaking.


## PDF standard

What PDF version? Support of PDF/2 or PDF/A? No, open source library available. See [PDFlib][]. Most client-side libraries are PDF 1.3 (Acrobat 4.x) capable.


## Legacy client

For some legacy client, we must eventually also provide raster tiles (from vector layer)?


## Vector style definition

How are the styles for vector layer defined? Where? And how it is applied?

Currently, all style are defined in Mapserver's [Mapfile definition](https://github.com/geoadmin/wms-mapfile_include).


## Complexe symbols

Especially complexe labels placement is hard (what to render, at what scale, collision avoidance)


## Mashup

Maps should be mashed up with other sorts of infos (diagram, plot, data tables)


## Movie

Zeitreise, Fly along path, etc.


## Compute power

Externalize compute power on client or not?


## Performance

Synchronous or asynchronous printing


## WYSIWIG

Symbol scaling, which LK to use, grid display, etc.


## Grid

Grid for various projection system


## Projection issue

One selling point of vector tiles and 3D is that 2D in only a special case when pitch is 0 (or 90?). But the 3D world is a WGS1984 only world, which translate in the infamous [Equirectangular (or plate carr?e)projection ](http://proj4.org/projections/eqc.html).
Using the same projection for printing as in the browser (projection of the data, target projection). When using a Webmercator, deformation, scale, with LK


## Rasterize as a data protection tool

Rasterizing vector data was also a way to _protect_ the more valuable original vector datasets (_e.g._WMS).


## Export to other format

Only PDF, os as image


## Use on smartphone and tablet
Client only priting on small scale and/or less powerfull devices is challenging to get nice printed results.

## Printing API

Provinding an API for 3rd party


## Multiserver use, autoscaling, etc.

Most print server are meant to run on a single machine.


## KMZ with local file


## GeoPDF


Approaches
==========

CSS: @media print
-----------------

[\@media in MDN web docs](https://developer.mozilla.org/de/docs/Web/CSS/@media)

 
> The @media CSS at-rule associates a set of nested statements, in a CSS block
> that is delimited by curly braces, with a condition defined by a media query.
> The @media at-rule may be use



### Browser print function

Easiest solution, used by Google Map, Bing Map. WYSIWIG

All it takes is to define a CSS stylesheed for print (for inspiration [Paper CSS][]).

A CSS at-rule [\@page](https://drafts.csswg.org/css-page-3/) to define page-specific rules when printing web pages, such as margin per page and page dimensions. Not supported by Safari (all versions). 


    page[size="A4"][layout="landscape"]  {
        width: 21cm;
        height: 29.7cm; 
    }

But, as we do not have any influence on the size of the image generated in the browser, we have to make trade off in term of scale, print resolution and image aspect ratio.
To print at 150dpi on A4, we need an image of 1750x1250 pixel approximatly, which is OK on a deskop computer, but probably not on a laptop or tablet.

Canvas of 650x450px not fitting an A4 page

!["Too small image for A4"](img/browser-print-image-650x450.png)\

Canvas of 1050x750px fitting an A4 page

!["Perfect match for A4"](img/browser-print-image-1050x750.png)\

A bigger display will be cropped

With a map covering the whole screen (`width: 100%; height: 100%`), the challenge is to get an absolute width and height, to be fitted in the print page.

Challenges

* Print to many different paper sizes and orientations
* Make browser recognize size and orientation
* Print quality, on smaller display _e.g._ Laptop with 14" screen

Works well on Chrome, Firefox and Opera (only 2D for the latter), when preview is activated.

[Live demo](https://www.procrastinatio.org/ol-cesium/full.html)

### PDF generation in client

[PDF.js] (Open Source) and [jsPDF] (commercial), [PSPDFKit] (comercial)


### Rendering PDF on a server

[Generating PDF from XML/HTML and CSS - A tutorial and showcase for CSS Paged Media][Print-CSS]

[Print CSS rocks](https://github.com/zopyx/print-css-rocks)


Rendering HTML page to PDF using the full CSS Page media standard with commercial tool like [PDFreactor][], [PrinceXML][], [Antennahouse CSS Formatter][] or [DocRaport][]. Some are based on [XSL-FO][] other on [Webkit][].


Export canvas as image
----------------------

### Export canvas as image


Printing in 2D

!["<ctrl-P> 2D"](img/ctrl-print-2d.png)\

Printing in 3D

!["<ctrl-P> 2D"](img/ctrl-print-3d.png)\


[Live demo](https://www.procrastinatio.org/ol-cesium/). This is [OL-Cesium][], you may toggle 2D/3D.


### Export image + popup


Create a simple page in a new popup window, with additional elements, and copy the map as an image
HTML template for printing

### Better resolution

An approach to gain control over the generated image is to recreate a hidden canvas to generate an image that suit the need. This is the approach of the "High DPI print" for Mapbox ([print-maps][]).

Maybe OK, for simple 2D applications, more difficult for complexe 3D applications with user defined content. What about performance ?



### Examples

[Browser print](demo/a4-fitted-size-landscape.html)

[Browser print](demo/a4-fixed-size-landscape.html)

[Mapbox GL](https://www.procrastinatio.org/print-maps/) using [print-maps](https://github.com/mpetroff/print-maps) by Matthew Petroff.

[Cesium and swisstopo terrain](https://codepen.io/procrastinatio/full/c9fbe1b5f412adac74ee0944fd975511/)

[OL-Cesium](https://www.procrastinatio.org/ol-cesium/) in 2D and 3D mode

!["Too small image for A4"](img/ol4-cesium-export-png.png)\

[Leaflet Easy Print](https://github.com/rowanwins/leaflet-easyPrint)
[Demo](https://www.procrastinatio.org/leaflet-print/)


### Discussions


#### Shortlinks

Mabe useful to recreate the application elsewhere, when needed.

#### Browser support

But 3D and WebGL is forcing to use modern browsers.

#### Workload is offloaded to clients

No more server

#### Raster only

Raster only, but smaller images

#### WYSIWIG

Especially in Chrome with the print preview function, the user sees exactly what is going to be printed. A print preview may also be impletemented for other browser.


#### No special code for rendering

If we considere CSS is no code, yes...

#### Resolution, aspect ratio, screen size, pixel density

Basically, your get the canvas at dispostion and try to fit in an A4 page. A small screen means a poors print quality, while a large screen means a decent or good print quality.

Some are trying to get a lager image by recreating a large hidden map canvas. It may work in 2D, but will consume much resource in 2D. Remember, A4 at 150 dpi is 1750x 1250px, and A3 at 150 DPI is 1750x2480px.

Pixel density

A paper map is read at 25cm, screen at 50-70cm 14'' and 75 - 105 cm for 20/21''
The maximal resolution is about 300 dpi at 25cm, 152 dpi at 50cm and 76 dpi at 100cm. So while a resolution of about 100dpi is acceptable on a desktop, 
it makes no sense to print above 300dpi for instance.


 Paper                96 dpi     150 dpi     300 dpi
-----------------   --------  ----------   -------
   A5 (210x148mm)    793x563    1240x880    2408x1760
   A4 (297x210mm)    1112x793   1753x1240   3507x2408
   A3 (420x297mm)    1587x1112  2408x1753   4360x3507

Table:  Relation between paper size (mm) and image size (pixels). _dpi_ (dot per inch)


Device             Screen (in)  PPI
----------------   -----------  ----
iphone 5S (2013)    4.0         325
iphone 6 (2014)     4.7         325
iphone 6s (2014)    4.7         325
iphone 7 (2016)     4.7         325
ipad (2017)         9.7         263
iphone 8 (2017)     5.5         400
ipad pro (2017)     12.9        264
galaxy S8 (2017)    6.2         530
iphone X (2017)     5.8         462
galaxy S9 (2018)    5.8         567

Table: PPI for some smartphone and tablets



##### Conserving the scale

The next three images have the same spatial extent (2500 meters wide), but have different sizes. If we want to keep the scale, here 1:25'000, we have to print the image of 100mm, regardless of the pixels of the image. The result is a low quality for smaller images.


*Image of 377x188 pixels, printed @96 dpi (100x50mm)*

!["90th, 95th and 99th percentile of created.json"](img/pk25.noscale-377-188-@96.png){ width=100mm }\

*Image of 590x295 pixels, printed @150 dpi (100x50mm)*

!["90th, 95th and 99th percentile of created.json"](img/pk25.noscale-590-295-@150.png){ width=100mm }\

*Image of 1181x590 pixels, printed @300 dpi (100x50mm)*

!["90th, 95th and 99th percentile of created.json"](img/pk25.noscale-1181-590-@300.png){ width=100mm }\

##### Conserving the print resolution

The next three images have the same spatial extent (2500 meters wide), but have different sizes. In this example, we want to keep a good print quality (300 dpi), so we have to decrease the size of the final printed image. The result is loosing the original map scale of 1:25'000.

*Image of 377x188 pixels, printed @300 dpi (32x16 mm), print scale is about 1:78'125*

!["90th, 95th and 99th percentile of created.json"](img/pk25.noscale-377-188-@96.png){ width=32mm }\

*Image of 590x295 pixels, printed @300 dpi dpi (50x25 mm), print scale is 1:50'000*

!["90th, 95th and 99th percentile of created.json"](img/pk25.noscale-590-295-@150.png){ width=50mm }\

*Image of 1181x590 pixels, printed @300 dpi (100x50mm), print scale is 1:25'000*

!["90th, 95th and 99th percentile of created.json"](img/pk25.noscale-1181-590-@300.png){ width=100mm }\


##### Effect of style

In this example we use the _Landeskarte/Pixelkarte_ because their style is targeted for a very specific scale: 1:10'000, 1:25'000 and 1:50'000.
The three following picture are printed at 300dpi for a scale of 1:25'000. 

*LK10, designed for 1:10'000*
Labels and features are very small, hard to read.

!["90th, 95th and 99th percentile of created.json"](img/lk10.noscale-1181-590-@300.png){ width=100mm }\

*PK25, designed for 1:25'000*
Labels and features are easily readable, making a joyful impression.

!["90th, 95th and 99th percentile of created.json"](img/pk25.noscale-1181-590-@300.png){ width=100mm }\

*PK50, designed for 1:50'000*
Features and labels are big. You may clearly have more information.

!["90th, 95th and 99th percentile of created.json"](img/pk50.noscale-1181-590-@300.png){ width=100mm }\

### PDF compression

Compression with jsPDF of an A4 PDF page containing a single image of 12'236'896 bytes (pk25.noscale-3271-2244-@300.png)

The following compressions are tested: `NONE`, `FAST`, `MEDIUM` and `SLOW`. For comparison, the uncompressed PDF file has been
compressed with `ps2pdf`. Five repetitions for each methods.


Compression          Time (s)       PDF (bytes)    Size (%)
-------------      -----------     -------------  ---------
NONE                 6.99 ? 0.10     29363689       100.0
FAST                 8.84 ? 0.08     11978739        40.8
MEDIUM              11.61 ? 0.41     11282507        38.4
SLOW                67.91 ? 2.37     10469602        35.6
ps2pdf              < 0.5             1227882         4.18


Another example with an image targeted for 150 dpi 3'609'601 bytes(pk25.noscale-1635-1122-@150.png)

Compression          Time (s)       PDF (bytes)    Size (%)
-------------      -----------     -------------  ---------
NONE                 2.01 ? 0.07     7341071       100.0
FAST                 2.91 ? 0.20     3554307        48.4
MEDIUM               3.69 ? 0.35     3465019        47.2
SLOW                12.33 ? 2.24     3290648        44.8
ps2pdf               < 0.25           400244         5.4


#### Templating

#### Performance

Hard to find when the page is fully rendered...

#### Security

Cross-Origin Resource Sharing (CORS) and Content-Security-Policy (CSP) 

### Conclusion

If the added value is not much more than what a screenshot offers, there not point to provide this functionality

Server side
-----------


Mixed approach
--------------
Some elements are rendered client-side and then sent to the server, or only some operation are done server-side.


Integrated approach
-------------------

Tools like QGis and ArcGIS used to configure the layers. Configuration files, including styles, are used in the web application.
As both client and server are using the same configuration, printing may be done server-side.


[QGis Print Composer][]




Discussion
==========


Conclusion
==========





[map.geo.admin.ch]: https://map.geo.admin.ch

[Print-CSS]: https://print-css.rocks/

[jsPDF]: https://parall.ax/products/jspdf
[PDFkit]: http://pdfkit.org/
[pdfmake]: http://pdfmake.org
[printjs]: http://printjs.crabbly.com/
[Bytescout's PDF Generator]: https://bytescout.com/products/developer/pdfgeneratorsdkjs/index.html
[PDF.js]: https://mozilla.github.io/pdf.js/
[PSPDFKit]: https://pspdfkit.com/pdf-sdk/web/

[PDFreactor]: http://www.pdfreactor.com
[PrinceXML]: http://www.princexml.com
[Antennahouse CSS Formatter]: http://www.antennahouse.com
[DocRaport]: https://docraptor.com/

[print-maps]: https://github.com/mpetroff/print-maps

[Paper CSS]: https://github.com/cognitom/paper-css

[OL-Cesium]: http://openlayers.org/ol-cesium/

[Tileserver GL]: http://tileserver.org/

[OSM]: https://www.openstreetmap.org/ "OpenStreetMap"
[Mapserver]: http://mapserver.org/
[Cartographical Symbol Construction with MapServer]: http://mapserver.org/mapfile/symbology/construction.html
[Mapnik]: http://mapnik.org/
[Mapnik XML]: https://github.com/mapnik/mapnik/wiki/XMLConfigReference
[Cascadenik]: https://github.com/mapnik/Cascadenik
[Mapbox Style Specification]: https://www.mapbox.com/mapbox-gl-js/style-spec/
[The end of CartoCSS]: https://blog.mapbox.com/the-end-of-cartocss-da2d7427cf1
[CartoCSS]: https://cartocss.readthedocs.io/en/latest/
[Mapbox]: https://www.mapbox.com
[Cairo]: https://cairographics.org/
[PDFlib]: https://www.pdflib.com/
[MapFish Print 2]: http://www.mapfish.org/doc/print/
[MapFish Print 3]: https://mapfish.github.io/mapfish-print-doc/#/overview
[Jasper Reports Library]: https://community.jaspersoft.com/project/jasperreports-library
[Geoserver Printing Module]: http://docs.geoserver.org/latest/en/user/extensions/printing/index.html
[Printing in Web application]: https://enterprise.arcgis.com/en/server/latest/create-web-apps/windows/printing-in-web-applications.htm 

[QGis Print Composer]: https://docs.qgis.org/testing/en/docs/user_manual/print_composer/overview_composer.html
[Webkit]: https://webkit.org/
[XSL-FO]: https://www.w3.org/TR/xsl/

**Colophon**

This document was created with [pandoc](http://pandoc.org), with the following commands:
   

    $ pandoc -f markdown --latex-engine=xelatex   --number-sections \ 
      --variable mainfont="Gentium"   -V fontsize=10pt   "README.md" \
      --toc -o "web-map-printing.pdf"




