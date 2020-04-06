Grid_fn <- function(data, grid, power, dist ) {
    # Interpolate the sample data (STDWGT) using the large extent grid
    # Using the same values for Power and Search Radius as Anna's script (idp and maxdist)
    test.idw <- gstat::idw(data$STDWGT ~ 1, data, newdata=grid, idp= power, maxdist = dist)

}