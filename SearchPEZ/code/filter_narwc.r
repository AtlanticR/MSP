filter_narwc <- function(narwc) {

  narwc_filt <- narwc[narwc$SPECCODE %in% c('HAPO', 'FIWH','RIWH', 'NBWH',
                                    'KIWH', 'BLWH', 'SEWH', "SOBW"), ]

  narwc_filt$SPECCODE[which(narwc_filt$SPECCODE=="HAPO")]= "Harbour Porpoise: Threatened (SARA) Special Concern (COSEWIC)"
  narwc_filt$SPECCODE[which(narwc_filt$SPECCODE=="FIWH")]= "Fin Whale: Special Concern (SARA & COSEWIC)"
  narwc_filt$SPECCODE[which(narwc_filt$SPECCODE=="RIWH")]= "North Atlantic Right Whale: Endangered (SARA & COSEWIC)"
  narwc_filt$SPECCODE[which(narwc_filt$SPECCODE=="NBWH")]= "Northern Bottlenose Whale: Endangered (SARA & COSEWIC)"
  narwc_filt$SPECCODE[which(narwc_filt$SPECCODE=="KIWH")]= "Killer Whale: No Status (SARA) & Special Concern (COSEWIC)"
  narwc_filt$SPECCODE[which(narwc_filt$SPECCODE=="BLWH")]= "Blue Whale: Endangered (SARA & COSEWIC)"
  narwc_filt$SPECCODE[which(narwc_filt$SPECCODE=="SEWH")]= "Sei Whale: No Status (SARA) & Endangered (COSEWIC)"
  narwc_filt$SPECCODE[which(narwc_filt$SPECCODE=="SOBW")]= "Sowerby's Beaked Whale: Special Concern (SARA & COSEWIC)"

 return(narwc_filt)
}

