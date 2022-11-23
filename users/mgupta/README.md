README for my Fall 2022 Project for BIRDCLEF EDA.

Notes from "2021-04-20-simple-mp-groups.ipynb" (Anthony's File):
(for making a affinity/distance matrix with motif snippets of 3 species (inc. osprey, acafly, and acawoo)

- used several training techniques like LogisticRegression, Lasso/Ridge Classification, and Kmeans to group the data after preprocessing with the LabelEncoder class in the sklearn.preprocessing library

Notes from https://www.cs.ucr.edu/~eamonn/MatrixProfile.html (UC Riverside)

- Main Advantages of Matrix Profiling:
  - trivializes data mining tasks
  - efficient to produce
  - algorithms built using Matrix Profiling also tend to be efficient(inherit its desirable properties)
- Other Advantages:
  - exact --> doesn't result in false positives/negatives with the data
  - space efficient --> w/ incremental growth as it progresses
  - allows anytime algorithm
  - can provide conclusions even with null data without false negatives
  - can separate the noisy parts from a motif
