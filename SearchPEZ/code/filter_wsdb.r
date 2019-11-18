filter_wsdb <- function(wsdb) {

  wsdb_filt <- wsdb[wsdb$COMMONNAME %in% c('PORPOISE-HARBOUR', 'WHALE-FIN', 'WHALE-NORTH ATLANTIC RIGHT',
                                    'WHALE-NORTHERN BOTTLENOSE', 'WHALE-KILLER', 'WHALE-BLUE', "WHALE-SOWERBY'S BEAKED"), ]

  wsdb_filt$COMMONNAME[which(wsdb_filt$COMMONNAME=="PORPOISE-HARBOUR")]= "Harbour Porpoise - Threatened"
  wsdb_filt$COMMONNAME[which(wsdb_filt$COMMONNAME=="WHALE-FIN")]= "Fin Whale - Special Concern"
  wsdb_filt$COMMONNAME[which(wsdb_filt$COMMONNAME=="WHALE-NORTH ATLANTIC RIGHT")]= "North Atlantic Right Whale - Endangered"
  wsdb_filt$COMMONNAME[which(wsdb_filt$COMMONNAME=="WHALE-NORTHERN BOTTLENOSE")]= "Northern Bottlenose Whale - Endangered"
  wsdb_filt$COMMONNAME[which(wsdb_filt$COMMONNAME=="WHALE-KILLER")]= "Killer Whale - No Status"
  wsdb_filt$COMMONNAME[which(wsdb_filt$COMMONNAME=="WHALE-BLUE")]= "Blue Whale - Endangered"
  wsdb_filt$COMMONNAME[which(wsdb_filt$COMMONNAME=="WHALE-SOWERBY'S BEAKED")]= "Sowerby's Beaked Whale - Special Concern"

 return(wsdb_filt)
}

