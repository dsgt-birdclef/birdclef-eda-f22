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

#### Building

We build the [old BirdNET model](https://github.com/kahst/BirdNET) which is built on top of theano.
This model is deprecated, so this is only of academic interest (e.g. how does this perform relative to the modern model).

```bash
docker-compose -f docker/docker-compose.birdnet-old.yml build
docker-compose -f docker/docker-compose.birdnet-old.yml push
```

The image for the [BirdNET analyzer model](https://github.com/kahst/BirdNET-Analyzer) is built in a similar way.

```bash
docker-compose -f docker/docker-compose.birdnet.yml build
docker-compose -f docker/docker-compose.birdnet.yml push
```

See [2022-10-23-birdnet-exploration](https://github.com/dsgt-birdclef/birdclef-eda-f22/tree/main/users/acmiyaguchi/notebooks/2022-10-23-birdnet-exploration.ipynb) for an interactive introduction into using the docker images.

### Bird MixIT

#### Building

Building the image is requires a bit more setup. We need to download the model checkpoints [as per the repository instructions](https://github.com/google-research/sound-separation/tree/master/models/bird_mixit):

```bash
gcloud storage cp -r gs://gresearch/sound_separation/bird_mixit_model_checkpoints data/raw/sound_separation
```

Then we can build the docker image:

```bash
docker-compose -f docker/docker-compose.bird-mixit.yml build
docker-compose -f docker/docker-compose.bird-mixit.yml push
```

#### Usage

```bash
docker run --rm \
    -u $(id -u):$(id -g) \
    -it us-central1-docker.pkg.dev/birdclef-eda-f22/birdclef-eda-f22/bird-mixit:latest
```
