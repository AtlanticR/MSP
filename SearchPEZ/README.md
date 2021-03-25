# Reproducible Report for Species in Maritimes Region - for Internal DFO use only

<!-- badges: start -->
<!-- badges: end -->

This package was developed to streamline the process of generating science information and advice required to ultimately support a variety of cross-sectoral departmental assessments, regulatory reviews, and reporting activities. It is intended to increase reporting efficiency and facilitate the availability of species information and occurrence data in a reproducible and transparent manner. This reporting tool was developed to summarize data and should not be viewed as a data developing tool.

Each query of the reproducible report tool begins with the submission of a search polygon which consists of a central location (or path) representing the spatial dimensions of a proposed project/activity surrounded by an exposure zone or buffer area. Each of the maps produced in the report show wildlife information relative to the search polygon (highlighted in yellow and surrounded by a buffer area in blue). 

If you have any questions contact gregory.puncher@dfo-mpo.gc.ca, Catalina.Gomez@dfo-mpo.gc.ca or Gordana.Lazin@dfo-mpo.gc.ca.

**Important Disclaimers**
This report is for internal DFO use only. No maps, layers, or data that violate the rule of 5 will be shared outside of the department. 
This report is not a data developing or analytical tool.
The absence of a species in this report should be interpreted as an absence of reporting, not as an absence of the species in the area. 
The focus of this report is on species presence and not on associated numbers, frequency, or catch information. 
Coastal and offshore areas of the Scotian Shelf bioregion are generally not adequately sampled, and hence information on these space and time scales is generally not contained within the various data sources available to the DFO, including the surveys referred to in this document. Therefore, the exact distribution of some species featured in the report may remain uncertain.

Once the search area has been defined, users are presented with several options, including which search results to include in the report. The current release of the reproducible report focuses on species at risk that have been listed by the Species at Risk Act (SARA), or assessed by the Committee on the Status of Endangered Wildlife in Canada (COSEWIC) and Wild species listings. Recognizing the importance of considering an ecosystem approach, users can also include additional information for other species (e.g., commercial, recreational, ecologically significant) and ecosystem components (e.g., habitat) in the report. Indeed, many of the programs under DFO’s mandate to sustainably manage fisheries and aquaculture, ensure that Canada’s oceans and other aquatic ecosystems are protected from negative impacts, and protect the environment when emergencies arise, could benefit from this additional section. 

Comprehensive reports are divided into the following sections:

**Search results for species listed by the <i>Species At Risk Act</i> (SARA), assessed by the Committee on the Status of Endangered Wildlife in Canada (COSEWIC) or included in the Wild species listing:**
* Information from National Aquatic Species At Risk Program,
* Fish and Invertebrates,
* Cetaceans. 	

**Search results for additional species and information (optional):**
* Species not listed by the <i>Species at Risk Act</i> (SARA), assessed by the Committee on the Status of Endangered Wildlife in Canada (COSEWIC) or included in the Wild species listing,
* Habitat information,
* Designated areas.

Within these sections, the data sources are defined along with dates of access, URLs and contact information. For each data source, the report also provides caveats and sources of uncertainty as well as a ranking in the Tiers of Data Quality (defined below). Where applicable summary tables and figures are provided. Reports should be circulated to appropriate staff listed in the contact information provided for each data source to verify and supplement the information generated to support science advice processes. Users can request additional information, and access to data and metadata directly to each contact.

**Required packages**

