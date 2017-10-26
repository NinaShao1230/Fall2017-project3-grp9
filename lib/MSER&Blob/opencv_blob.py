#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Tue Oct 24 22:01:42 2017

@author: KathrynL
"""
import cv2
params = cv2.SimpleBlobDetector_Params()
# Change thresholds
#params.minThreshold = 50;
#params.maxThreshold = 200;

# Filter by Area.
params.filterByArea = True
params.minArea = 20

# Filter by Circularity
params.filterByCircularity = False
params.minCircularity = 0.5

# Filter by Convexity
params.filterByConvexity = False
params.minConvexity = 0.5
params.maxConvexity = 1

# Filter by Inertia
params.filterByInertia = True
params.minInertiaRatio = 0.1

detector = cv2.SimpleBlobDetector_create()


# Read image
img = cv2.imread("/Users/luoxin/Desktop/training_set/images/img_0005.jpg")
img=cv2.resize(img,(128,128),interpolation = cv2.INTER_LINEAR)
# Detect blobs.
keypoints = detector.detect(img)
kp, des = detector.detectAndCompute(img,keypoints)
kp, des = detector.detectAndCompute(img,None)