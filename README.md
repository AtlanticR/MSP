# Reproducible Report for Species in Maritimes Region - for Internal DFO use only

<!-- badges: start -->
<!-- badges: end -->

This package was developed to streamline the process of generating science information and advice required to ultimately support a variety of cross-sectoral departmental assessments, regulatory reviews, and reporting activities. It is intended to increase reporting efficiency and facilitate the availability of species information and occurrence data in a reproducible and transparent manner. This reporting tool was developed to summarize data and should not be viewed as a data developing tool.

How to use this report?
Each query of the reproducible report tool begins with the submission of a search polygon which consists of a central location (or path) representing the spatial dimensions of a proposed project/activity surrounded by an exposure zone or buffer area. Each of the maps produced in the report show wildlife information relative to the search polygon (highlighted in yellow and surrounded by a buffer area in blue). 

The resulting search results are separated into the sections defined above. Within these sections, the data sources are defined along with dates of access, URLs and contact information. For each data source, the report also provides caveats and sources of uncertainty as well as a ranking in the Tiers of Data Quality (defined below). Where applicable summary tables and figures are provided. Reports should be circulated to appropriate staff listed in the contact information provided for each data source to verify and supplement the information generated to support science advice processes. Users can request additional information, and access to data and metadata directly to each contact. 

Important Disclaimers
This report is for internal DFO use only. No maps, layers, or data that violate the rule of 5 will be shared outside of the department. 
This report is not a data developing or analytical tool.
The absence of a species in this report should be interpreted as an absence of reporting, not as an absence of the species in the area. 
The focus of this report is on species presence and not on associated numbers, frequency, or catch information. 
Coastal and offshore areas of the Scotian Shelf bioregion are generally not adequately sampled, and hence information on these space and time scales is generally not contained within the various data sources available to the DFO, including the surveys referred to in this document. Therefore, the exact distribution of some species featured in the report may remain uncertain.

Once the search area has been defined, users are presented with several options, including which search results to include in the report. The current release of the reproducible report focuses on species at risk that have been listed by the Species at Risk Act (SARA), or assessed by the Committee on the Status of Endangered Wildlife in Canada (COSEWIC) and Wild species listings. Recognizing the importance of considering an ecosystem approach, users can also include additional information for other species (e.g., commercial, recreational, ecologically significant) and ecosystem components (e.g., habitat) in the report. Indeed, many of the programs under DFO’s mandate to sustainably manage fisheries and aquaculture, ensure that Canada’s oceans and other aquatic ecosystems are protected from negative impacts, and protect the environment when emergencies arise, could benefit from this additional section. 

Comprehensive reports are divided into the following sections:

Search results for species listed by the Species At Risk Act, assessed by COSEWIC, and/or Wild Species:
-Information from National Aquatic Species At Risk Program,
-Fish and Invertebrates,
-Cetaceans. 	

Search results for additional species and information (optional):
-Species not listed by the Species at Risk Act (SARA), or assessed by the Committee on the Status of Endangered Wildlife in Canada (COSEWIC) and Wild -species,
-Habitat information,
-Designated areas.

Package Dependencies:

data.table          1.13.6      CRAN
dplyr               1.0.2       CRAN
easypackages        0.1.0       CRAN
ggplot2             3.3.2       CRAN
ggspatial           1.1.5       CRAN
gridExtra           2.3         CRAN
kableExtra          1.3.1       CRAN
knitr               1.30        CRAN
lubridate           1.7.9.2     CRAN
maps                3.3.0       CRAN
Mar.datawrangling   2021.02.05  GitHub
raster              3.4-5       CRAN
RCurl               1.98-1.2    CRAN
rgdal               1.5-23      CRAN
sf                  0.9-7       CRAN
stars               0.4-3       CRAN
stringr             1.4.0       CRAN
standardPrintOutput 0.0.0.9000  GitHub
tidyverse           1.3.0       CRAN

Directory Setup in ASCII format:

|
+---Data
|   +---Boundaries
|   |   \---Coast50K
|   |       \---Coastline50k_SHP
|   +---mar.wrangling
|   +---NaturalResources
|   |   \---Species
|   |       +---Cetaceans
|   |       |   +---BlueWhaleHabitat_FGP
|   |       |   +---NARWC
|   |       |   +---NorthernBottlenoseWhale
|   |       |   +---PriorityAreas_FGP
|   |       |   \---WSDB
|   |       +---OBIS_GBIF_iNaturalist
|   |       +---PassamaquoddyBayBiodiversityTrawl
|   |       \---SpeciesAtRisk
|   |           +---clipped_layers
|   |           \---LeatherBackTurtleCriticalHabitat
|   +---outputs
|   \---Zones
|       +---DFO_EBSA
|       \---SearchPEZpolygons
\---Projects
    \---SearchPEZ
        |   .gitignore
        |   .Rbuildignore
        |   .Rhistory
        |   DESCRIPTION
        |   MSP.Rproj
        |   README.md
        |   
        \---code
                Blue_Whale_habitat.R
                cetacean_priority_areas.R
                EBSA.R
                filter_narwc_new.r
                filter_wsdb.r
                fn_maps.R
                fn_SearchRVData.r
                fn_Search_ISDB_Data.r
                fn_Search_MARFIS_Data.r
                iNat_obis_gbif_data_mining.r
                site_map.r
                
Required data files:
Note: All shapefiles (.shp) also require associated files (.cpg, .dbf, .prj, .shx)

Files provided in the GitHub:
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


Files that shoud be generated by the user:
/Data/NaturalResources/Species/OBIS_GBIF_iNaturalist/OBIS_MAR_priority_records.csv (generated using iNat_obis_gbif_data_mining.r)
/Data/NaturalResources/Species/OBIS_GBIF_iNaturalist/iNaturalist_MAR_priority_records.csv (generated using iNat_obis_gbif_data_mining.r)

Files with restricted access to be acquired by the user:
<ISDB> and <MARFIS> files are generated using the Mar.datawrangling package directly from the ORACLE databases and each .RData file represents a distinct database table.  To download the data directly or to use the processed tables a user would have to have appropriate permissions to the specific database.


Shapefiles must be in CRS 4326 WGS84!!!!





