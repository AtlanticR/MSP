# Reproducible Report for Species in Maritimes Region - for Internal DFO use only

<!-- badges: start -->
<!-- badges: end -->

This package was developed to streamline the process of generating science information and advice required to ultimately support a variety of cross-sectoral departmental assessments, regulatory reviews, and reporting activities. It is intended to increase reporting efficiency and facilitate the availability of species information and occurrence data in a reproducible and transparent manner. This reporting tool was developed to summarize data and should not be viewed as a data developing tool.

Each query of the reproducible report tool begins with the submission of a search polygon which consists of a central location (or path) representing the spatial dimensions of a proposed project/activity surrounded by an exposure zone or buffer area. Each of the maps produced in the report show wildlife information relative to the search polygon (highlighted in yellow and surrounded by a buffer area in blue). 

The resulting search results are separated into the sections defined above. Within these sections, the data sources are defined along with dates of access, URLs and contact information. For each data source, the report also provides caveats and sources of uncertainty as well as a ranking in the Tiers of Data Quality (defined below). Where applicable summary tables and figures are provided. Reports should be circulated to appropriate staff listed in the contact information provided for each data source to verify and supplement the information generated to support science advice processes. Users can request additional information, and access to data and metadata directly to each contact. 

**Important Disclaimers**
This report is for internal DFO use only. No maps, layers, or data that violate the rule of 5 will be shared outside of the department. 
This report is not a data developing or analytical tool.
The absence of a species in this report should be interpreted as an absence of reporting, not as an absence of the species in the area. 
The focus of this report is on species presence and not on associated numbers, frequency, or catch information. 
Coastal and offshore areas of the Scotian Shelf bioregion are generally not adequately sampled, and hence information on these space and time scales is generally not contained within the various data sources available to the DFO, including the surveys referred to in this document. Therefore, the exact distribution of some species featured in the report may remain uncertain.

Once the search area has been defined, users are presented with several options, including which search results to include in the report. The current release of the reproducible report focuses on species at risk that have been listed by the Species at Risk Act (SARA), or assessed by the Committee on the Status of Endangered Wildlife in Canada (COSEWIC) and Wild species listings. Recognizing the importance of considering an ecosystem approach, users can also include additional information for other species (e.g., commercial, recreational, ecologically significant) and ecosystem components (e.g., habitat) in the report. Indeed, many of the programs under DFO’s mandate to sustainably manage fisheries and aquaculture, ensure that Canada’s oceans and other aquatic ecosystems are protected from negative impacts, and protect the environment when emergencies arise, could benefit from this additional section. 

Comprehensive reports are divided into the following sections:

**Search results for species listed by the Species At Risk Act, assessed by COSEWIC, and/or Wild Species:**
* Information from National Aquatic Species At Risk Program,
* Fish and Invertebrates,
* Cetaceans. 	

**Search results for additional species and information (optional):**
* Species not listed by the <i>Species at Risk Act</i> (SARA), assessed by the Committee on the Status of Endangered Wildlife in Canada (COSEWIC) or included in the Wild species listing,
* Habitat information,
* Designated areas.

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

