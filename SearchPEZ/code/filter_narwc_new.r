filter_narwc_new <- function(narwc) {

  narwc_filt <- narwc[narwc$SPECCODE %in% c('HAPO', 'SEWH', 'FIWH','RIWH', 'NBWH',
                                    'KIWH', 'BLWH',  "SOBW"), ]

  narwc_filt$SPECCODE[which(narwc_filt$SPECCODE=="HAPO")]= "Phocoena phocoena"
  narwc_filt$SPECCODE[which(narwc_filt$SPECCODE=="FIWH")]= "Balaenoptera physalus"
  narwc_filt$SPECCODE[which(narwc_filt$SPECCODE=="RIWH")]= "Eubalaena glacialis"
  narwc_filt$SPECCODE[which(narwc_filt$SPECCODE=="NBWH")]= "Hyperoodon ampullatus"
  narwc_filt$SPECCODE[which(narwc_filt$SPECCODE=="KIWH")]= "Orcinus orca"
  narwc_filt$SPECCODE[which(narwc_filt$SPECCODE=="BLWH")]= "Balaenoptera musculus"
  narwc_filt$SPECCODE[which(narwc_filt$SPECCODE=="SEWH")]= "Balaenoptera borealis"
  narwc_filt$SPECCODE[which(narwc_filt$SPECCODE=="SOBW")]= "Mesoplodon bidens"

 return(narwc_filt)
}

