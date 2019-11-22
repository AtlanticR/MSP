library(Mar.datawrangling)

# Investigate ISDB for inshore data ---------------------------------------
get_data('isdb', data.dir = data.dir)
# 7010: FSRS - ECO - AT SEA SAMPLING
# 7011: FSRS - ECO - EXPERIMENTAL
ISTRIPTYPECODES = ISTRIPTYPECODES[ISTRIPTYPECODES$TRIPCD_ID %in% c(7010,7011),]
self_filter()

fs7010 = unique(ISFISHSETS[ISFISHSETS$TRIP_ID %in% unique(ISTRIPS[ISTRIPS$TRIPCD_ID==7010,"TRIP_ID"]), "FISHSET_ID"])
save_data(df = ISSETPROFILE_WIDE[ISSETPROFILE_WIDE$FISHSET_ID %in% fs7010,], filename = "fs7010")

fs7011 = unique(ISFISHSETS[ISFISHSETS$TRIP_ID %in% unique(ISTRIPS[ISTRIPS$TRIPCD_ID==7011,"TRIP_ID"]), "FISHSET_ID"])
save_data(df = ISSETPROFILE_WIDE[ISSETPROFILE_WIDE$FISHSET_ID %in% fs7011,], filename = "fs7011")

#verified that we want both 7010 and 7011 - do full extractions
get_data('isdb', data.dir = data.dir)
ISTRIPTYPECODES = ISTRIPTYPECODES[ISTRIPTYPECODES$TRIPCD_ID == 7010,]
self_filter()
save_data(db="isdb", filename = "fs7010")

get_data('isdb', data.dir = data.dir)
ISTRIPTYPECODES = ISTRIPTYPECODES[ISTRIPTYPECODES$TRIPCD_ID == 7011,]
self_filter()
save_data(db="isdb", filename = "fs7011")

cleanup('isdb')
# Investigate mfd_inshore -------------------------------------------------
get_data('inshore', data.dir = data.dir)
range(INS_INF$YEAR)
# 1991-2003
self_filter()
save_data(db = 'inshore', filename = "inshore")
cleanup("inshore")

# Investigate 2005 data ---------------------------------------------------
#' since the suspected data is showinhg up as 2006, I thought I should have a 
#' quick look at all data collected in 2005.  I produced a plot of this, from 
#' which I feel there is no patchiness associated with the coastal sites we 
#' discussed
get_data('isdb', data.dir = data.dir)
ISSETPROFILE_WIDE = ISSETPROFILE_WIDE[ISSETPROFILE_WIDE$YEAR == 2005,]
self_filter()
save_data(df = ISSETPROFILE_WIDE, filename = "2005_data")

