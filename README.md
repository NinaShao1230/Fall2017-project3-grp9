# Project: Dogs, Fried Chicken or Blueberry Muffins?
![image](figs/chicken.jpg)
![image](figs/muffin.jpg)

### [Full Project Description](doc/project3_desc.md)

Term: Fall 2017

+ Team 9
+ Team members
	+ Xinghu Wang
	+ Xin Luo
	+ Sihui Shao
	+ Yiwei Na


+ Project summary: In this project, we created a classification engine for images of dogs versus fried chicken versus blueberry muffins. 
     This project includes three stages, features extractions, model selections and prediction. In the feature extractions, we tried to extract SIFT, color features, LBP, HOG, gray features. For model selections, we tried Xgboost, GBM, adaboost, random forest, naive bayes, SVM (linear & kernel), and neutral network. 
     Baseline model: GBM model with all SIFT features. Test Error, training time.
     Advanced model: Adaboost model with all SIFT, color, LBP and gray features. Test Error, training time. 

**Contribution statement**: ([default](doc/a_note_on_contributions.md)) All team members contributed equally in all stages of this project. All team members approve our work presented in this GitHub repository including this contributions statement. 
      + Xin Luo: 
      + Xinghu Wang:
      + Sihui Shao:
      + Yiwei Na: 

Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
├── lib/
├── data/
├── doc/
├── figs/
└── output/
```

Please see each subfolder for a README file.
