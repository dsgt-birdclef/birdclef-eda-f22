# Siying README file

2022-11-06:

1. load up Birdnet model result in parquet file (Reference: https://github.com/dsgt-birdclef/birdclef-eda-f22/blob/main/users/acmiyaguchi/notebooks/2022-10-30-birdnet-analyze-v1.ipynb)
2. run initial analysis

- bird species analysis:
  - how many unique bird species are identified?
  - what are top 10 commonly identified bird species?
- confidence analysis:
  - avg confidence level of each bird species
    - top 10

2022-11-20:

1. Merge model result dataset with training metadata and bird family data
2. Compare the rating given by the author of audio of the different birds with the confidence value given by the model

- rating: the quality of audio
- confidence: the model's confident value that the result is true
- hypothesis: if the rating is high, the model should have higher confidence value

3. identify model is relatively more confident to identify bird Common Sandpiper than other ten most common bird species in the result dataset
4. Analyze bird Common Sandpiper:

- find that the birds belonging to the same bird family as common sandpiper are more likely to appear in the same audio file with common sandpiper
