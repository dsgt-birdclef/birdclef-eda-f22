# acmiyaguchi

This is the directory for work done by @acmiyaguchi.
I'm currently leading the BirdCLEF EDA group as part of [Data Science @ Georgia Tech][dsgt].
I am interested in exploring embeddings from previously trained models like [BirdNET] and [MixIT].

[dsgt]: https://datasciencegt.org/
[birdnet]: https://github.com/kahst/BirdNET
[mixit]: https://bird-mixit.github.io/

## Explorations

### Data

```bash
suffix=raw/birdclef-2022/train_audio
mkdir -p data/${suffix}
gcloud storage cp -r gs://birdclef-2022/${suffix}/afrsil1 data/${suffix}
```

### Configuring docker

```bash
gcloud auth configure-docker us-central1-docker.pkg.dev
```

### BirdNET

For the non-GPU version of the BirdNET model:

```bash
docker-compose -f docker/docker-compose.birdnet.yml build
docker-compose -f docker/docker-compose.birdnet.yml push
```
