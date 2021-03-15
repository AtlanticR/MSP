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

Search results for additional species and information (optional):
* Species not listed by the Species at Risk Act (SARA), or assessed by the Committee on the Status of Endangered Wildlife in Canada (COSEWIC) and Wild -species,
* Habitat information,
* Designated areas.

**Required packages**

*data.table (v.1.13.6) [link](https://cran.r-project.org/web/packages/data.table/index.html)  
*dplyr (v.1.0.2) [link](https://cran.r-project.org/web/packages/dplyr/index.html)  
*ggplot2 (v.3.3.2) [link](https://cran.r-project.org/web/packages/ggplot2/index.html)  
*ggspatial (v.1.1.5) [link](https://cran.r-project.org/web/packages/ggspatial/index.html)  
*gridExtra (v.2.3) [link](https://cran.r-project.org/web/packages/gridExtra/index.html)  
*kableExtra (v.1.3.1) [link](https://cran.r-project.org/web/packages/kableExtra/index.html)  
*knitr (v.1.30) [link](https://cran.r-project.org/web/packages/knitr/index.html)  
*lubridate (v.1.7.9.2) [link](https://cloud.r-project.org/web/packages/lubridate/index.html)  
*maps (v.3.3.0) [link](https://cran.r-project.org/web/packages/maps/)  
*raster (v.3.4-5) [link](https://cran.r-project.org/web/packages/raster/)  
*RCurl (v.1.98-1.2) [link](https://cran.r-project.org/web/packages/RCurl/index.html)  
*rgdal (v.1.5-23) [link](https://cran.r-project.org/web/packages/rgdal/index.html)  
*sf (v.0.9-7) [link](https://cran.r-project.org/web/packages/sf/index.html)  
*stars (v.0.4-3) [link](https://cran.r-project.org/web/packages/stars/index.html)  
*stringr (v.1.4.0) [link](https://cran.r-project.org/web/packages/stringr/)  
*tidyverse (v.1.3.0) [link](https://cran.r-project.org/web/packages/tidyverse/index.html)  

Mar.datawrangling   2021.02.05  GitHub
standardPrintOutput 0.0.0.9000  GitHub


***

![directory-diagram](../../../Projects/SearchPEZ/code/directory_structure.jpg)

__Fig 1.__ **Directories** *set up of directories*

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

####SelectRV_fn
*aggregate data from multiple RV survey data files
*produce an sf object (RVCatch_sf) for polygon overlay analysis

[_example use_](#SelectRV_fn)

**Variable name** | **Input**  
--------------|-----------------------------------
**SurveyPrefix** | Prefix indicative of database (ISDB, RV, MARFIS)
**File** | 
**studyArea** | 
**minYear** | 

####SelectMARFIS_fn
*aggregate data from multiple MARFIS data files
*produce an sf object (MARFISCatch_sf) for polygon overlay analysis

[_example use_](#SelectMARFIS_fn)

**Variable name** | **Input**  
--------------|-----------------------------------
**studyArea** | 
**minYear** | 



###Aggregate and filter ISDB survey data
SelectISDB_fn(studyArea, minYear)
>aggregates data from multiple ISDB files and produces an sf object (ISDBCatch_sf).

####SelectMARFIS_fn
*aggregate data from multiple ISDB data files
*produce an sf object (ISDBCatch_sf) for polygon overlay analysis

[_example use_](#SelectISDB_fn)

**Variable name** | **Input**  
--------------|-----------------------------------
**studyArea** | 
**minYear** | 



##Functions used to plot figures and contained in "fn_maps.r"

#Map of studyArea
site_map(studyArea,site_sf,land_layer,buf)


#Map of studyArea with Species at Risk Critical Habitat
plot_crithab(ClippedCritHab_sf, studyArea, land_layer, buf)


#Map of studyArea with Species at Risk Distribution
plot_sardist(sardist_sf, studyArea, land_layer, buf)


#Map of studyArea with Priority Areas to Enhance Monitoring of Cetaceans
plot_cetaceans_4grid(fin_whale_sf, harbour_porpoise_sf, humpback_whale_sf, 
                    sei_whale_sf, studyArea, land_layer,buf)
                               
#Map of studyArea with Blue Whale habitat wide angle
plot_bw_hab(Blue_Whale_sf, studyArea, land_layer)


#Map of studyArea with Blue Whale habitat zoomed
plot_bw_hab_zoom(Blue_Whale_sf, studyArea, land_layer, buf)


#Map of studyArea with Ecologically and Biologically Significant Areas (EBSA)
plot_EBSA(EBSA_shp, studyArea, land_layer, buf)







##Functions used to intersect data polygons and points with studyArea and contained in "fn_intersect_operations.R"

#SAR distribution
table_dist(sardist_sf,studyArea)

#SAR critical habitat
table_crit(ClippedCritHab_sf,studyArea, leatherback_sf)

#Whale Sightings Database (WSDB)
filter_wsdb(wsdb)
intersect_points_wsdb(wsdb_filter, studyArea)
table_wsdb(wsdb_filter, studyArea)

#Whitehead Lab database
filter_whitehead(whitehead)
intersect_points_whitehead(whitehead_filter, studyArea)
table_whitehead(whitehead_filter, studyArea)

#North Atlantic Right Whale Consortium (NARWC) database
filter_narwc(narwc)
intersect_points_narwc(narwc_filter, studyArea)
table_narwc(narwc_filter, studyArea)

#Ocean Biodiversity Information System
filter_obis(obis)
intersect_points_obis(obis_filter, studyArea)
table_obis(obis_filter, studyArea)

#Species Distribution Models (SDM): Priority Areas to Enhance Monitoring of Cetaceans
sdm_table(fin_whale_sf, harbour_porpoise_sf, humpback_whale_sf, sei_whale_sf, studyArea)


#Blue Whale Important Habitat
blue_whale_habitat_overlap(Blue_Whale_sf, studyArea)

#Ecologically and Biologically Significant Areas (EBSA)
EBSA_overlap(EBSA_sf, studyArea)

#EBSA report
EBSA_report(EBSA_sf, studyArea)

#EBSA report URL
EBSA_reporturl(EBSA_sf, studyArea)

#Location intersect
EBSA_location(EBSA_sf, studyArea)

#Bioregion intersect
EBSA_bioregion <- function(EBSA_sf, studyArea)





