![workflow-diagram](https://github.com/AtlanticR/MSP/blob/master/SearchPEZ/code/Workflow.jpg)

__Fig 1.__ **Workflow**

***

*Note for restricted access databases** 

***

![directory-diagram](https://github.com/AtlanticR/MSP/blob/master/SearchPEZ/code/directory_structure.jpg)

__Fig 2.__ **Directories** *set up of directories*

***
                
# **Required data files**
**Note:** All shapefiles (.shp) also require associated files (.cpg, .dbf, .prj, .shx)

**Files provided in GitHub:**
/Data/Boundaries/Coast50K/Coastline50k_SHP/Land_AtlCanada_ESeaboardUS.shp
/Data/NaturalResources/Species/MAR_listed_species.csv
/Data/NaturalResources/Species/SpeciesAtRisk/clipped_layers/ClipCritHab.shp
/Data/NaturalResources/Species/SpeciesAtRisk/clipped_layers/sardist_4326.shp
/Data/NaturalResources/Species/SpeciesAtRisk/LeatherBackTurtleCriticalHabitat/LBT_CH_2013.shp
/Data/NaturalResources/Species/OBIS_GBIF_iNaturalist/GBIF_MAR_priority_records.csv
/Data/NaturalResources/Species/Cetaceans/NARWC/NARWC_09-18-2020.csv
/Data/NaturalResources/Species/Cetaceans/WSDB/MarWSDBSightingsForCGomez_27Oct2020.csv
/Data/NaturalResources/Species/CWS_ECCC/CWS_ECCC_OBIS_records.csv
/Data/NaturalResources/Species/Cetaceans/PriorityAreas_FGP/Fin_Whale.tif


**Files that shoud be generated by the user:**
/Data/NaturalResources/Species/OBIS_GBIF_iNaturalist/OBIS_MAR_priority_records.csv (generated using iNat_obis_gbif_data_mining.r)
/Data/NaturalResources/Species/OBIS_GBIF_iNaturalist/iNaturalist_MAR_priority_records.csv (generated using iNat_obis_gbif_data_mining.r)

**Files with restricted access to be acquired by the user:**
<ISDB> and <MARFIS> files are generated using the Mar.datawrangling package directly from the ORACLE databases and each .RData file represents a distinct database table.  To download the data directly or to use the processed tables a user would have to have appropriate permissions to the specific database.


**Warning: all coordinate reference systems must be CRS 4326 WGS84**


# **Functions for selecting and intersecting RV, MARFIS, and ISDB data and contained in "fn_SurveyData.r" **

#### SelectRV_fn  
* aggregate data from multiple RV survey data files  
* produce an sf object (RVCatch_sf) for polygon overlay analysis  

[_example use_](#SelectRV_fn)  

**Variable name** | **Input**  
--------------|-----------------------------------  
**SurveyPrefix** | Prefix indicative of database (ISDB, RV, MARFIS)  
**File** |  
**studyArea** |  
**minYear** |  

#### SelectMARFIS_fn  
* aggregate data from multiple MARFIS data files  
* produce an sf object (MARFISCatch_sf) for polygon overlay analysis  

[_example use_](#SelectMARFIS_fn)  

**Variable name** | **Input**  
--------------|-----------------------------------  
**studyArea** |  
**minYear** |  

#### SelectMARFIS_fn  
*aggregate data from multiple ISDB data files  
*produce an sf object (ISDBCatch_sf) for polygon overlay analysis  

[_example use_](#SelectISDB_fn)  

**Variable name** | **Input**  
--------------|-----------------------------------  
**studyArea** |  
**minYear** |  


# **Functions used to plot figures and contained in "fn_maps.r"**  

#### site_map  
* plot of map of site and studyArea  

[_example use_](#site_map)  

**Variable name** | **Input**  
--------------|-----------------------------------  
**studyArea** |  
**site_sf** |  
**land_layer** |  
**buf** |  

#### plot_crithab  
* plot of map of studyArea relative to species at risk critical habitat  

[_example use_](#plot_crithab)  

**Variable name** | **Input**  
--------------|-----------------------------------  
**studyArea** |  
**ClippedCritHab_sf** |  
**land_layer** |  
**buf** |  

#### plot_crithab  
* plot of studyArea relative to species at risk distribution range  

[_example use_](#plot_sardist)  

**Variable name** | **Input**  
--------------|-----------------------------------  
**sardist_sf** |  
**studyArea** |  
**land_layer** |  
**buf** |  

#### plot_cetaceans_4grid  
* plot of studyArea relative to priority areas to enhance monitoring of cetaceans  

[_example use_](#plot_cetaceans_4grid)  

**Variable name** | **Input**  
--------------|-----------------------------------  
**fin_whale_sf** |  
**harbour_porpoise_sf** |  
**humpback_whale_sf** |  
**sei_whale_sf** |  
**studyArea** |  
**land_layer** |  
**buf** |  

#### plot_bw_hab  
* plot of studyArea with Blue Whale habitat wide angle  

[_example use_](#plot_bw_hab)  

**Variable name** | **Input**  
--------------|-----------------------------------  
**Blue_Whale_sf** |  
**studyArea** |  
**land_layer** |  

#### plot_bw_hab_zoom  
* plot of studyArea with Blue Whale habitat zoomed  

[_example use_](#plot_bw_hab_zoom)  

**Variable name** | **Input**  
--------------|-----------------------------------  
**Blue_Whale_sf** |  
**studyArea** |  
**land_layer** |  
**buf** |  

#### plot_EBSA  
* plot of studyArea with Ecologically and Biologically Significant Areas (EBSA)  

[_example use_](#plot_EBSA)  

**Variable name** | **Input**  
--------------|-----------------------------------  
**EBSA_shp** |  
**studyArea** |  
**land_layer** |  
**buf** |  

# Functions used to intersect data polygons and points with studyArea and contained in "fn_intersect_operations.R"

## Information from National aquatic ***Species at Risk*** Program   

#### table_dist
* create table of species at risk distribution range overlapping with studyArea

[_example use_](#table_dist)

**Variable name** | **Input**  
--------------|-----------------------------------
**sardist_sf** |  
**studyArea** |  

#### table_crit
* create table of species at risk critical habitat overlapping with studyArea

[_example use_](#table_crit)

**Variable name** | **Input**  
--------------|-----------------------------------
**ClippedCritHab_sf** |  
**studyArea** |  
**leatherback_sf** |

## Whale Sightings Database (WSDB)

#### filter_wsdb
* filter wsdb data

[_example use_](#filter_wsdb)

**Variable name** | **Input**  
--------------|-----------------------------------
**wsdb** |  

#### intersect_points_wsdb  
* find overlap between wsdb and studyArea

[_example use_](#intersect_points_wsdb)

**Variable name** | **Input**  
--------------|-----------------------------------
**wsdb_filter** |  
**studyArea** |  

#### table_wsdb
* create table of overlapping data from WSDB  

[_example use_](#table_wsdb)

**Variable name** | **Input**  
--------------|-----------------------------------
**wsdb_filter** |  
**studyArea** |  

## Whitehead Lab database

#### filter_whitehead
* create table containing records from the Whitehead Lab database overlapping with studyArea

[_example use_](#filter_whitehead)

**Variable name** | **Input**  
--------------|-----------------------------------
**whitehead** |  

#### intersect_points_whitehead  
* find overlap between the Whitehead Lab database and studyArea

[_example use_](#intersect_points_whitehead)

**Variable name** | **Input**  
--------------|-----------------------------------
**whitehead_filter** |  
**studyArea** |  

#### table_whitehead
* create table of overlapping data from Whitehead Lab database  

[_example use_](#table_whitehead)

**Variable name** | **Input**  
--------------|-----------------------------------
**whitehead_filter** |  
**studyArea** |  

## North Atlantic Right Whale Consortium (NARWC) database  

#### filter_narwc
* create table containing records from the NARWC database overlapping with studyArea

[_example use_](#filter_narwc)

**Variable name** | **Input**  
--------------|-----------------------------------
**narwc** |  

#### intersect_points_narwc  
* find overlap between the NARWC database and studyArea

[_example use_](#intersect_points_narwc)

**Variable name** | **Input**  
--------------|-----------------------------------
**narwc_filter** |  
**studyArea** |  

#### table_narwc
* create table of overlapping data from NARWC database  

[_example use_](#table_narwc)

**Variable name** | **Input**  
--------------|-----------------------------------
**narwc_filter** |  
**studyArea** |  


##Ocean Biodiversity Information System

#### filter_obis
* create table containing records from the OBIS database overlapping with studyArea

[_example use_](#filter_obis)

**Variable name** | **Input**  
--------------|-----------------------------------
**obis** |  

#### intersect_points_obis  
* find overlap between the OBIS database and studyArea

[_example use_](#intersect_points_obis)

**Variable name** | **Input**  
--------------|-----------------------------------
**obis_filter** |  
**studyArea** |  

#### table_obis
* creat table of overlapping data from OBIS database  

[_example use_](#table_obis)

**Variable name** | **Input**  
--------------|-----------------------------------
**obis_filter** |  
**studyArea** |  

#### sdm_table
* creat table of overlapping data from Priority Areas to Enhance Monitoring of Cetaceans  

[_example use_](#sdm_table)

**Variable name** | **Input**  
--------------|-----------------------------------
**fin_whale_sf** |  
**harbour_porpoise_sf** |  
**humpback_whale_sf** |  
**sei_whale_sf** |  
**studyArea** | 

#### blue_whale_habitat_overlap
* create table of overlapping data from Important Blue Whale Habitat  

[_example use_](#blue_whale_habitat_overlap)

**Variable name** | **Input**  
--------------|-----------------------------------
**Blue_Whale_sf** |  
**studyArea** | 

#### EBSA_overlap
* creat table of overlapping data from Ecologically and Biologically Significant Areas (EBSA)

[_example use_](#EBSA_overlap)

**Variable name** | **Input**  
--------------|-----------------------------------
**EBSA_sf** |  
**studyArea** | 

#### EBSA_report
* determine whether studyArea overlaps with EBSA

[_example use_](#EBSA_report)

**Variable name** | **Input**  
--------------|-----------------------------------
**EBSA_sf** |  
**studyArea** | 

#### EBSA_reporturl
* print url of report corresponding to EBSA that overlaps with studyArea

[_example use_](#EBSA_reporturl)

**Variable name** | **Input**  
--------------|-----------------------------------
**EBSA_sf** |  
**studyArea** | 

#### EBSA_location
* print name of EBSA that overlaps with studyArea

[_example use_](#EBSA_location)

**Variable name** | **Input**  
--------------|-----------------------------------
**EBSA_sf** |  
**studyArea** | 

#### EBSA_bioregion 
* determine if an EBSA overlaps with studyArea

[_example use_](#EBSA_bioregion )

**Variable name** | **Input**  
--------------|-----------------------------------
**EBSA_sf** |  
**studyArea** | 




















