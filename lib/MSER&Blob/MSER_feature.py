#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Tue Oct 24 17:25:56 2017

@author: KathrynL
"""

##MSER
def extract_lbp(img_path):
    import cv2
    import numpy as np
    from os import listdir
    import pandas as pd
    #img_path="/Users/luoxin/Desktop/training_set/images/"
    
    img_names=listdir(img_path)[1:]
    MSER_df=pd.DataFrame()
    for i in range(len(img_names)):
        print(i)
        img = cv2.imread(img_path+img_names[999], cv2.IMREAD_GRAYSCALE)
        img=cv2.resize(img,(80,80),interpolation = cv2.INTER_LINEAR)
        vis=img.copy()
        mser = cv2.MSER_create(_min_area=50,_max_area=500,_max_variation = 0.5)
        regions = mser.detectRegions(img,None)
        hulls = [cv2.convexHull(p.reshape(-1, 1, 2)) for p in regions]
        MSER_mat=cv2.polylines(vis, hulls, 1, (0, 255, 0))
        #plot    
    #    cv2.destroyAllWindows()
    #    cv2.imshow('img',vis)
    #    cv2.waitKey(3)
    
        MSER_vec=np.reshape(MSER_mat,(1,len(MSER_mat)*len(MSER_mat)))[0]
        vec=MSER_vec.tolist()
        MSER_df[img_names[i]]=vec
    
    
    MSER_df.to_csv("/Users/luoxin/Desktop/MSER_features.csv",index=False)
    
    cv2.destroyAllWindows()
    cv2.imshow('img',vis)
    cv2.waitKey(3)
    
    
    cv2.DescriptorExtractor_create("MSER")

