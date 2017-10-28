#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Thu Oct 26 16:18:19 2017

@author: KathrynL
"""
import pandas as pd

path="/Users/luoxin/Desktop/[ADS]Advanced Data Science/Fall2017-project3-fall2017-project3-grp9/"
orb_df=pd.read_csv(path+"data/orb_feature.csv")
columns=["orb_"+str(i) for i in range(1,33)]
columns.append("Image")

orb_df.columns=columns

from sklearn.cluster import KMeans
kmeans_ord=KMeans(n_clusters=200).fit(orb_df.iloc[:,:32])
orb_df['label']=kmeans_ord.labels_

orb_df.to_csv("/Users/luoxin/Desktop/orb_df_labeled")

