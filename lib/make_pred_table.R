p_ada[which(p_ada!=test_labels)]
test_labels[which(p_ada!=test_labels)]
df_cross<-data.frame(pred=p_ada[which(p_ada!=test_labels)],labels=test_labels[which(p_ada!=test_labels)])

df_haha<-data.frame(matrix(0,3,3))
for(i in 1:64){
  x=df_cross[i,1]+1
  y=df_cross[i,2]+1  
  df_haha[x,y]=df_haha[x,y]+1
} 
colnames(df_haha)<-c("muffin","chicken","dog")
rownames(df_haha)<-paste("pred_",c("muffin","chicken","dog"))