* data.table (v.1.13.6) [link](https://cran.r-project.org/web/packages/data.table/index.html)  
* dplyr (v.1.0.2) [link](https://cran.r-project.org/web/packages/dplyr/index.html)  
* ggplot2 (v.3.3.2) [link](https://cran.r-project.org/web/packages/ggplot2/index.html)  
* ggspatial (v.1.1.5) [link](https://cran.r-project.org/web/packages/ggspatial/index.html)  
* gridExtra (v.2.3) [link](https://cran.r-project.org/web/packages/gridExtra/index.html)  
* kableExtra (v.1.3.1) [link](https://cran.r-project.org/web/packages/kableExtra/index.html)  
* knitr (v.1.30) [link](https://cran.r-project.org/web/packages/knitr/index.html)  
* lubridate (v.1.7.9.2) [link](https://cloud.r-project.org/web/packages/lubridate/index.html)  
* maps (v.3.3.0) [link](https://cran.r-project.org/web/packages/maps/)  
* raster (v.3.4-5) [link](https://cran.r-project.org/web/packages/raster/)  
* RCurl (v.1.98-1.2) [link](https://cran.r-project.org/web/packages/RCurl/index.html)  
* rgdal (v.1.5-23) [link](https://cran.r-project.org/web/packages/rgdal/index.html)  
* sf (v.0.9-7) [link](https://cran.r-project.org/web/packages/sf/index.html)  
* stars (v.0.4-3) [link](https://cran.r-project.org/web/packages/stars/index.html)  
* stringr (v.1.4.0) [link](https://cran.r-project.org/web/packages/stringr/)  
* tidyverse (v.1.3.0) [link](https://cran.r-project.org/web/packages/tidyverse/index.html)  

* Mar.datawrangling (v.2021.02.05) [link](https://github.com/Maritimes/Mar.datawrangling)  
* standardPrintOutput (v.0.0.0.9000) [link](https://github.com/terminological/standard-print-output/)

***

![workflow-diagram](https://github.com/AtlanticR/MSP/blob/master/SearchPEZ/code/Graphics/Workflow.jpg)

__Fig 1.__ **Reproducible Reports Workflow**

***
There are two scripts necessary for preparing the data for these reports, ProduceSmallerISDB_MARFIS.r and SaveDataSets_AsRdata.r. The first of these gathers all the data from the requisite database tables (ISDB, MARFIS) and produces a smaller flat file of just the fields necessary for this application (Species code, date, amount, location (latitude and longitude).

The second script gathers all necessary data files (survey data, land, species at risk occurences, etc.) and saves the datasets into two .Rdata files: OpenData.Rdata, and SecureData.Rdata. These two files with multiple datasets are loaded when the app is run.

*Note: Restricted data from various databases (ISDB, NARWC, WSDB, MARFIS, Whitehead, Leatherback) require communication 
with several sources. Once permission has been granted to access the data, it can all be acquired using the
<SecureData.RData> script.


***

![directory-diagram]<img src="https://github.com/AtlanticR/MSP/blob/master/SearchPEZ/code/Graphics/directory_structure.jpg" width="48">

__Fig 2.__ **Required set up of directories**

***
                
# **Required data files**
**Note:** All shapefiles (.shp) also require associated files (.cpg, .dbf, .prj, .shx)

**Objects provided by loading OpendData.RData**  

**Object** | **Description**  
--------------|-----------------------------------  
**Blue_Whale_sf** | Simple feature of Important Blue Whale Habitat.  
**ClippedCritHab_sf** |  Simple feature of Species at Risk Critical Habitat.  
**EBSA_sf** | Simple feature of Ecologically and Biologically Significant Areas (EBSA).  
**fin_whale** | Raster of Priority Areas to Enhance Monitoring of Fin Whales.  
**harbour_porpoise** | Raster of Priority Areas to Enhance Monitoring of Harbour Porpoises.  
**humpback_whale** | Raster of Priority Areas to Enhance Monitoring of Humpback Whales.  
**land10m_sf** | Simple feature of North American land mass.  
**listed_species** | Table containing details of Species at Risk in the Maritimes Region.  
**obis_sf** | Simple feature of data from the Ocean Biodiversity Information System (OBIS).  
**RVCatch_sf** | Simple feature containing data from the Research Vessel surveys (spring, summer, fall, 4VSW).  
**sardist_sf** | Simple feature of of Species at Risk distribution range.  
**sei_whale** | Raster of Priority Areas to Enhance Monitoring of Sei Whales.  

**Objects provided by loading SecureData.RData**  

**Object** | **Description**  
--------------|-----------------------------------  
**isdb1** | Simple feature containing data from the Industry Survey database (ISDB).  
**leatherback_sf** |  Simple feature containing data from the DFO leatherback sea turtle database.  
**marfis1** | Simple feature containing data from the The Maritime Fishery Information System (MARFIS).  
**narwc** | Simple feature containing data from the North Atlantic Right Whale Consortium (NARWC) Sightings Database.  
**whitehead** |  Simple feature containing data from the The Whitehead Lab at Dalhousie University.  
**wsdb** | Simple feature containing data from the Whale Sightings Database (WSDB).  

**Warning: all coordinate reference systems must be CRS 4326 WGS84**


# **Functions used to plot figures and contained in "fn_maps.r"** <a name="plotdata"/>  

#### site_map  
* plot of map of site and studyArea  

[_example use_](#sitemap)  

**Variable name** | **Input**  
--------------|-----------------------------------  
**studyArea** |   A simple feature (polygon) representing an exposure zone or user-defined buffer area surrounding a site (site_sf). This polygon is used to search for overlapping data points contained in the various datasets used by the reporting tool.  
**site_sf** |  A simple feature representing a point location or track of a proposed project/activity/accident.  
**land_layer** |  A simple feature used by plotting functions to illustrate terrestrial boundaries.  
**buf** |  An integer used to define the distance (km) between the margins of the studyArea and the figure margins.   

#### plot_crithab  
* plot of map of studyArea relative to species at risk critical habitat  

[_example use_](#plotcrithab)  

**Variable name** | **Input**  
--------------|-----------------------------------  
**studyArea** |  A simple feature (polygon) representing an exposure zone or user-defined buffer area surrounding a site (site_sf). This polygon is used to search for overlapping data points contained in the various datasets used by the reporting tool.  
**ClippedCritHab_sf** |  A simple feature containing polygons defining critical habitat of species at risk. The data set has been clipped to the Maritimes region.  
**land_layer** |  A simple feature used by plotting functions to illustrate terrestrial boundaries.  
**buf** |  An integer used to define the distance (km) between the margins of the studyArea and the figure margins.  

#### plot_sardist  
* plot of studyArea relative to species at risk distribution range  

[_example use_](#plotsardist)  

**Variable name** | **Input**  
--------------|-----------------------------------  
**sardist_sf** |  A simple feature containing polygons defining the distribution range of species at risk. The data set has been clipped to the Maritimes region.
**studyArea** |  A simple feature (polygon) representing an exposure zone or user-defined buffer area surrounding a site (site_sf). This polygon is used to search for overlapping data points contained in the various datasets used by the reporting tool.  
**land_layer** |  A simple feature used by plotting functions to illustrate terrestrial boundaries.  
**buf** |  An integer used to define the distance (km) between the margins of the studyArea and the figure margins.  

#### plot_cetaceans_4grid  
* plot of studyArea relative to priority areas to enhance monitoring of cetaceans  

[_example use_](#plotcetaceans4grid)  

**Variable name** | **Input**  
--------------|-----------------------------------  
**fin_whale_sf** |  A simple feature (multipolygon) contianing data on pririty areas for enhanced monitoring of fin whales. Converted from a tif file. 
**harbour_porpoise_sf** |  A simple feature (multipolygon) contianing data on pririty areas for enhanced monitoring of harbour porpoises. Converted from a tif file.
**humpback_whale_sf** |  A simple feature (multipolygon) contianing data on pririty areas for enhanced monitoring of humpback whales. Converted from a tif file.
**sei_whale_sf** |  A simple feature (multipolygon) contianing data on pririty areas for enhanced monitoring of sei whales. Converted from a tif file.
**studyArea** |  A simple feature (polygon) representing an exposure zone or user-defined buffer area surrounding a site (site_sf). This polygon is used to search for overlapping data points contained in the various datasets used by the reporting tool.  
**land_layer** |  A simple feature used by plotting functions to illustrate terrestrial boundaries.  
**buf** |  An integer used to define the distance (km) between the margins of the studyArea and the figure margins.  

#### plot_bw_hab  
* plot of studyArea with Blue Whale habitat wide angle  

[_example use_](#plotbwhab)  

**Variable name** | **Input**  
--------------|-----------------------------------  
**Blue_Whale_sf** |  A simple feature (multi-polygon) containing data on Important areas of Blue Whale feeding, foraging and migration in eastern Canada.
**studyArea** |  A simple feature (polygon) representing an exposure zone or user-defined buffer area surrounding a site (site_sf). This polygon is used to search for overlapping data points contained in the various datasets used by the reporting tool.  
**land_layer** |  A simple feature used by plotting functions to illustrate terrestrial boundaries.  

#### plot_bw_hab_zoom  
* plot of studyArea with Blue Whale habitat zoomed  

[_example use_](#plotbwhabzoom)  

**Variable name** | **Input**  
--------------|-----------------------------------  
**Blue_Whale_sf** |  A simple feature (multi-polygon) containing data on Important areas of Blue Whale feeding, foraging and migration in eastern Canada.
**studyArea** |  A simple feature (polygon) representing an exposure zone or user-defined buffer area surrounding a site (site_sf). This polygon is used to search for overlapping data points contained in the various datasets used by the reporting tool.  
**land_layer** |  A simple feature used by plotting functions to illustrate terrestrial boundaries.  
**buf** |  An integer used to define the distance (km) between the margins of the studyArea and the figure margins.  

#### plot_EBSA  
* plot of studyArea with Ecologically and Biologically Significant Areas (EBSA)  

[_example use_](#plotEBSA)  

**Variable name** | **Input**  
--------------|-----------------------------------  
**EBSA_sf** |  A simple feature (multi-polygon) containing data on Ecologically and Biologically Significant Areas. 
**studyArea** |  A simple feature (polygon) representing an exposure zone or user-defined buffer area surrounding a site (site_sf). This polygon is used to search for overlapping data points contained in the various datasets used by the reporting tool.  
**land_layer** |  A simple feature used by plotting functions to illustrate terrestrial boundaries.  
**buf** |  An integer used to define the distance (km) between the margins of the studyArea and the figure margins.  

# Functions used to intersect data polygons and points with studyArea and contained in "fn_intersect_operations.R" <a name="intersectdata"/> 

## Information from National Aquatic ***Species at Risk*** Program   

#### table_dist
* create table of species at risk distribution range overlapping with studyArea

[_example use_](#tabledist)

**Variable name** | **Input**  
--------------|-----------------------------------
**sardist_sf** |  A simple feature containing polygons defining the distribution range of species at risk. The data set has been clipped to the Maritimes region.
**studyArea** |  A simple feature (polygon) representing an exposure zone or user-defined buffer area surrounding a site (site_sf). This polygon is used to search for overlapping data points contained in the various datasets used by the reporting tool.  

#### table_crit
* create table of species at risk critical habitat overlapping with studyArea

[_example use_](#tablecrit)

**Variable name** | **Input**  
--------------|-----------------------------------
**ClippedCritHab_sf** |  
**studyArea** |  A simple feature (polygon) representing an exposure zone or user-defined buffer area surrounding a site (site_sf). This polygon is used to search for overlapping data points contained in the various datasets used by the reporting tool.  
**leatherback_sf** |

## Maritimes Research Vessel (RV) Survey   

#### table_rv_SAR  
* create table of data from species at risk from the Research Vessel (RV) survey database overlapping with the studyArea polygon.

[_example use_](#tablervSAR)

**Variable name** | **Input**  
--------------|-----------------------------------
**RVCatch_intersect** |  Data from the Research Vessel (RV) survey database intersected with the studyArea polygon.  

#### table_rv  
* create table of data from the Research Vessel (RV) survey database overlapping with the studyArea polygon.

[_example use_](#tablerv)

**Variable name** | **Input**  
--------------|-----------------------------------
**RVCatch_intersect** |  Data from the Research Vessel (RV) survey intersected with the studyArea polygon.  

## Industry Survey and Maritimes Fishery Databases (ISDB)   

#### table_isdb_SAR  
* create table of data from species at risk from the Industry Survey Database (ISDB) overlapping with the studyArea polygon.

[_example use_](#tableisdbSAR)

**Variable name** | **Input**  
--------------|-----------------------------------
**isdb_intersect** |  Data from the Industry Survey Database (ISDB)intersected with the studyArea polygon.  

#### table_isdb  
* create table of data from the Industry Survey Database (ISDB) overlapping with the studyArea polygon.

[_example use_](#tableisdb)

**Variable name** | **Input**  
--------------|-----------------------------------
**isdb_intersect** |  Data from the Industry Survey Database (ISDB) intersected with the studyArea polygon.

## The Maritime Fishery Information System (MARFIS)  

#### table_marfis_SAR  
* create table of data from species at risk from the MARFIS database overlapping with the studyArea polygon.

[_example use_](#tablemarfisSAR)

**Variable name** | **Input**  
--------------|-----------------------------------
**marfis_intersect** |  Data from the MARFIS database intersected with the studyArea polygon.  

#### table_marfis  
* create table of data from the MARFIS database overlapping with the studyArea polygon.

[_example use_](#tablemarfis)

**Variable name** | **Input**  
--------------|-----------------------------------
**marfis_intersect** |  Data from the MARFIS database intersected with the studyArea polygon.

## Ocean Biodiversity Information System - Fish and Invertebrates

#### filter_obis_fish
* create table containing records from the OBIS database overlapping with studyArea

[_example use_](#filterobisfish)

**Variable name** | **Input**  
--------------|-----------------------------------
**obis_sf** |  Dataframe containing records from the Ocean Biodiversity Infromation System (OBIS) database.  

#### intersect_points_obis_fish    
* find overlap between the OBIS database and studyArea

[_example use_](#intersectpointsobisfish)

**Variable name** | **Input**  
--------------|-----------------------------------
**obis_sf_filter** |  Data from the Ocean Biodiversity Infromation System (OBIS) database merged with fish and invertebrate species in the listed_species name conversion dataframe. Data from the Whale Sightings Database removed.  
**studyArea** |  A simple feature (polygon) representing an exposure zone or user-defined buffer area surrounding a site (site_sf). This polygon is used to search for overlapping data points contained in the various datasets used by the reporting tool.  

#### table_obis_fish  
* create table of overlapping data from OBIS database  

[_example use_](#tableobisfish)

**Variable name** | **Input**  
--------------|-----------------------------------
**obis_sf_filter** |  Data from the Ocean Biodiversity Infromation System (OBIS) database merged with cetacean species in the listed_species name conversion dataframe. Data from the Whale Sightings Database removed.  
**studyArea** |  A simple feature (polygon) representing an exposure zone or user-defined buffer area surrounding a site (site_sf). This polygon is used to search for overlapping data points contained in the various datasets used by the reporting tool.  

## Whale Sightings Database (WSDB)

#### filter_wsdb
* filter wsdb data

[_example use_](#filterwsdb)

**Variable name** | **Input**  
--------------|-----------------------------------
**wsdb** |  Dataframe containing records from the Whale Sightings Database.

#### intersect_points_wsdb  
* find overlap between wsdb and studyArea

[_example use_](#intersectpointswsdb)

**Variable name** | **Input**  
--------------|-----------------------------------
**wsdb_filter** |  Data from the Whale Sightings Database with common names changed and merged with listed_species name conversion dataframe.
**studyArea** |  A simple feature (polygon) representing an exposure zone or user-defined buffer area surrounding a site (site_sf). This polygon is used to search for overlapping data points contained in the various datasets used by the reporting tool.  

#### table_wsdb
* create table of overlapping data from WSDB  

[_example use_](#tablewsdb)

**Variable name** | **Input**  
--------------|-----------------------------------
**wsdb_filter** |  Data from the Whale Sightings Database with common names changed and merged with listed_species name conversion dataframe.
**studyArea** |  A simple feature (polygon) representing an exposure zone or user-defined buffer area surrounding a site (site_sf). This polygon is used to search for overlapping data points contained in the various datasets used by the reporting tool.  

## Whitehead Lab database

#### filter_whitehead
* create table containing records from the Whitehead Lab database overlapping with studyArea.  

[_example use_](#filter_whitehead)

**Variable name** | **Input**  
--------------|-----------------------------------
**whitehead** |  Dataframe containing records from the Whitehead Lab Database.  

#### intersect_points_whitehead  
* find overlap between the Whitehead Lab database and studyAre

[_example use_](#intersect_points_whitehead)

**Variable name** | **Input**  
--------------|-----------------------------------
**whitehead_filter** |  Data from the Whitehead Lab Database merged with listed_species name conversion dataframe.  
**studyArea** |  A simple feature (polygon) representing an exposure zone or user-defined buffer area surrounding a site (site_sf). This polygon is used to search for overlapping data points contained in the various datasets used by the reporting tool.  

#### table_whitehead
* create table of overlapping data from Whitehead Lab database  

[_example use_](#table_whitehead)

**Variable name** | **Input**  
--------------|-----------------------------------
**whitehead_filter** |  Data from the Whitehead Lab Database merged with listed_species name conversion dataframe.  
**studyArea** |  A simple feature (polygon) representing an exposure zone or user-defined buffer area surrounding a site (site_sf). This polygon is used to search for overlapping data points contained in the various datasets used by the reporting tool.  

## North Atlantic Right Whale Consortium (NARWC) database  

#### filter_narwc
* create table containing records from the NARWC database overlapping with studyArea

[_example use_](#filter_narwc)

**Variable name** | **Input**  
--------------|-----------------------------------
**narwc** |  Dataframe containing records from the North Atlantic Right Whale Consortium (NARWC) sightings database.  

#### intersect_points_narwc  
* find overlap between the NARWC database and studyArea

[_example use_](#intersect_points_narwc)

**Variable name** | **Input**  
--------------|-----------------------------------
**narwc_filter** |  Data from the North Atlantic Right Whale Consortium (NARWC) sightings database with species code names changed to scientific names and merged with listed_species name conversion dataframe.  
**studyArea** |  A simple feature (polygon) representing an exposure zone or user-defined buffer area surrounding a site (site_sf). This polygon is used to search for overlapping data points contained in the various datasets used by the reporting tool.  

#### table_narwc
* create table of overlapping data from NARWC database  

[_example use_](#table_narwc)

**Variable name** | **Input**  
--------------|-----------------------------------
**narwc_filter** |  Data from the North Atlantic Right Whale Consortium (NARWC) sightings database with species code names changed to scientific names and merged with listed_species name conversion dataframe.  
**studyArea** |  A simple feature (polygon) representing an exposure zone or user-defined buffer area surrounding a site (site_sf). This polygon is used to search for overlapping data points contained in the various datasets used by the reporting tool.  

## Ocean Biodiversity Information System - Cetaceans

#### filter_obis_cet
* create table containing records from the OBIS database overlapping with studyArea

[_example use_](#filter_obis_cet)

**Variable name** | **Input**  
--------------|-----------------------------------
**obis_sf** |  Dataframe containing records from the Ocean Biodiversity Infromation System (OBIS) database.  

#### intersect_points_obis_cet    
* find overlap between the OBIS database and studyArea

[_example use_](#intersect_points_obis_cet)

**Variable name** | **Input**  
--------------|-----------------------------------
**obis_sf_filter** |  Data from the Ocean Biodiversity Infromation System (OBIS) database merged with cetacean species in the listed_species name conversion dataframe. Data from the Whale Sightings Database removed.  
**studyArea** |  A simple feature (polygon) representing an exposure zone or user-defined buffer area surrounding a site (site_sf). This polygon is used to search for overlapping data points contained in the various datasets used by the reporting tool.  

#### table_obis_cet  
* create table of overlapping data from OBIS database  

[_example use_](#table_obis_cet)

**Variable name** | **Input**  
--------------|-----------------------------------
**obis_sf_filter** |  Data from the Ocean Biodiversity Infromation System (OBIS) database merged with cetacean species in the listed_species name conversion dataframe. Data from the Whale Sightings Database removed.  
**studyArea** |  A simple feature (polygon) representing an exposure zone or user-defined buffer area surrounding a site (site_sf). This polygon is used to search for overlapping data points contained in the various datasets used by the reporting tool.  

## Priority Areas to Enhance Monitoring of Cetaceans

#### sdm_table
* create table of overlapping data from Priority Areas to Enhance Monitoring of Cetaceans  

[_example use_](#sdm_table)

**Variable name** | **Input**  
--------------|-----------------------------------
**fin_whale_sf** |  A simple feature (multipolygon) contianing data on pririty areas for enhanced monitoring of fin whales. Converted from a tif file. 
**harbour_porpoise_sf** |  A simple feature (multipolygon) contianing data on pririty areas for enhanced monitoring of harbour porpoises. Converted from a tif file.  
**humpback_whale_sf** |  A simple feature (multipolygon) contianing data on pririty areas for enhanced monitoring of humpback whales. Converted from a tif file.  
**sei_whale_sf** |  A simple feature (multipolygon) contianing data on pririty areas for enhanced monitoring of sei whales. Converted from a tif file.  
**studyArea** | A simple feature (polygon) representing an exposure zone or user-defined buffer area surrounding a site (site_sf). This polygon is used to search for overlapping data points contained in the various datasets used by the reporting tool.  

## Important areas of Blue Whale feeding, foraging and migration in eastern Canada

#### blue_whale_habitat_overlap
* create table of overlapping data from Important Blue Whale Habitat  

[_example use_](#blue_whale_habitat_overlap)

**Variable name** | **Input**  
--------------|-----------------------------------
**Blue_Whale_sf** |  A simple feature (multi-polygon) containing data on Important areas of Blue Whale feeding, foraging and migration in eastern Canada.  
**studyArea** | A simple feature (polygon) representing an exposure zone or user-defined buffer area surrounding a site (site_sf). This polygon is used to search for overlapping data points contained in the various datasets used by the reporting tool.  

## Ecologically and Biologically Significant Areas (EBSA)

#### EBSA_overlap
* create table of overlapping data from Ecologically and Biologically Significant Areas (EBSA)

[_example use_](#EBSA_overlap)

**Variable name** | **Input**  
--------------|-----------------------------------
**EBSA_sf** |  A simple feature (multi-polygon) containing data on Ecologically and Biologically Significant Areas.  
**studyArea** |  A simple feature (polygon) representing an exposure zone or user-defined buffer area surrounding a site (site_sf). This polygon is used to search for overlapping data points contained in the various datasets used by the reporting tool.  

#### EBSA_report
* determine whether studyArea overlaps with EBSA

[_example use_](#EBSA_report)

**Variable name** | **Input**  
--------------|-----------------------------------
**EBSA_sf** |  A simple feature (multi-polygon) containing data on Ecologically and Biologically Significant Areas.  
**studyArea** |  A simple feature (polygon) representing an exposure zone or user-defined buffer area surrounding a site (site_sf). This polygon is used to search for overlapping data points contained in the various datasets used by the reporting tool.  

#### EBSA_reporturl
* print url of report corresponding to EBSA that overlaps with studyArea

[_example use_](#EBSA_reporturl)

**Variable name** | **Input**  
--------------|-----------------------------------
**EBSA_sf** |  A simple feature (multi-polygon) containing data on Ecologically and Biologically Significant Areas.  
**studyArea** |  A simple feature (polygon) representing an exposure zone or user-defined buffer area surrounding a site (site_sf). This polygon is used to search for overlapping data points contained in the various datasets used by the reporting tool.  

#### EBSA_location
* print name of EBSA that overlaps with studyArea

[_example use_](#EBSA_location)

**Variable name** | **Input**  
--------------|-----------------------------------
**EBSA_sf** |  A simple feature (multi-polygon) containing data on Ecologically and Biologically Significant Areas.  
**studyArea** |  A simple feature (polygon) representing an exposure zone or user-defined buffer area surrounding a site (site_sf). This polygon is used to search for overlapping data points contained in the various datasets used by the reporting tool.  

#### EBSA_bioregion 
* determine if an EBSA overlaps with studyArea

[_example use_](#EBSA_bioregion )

**Variable name** | **Input**  
--------------|-----------------------------------
**EBSA_sf** |  A simple feature (multi-polygon) containing data on Ecologically and Biologically Significant Areas.  
**studyArea** |  A simple feature (polygon) representing an exposure zone or user-defined buffer area surrounding a site (site_sf). This polygon is used to search for overlapping data points contained in the various datasets used by the reporting tool.  


# **Example use of functions**

## site\_map <a name="sitemap"/>
Plot of map of site and studyArea. [_Function description_](#plotdata)

```r
  site_map(studyArea,site_sf,land_layer,buf)
```

## plot\_crithab <a name="plotcrithab"/>
Plot of map of studyArea relative to species at risk critical habitat. [_Function description_](#plotdata)

```r
  plot_crithab(ClippedCritHab_sf, studyArea, land_layer, buf)
```

## plot\_sardist <a name="plotsardist"/>
Plot of studyArea relative to species at risk distribution range. [_Function description_](#plotdata)

```r
  plot_sardist(sardist_sf, studyArea, land_layer, buf)
```

## plot\_cetaceans\_4grid <a name="plotcetaceans4grid"/>
Plot of studyArea relative to priority areas to enhance monitoring of cetaceans. [_Function description_](#plotdata)

```r
  plot_cetaceans_4grid(fin_whale_sf,harbour_porpoise_sf,humpback_whale_sf,sei_whale_sf,studyArea,land_layer,buf)
```

## plot\_bw\_hab <a name="plotbwhab"/>
Plot of studyArea with Blue Whale habitat wide angle. [_Function description_](#plotdata)

```r
  plot_bw_hab(Blue_Whale_sf, studyArea, land_layer)
```

## plot\_bw\_hab\_zoom <a name="plotbwhabzoom"/>
Plot of studyArea with Blue Whale habitat zoomed. [_Function description_](#plotdata)

```r
  plot_bw_hab_zoom(Blue_Whale_sf, studyArea, land_layer, buf)
```  

## plot\_EBSA <a name="plotEBSA"/>
Plot of studyArea with Ecologically and Biologically Significant Areas (EBSA). [_Function description_](#plotdata)

```r
  plot_EBSA(EBSA_shp, studyArea, land_layer, buf)
```    

## table\_dist <a name="tabledist"/>
Create table of species at risk distribution range overlapping with studyArea. [_Function description_](#intersectdata)

```r
  table_dist(sardist_sf,studyArea)
```

## table\_crit <a name="tablecrit"/>
Create table of species at risk critical habitat overlapping with studyArea. [_Function description_](#intersectdata)

```r
  table_crit(ClippedCritHab_sf,studyArea, leatherback_sf)
```

## table\_rv_\SAR <a name="tablervSAR"/>
Create table of data from species at risk from the Research Vessel (RV) survey database overlapping with the studyArea polygon. [_Function description_](#intersectdata)

```r
  table_rv_SAR(RVCatch_intersect)
```

## table\_rv <a name="tablerv"/>
Create table of data from the Research Vessel (RV) survey database overlapping with the studyArea polygon. [_Function description_](#intersectdata)  

```r
  table_rv(RVCatch_intersect)
```  
  
## table\_isdb\_SAR <a name="tableisdbSAR"/>
Create table of data from species at risk from the Industry Survey Database (ISDB) overlapping with the studyArea polygon. [_Function description_](#intersectdata)  

```r
  table_isdb_SAR(isdb_intersect)
``` 

## table\_isdb <a name="tableisdb"/>
Create table of data from the Industry Survey Database (ISDB) overlapping with the studyArea polygon. [_Function description_](#intersectdata)  

```r
  table_isdb(isdb_intersect)
``` 

## table\_marfis\_SAR <a name="tablemarfisSAR"/>
Create table of data from species at risk from the MARFIS database overlapping with the studyArea polygon. [_Function description_](#intersectdata)  

```r
  table_marfis_SAR(marfis_intersect)
``` 

## table\_marfis <a name="tablemarfis"/>
Create table of data from the MARFIS database overlapping with the studyArea polygon. [_Function description_](#intersectdata)  

```r
  table_marfis(marfis_intersect)
``` 

## filter\_obis\_fish <a name="filterobisfish"/>
Create table containing records from the OBIS database overlapping with studyArea. [_Function description_](#intersectdata)  

```r
  filter_obis_fish(obis_sf)
``` 

## intersect\_points\_obis\_fish <a name="intersectpointsobisfish"/>
Find overlap between the OBIS database and studyArea. [_Function description_](#intersectdata)  

```r
  intersect_points_obis_fish(obis_sf_filter, studyArea)
```

## table\_obis\_fish <a name="tableobisfish"/>
Create table of overlapping data from OBIS database. [_Function description_](#intersectdata)  

```r
  table_obis_fish(obis_sf_filter, studyArea)
``` 

## filter\_wsdb <a name="filterwsdb"/>
Filter wsdb data. [_Function description_](#intersectdata)

```r
  filter_wsdb(wsdb)
```

## intersect\_points\_wsdb <a name="intersectpointswsdb"/>
Find overlap between wsdb and studyArea. [_Function description_](#intersectdata)

```r
  intersect_points_wsdb(wsdb_filter, studyArea)
```

## table\_wsdb <a name="tablewsdb"/>
Create table of overlapping data from WSDB. [_Function description_](#intersectdata)

```r
  table_wsdb(wsdb_filter, studyArea)
```

## filter\_whitehead <a name="filterwhitehead"/>
Create table containing records from the Whitehead Lab database overlapping with studyArea. [_Function description_](#intersectdata)

```r
  filter_whitehead(whitehead)
```

## intersect\_points\_whitehead <a name="intersectpointswhitehead"/>
Find overlap between the Whitehead Lab database and studyArea. [_Function description_](#intersectdata)

```r
  intersect_points_whitehead(whitehead_filter, studyArea)
```

## table\_whitehead <a name="tablewhitehead"/>
Create table of overlapping data from Whitehead Lab database. [_Function description_](#intersectdata)

```r
  table_whitehead(whitehead_filter, studyArea)
```

## filter\_narwc <a name="filternarwc"/>
Create table containing records from the NARWC database overlapping with studyArea. [_Function description_](#intersectdata)

```r
  filter_narwc <- function(narwc)
```

## intersect\_points\_narwc <a name="intersectpointsnarwc"/>
Find overlap between the NARWC database and studyArea. [_Function description_](#intersectdata)

```r
  intersect_points_narwc(narwc_filter, studyArea)
```

## table\_narwc <a name="tablenarwc"/>
Create table of overlapping data from NARWC database. [_Function description_](#intersectdata)

```r
  table_narwc(narwc_filter, studyArea)
```

## filter\_obis <a name="filterobis"/>
Create table containing records from the OBIS database overlapping with studyArea. [_Function description_](#intersectdata)

```r
  filter_obis(obis)
```
 
## intersect\_points\_obis <a name="intersectpointsobis"/>
Find overlap between the OBIS database and studyArea. [_Function description_](#intersectdata)

```r
  intersect_points_obis(obis_filter, studyArea)
```
 
## table\_obis <a name="tableobis"/>
Create table of overlapping data from OBIS database. [_Function description_](#intersectdata)

```r
  table_obis(obis_filter, studyArea)
```

## sdm\_table <a name="sdmtable"/>
Create table of overlapping data from Priority Areas to Enhance Monitoring of Cetaceans. [_Function description_](#intersectdata)

```r
  sdm_table(fin_whale_sf, harbour_porpoise_sf, humpback_whale_sf, sei_whale_sf, studyArea)
```

## blue\_whale\_habitat\_overlap <a name="bluewhalehabitatoverlap"/>
Create table of overlapping data from Important Blue Whale Habitat. [_Function description_](#intersectdata)

```r
  blue_whale_habitat_overlap(Blue_Whale_sf, studyArea)
``` 

## EBSA\_overlap <a name="EBSAoverlap"/>
Create table of overlapping data from Ecologically and Biologically Significant Areas (EBSA). [_Function description_](#intersectdata)

```r
  EBSA_overlap(EBSA_sf, studyArea)
``` 

## EBSA\_report <a name="EBSAreport"/>
Determine whether studyArea overlaps with EBSA. [_Function description_](#intersectdata)

```r
  EBSA_report(EBSA_sf, studyArea)
``` 
 
## EBSA\_reporturl <a name="EBSAreporturl"/>
Print url of report corresponding to EBSA that overlaps with studyArea. [_Function description_](#intersectdata)

```r
  EBSA_reporturl(EBSA_sf, studyArea) 
``` 

## EBSA\_location <a name="EBSAlocation"/>
Print name of EBSA that overlaps with studyArea. [_Function description_](#intersectdata)

```r
  EBSA_location(EBSA_sf, studyArea) 
``` 
 
## EBSA\_bioregion <a name="EBSAbioregion"/>
Determine if an EBSA overlaps with studyArea. [_Function description_](#intersectdata)

```r
  EBSA_bioregion(EBSA_sf, studyArea)
```