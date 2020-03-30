gridIds<-function(data, gridedges, res){
  #res<-unique(diff(gridedges))
  data<-data[which (data< max(gridedges))] 
  Ids<- floor((data-min(gridedges))/res)+1
  return(Ids)
}
