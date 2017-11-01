#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Tue Oct 31 19:49:48 2017

@author: KathrynL
"""
def extract_lbp(img_dir,type='train'):
    # OpenCV bindings
    import cv2
    # To performing path manipulations 
    #import os 
    from os import listdir
    # Local Binary Pattern function
    from skimage import feature
    # To calculate a normalized histogram 
    from scipy.stats import itemfreq
    import pandas as pd
    #from sklearn.preprocessing import normalize
    # Utility package -- use pip install cvutils to install
    #import cvutils
    # To read class from file
    #import csv
    #img_dir="/Users/luoxin/Desktop/training_set/images/"
    path1 =img_dir
    image_lists = listdir(path1)[1:]
    image_dir_list = []
    for i in range(len(image_lists)):
        image_dir_list.append(path1+image_lists[i])
        
        
    his = [] 
    for i in range(len(image_dir_list)):
    #     print(i)
        im = cv2.imread(image_dir_list[i])
        im_gray = cv2.cvtColor(im, cv2.COLOR_BGR2GRAY)
        radius = 3
        no_points = 8 * radius
        lbp = feature.local_binary_pattern(im_gray, no_points, radius, method='uniform')
        x = itemfreq(lbp.ravel())
        hist = x[:, 1]/sum(x[:, 1])
        his.append(hist)
        print(i)
    
    lbp_df=pd.DataFrame(his)
    lbp_df.to_csv("./lbp_"+type+".csv")
    #return(lbp_df)

#print("done")  
    
    
#with open("/Users/ninashao/Desktop/Fall2017-project3-fall2017-project3-grp9-master 2/data/lbp_feature.csv", "w") as f:
#    writer = csv.writer(f, delimiter =',')
#    writer.writerows(his)