# acmiyaguchi

This is the directory for work done by @acmiyaguchi.
I'm currently leading the BirdCLEF EDA group as part of [Data Science @ Georgia Tech][dsgt].
I am interested in exploring embeddings from previously trained models like [BirdNET] and [MixIT].

[dsgt]: https://datasciencegt.org/
[birdnet]: https://github.com/kahst/BirdNET
[mixit]: https://bird-mixit.github.io/

## Notebooks

- [2022-10-23-birdnet-exploration](https://github.com/dsgt-birdclef/birdclef-eda-f22/tree/main/users/acmiyaguchi/notebooks/2022-10-23-birdnet-exploration.ipynb)
- [2022-10-23-birdcall-distribution](https://github.com/dsgt-birdclef/birdclef-eda-f22/tree/main/users/acmiyaguchi/notebooks/2022-10-23-birdcall-distribution.ipynb)

## Explorations

### Data

```bash
suffix=raw/birdclef-2022/train_audio
mkdir -p data/${suffix}
gcloud storage cp -r gs://birdclef-2022/${suffix}/afrsil1 data/${suffix}
```

### Configuring docker

Make sure to authenticate against the artifact repository.

```bash
gcloud auth configure-docker us-central1-docker.pkg.dev
```

Note that we include the `-u $(id -u):$(id -g)` flag throughout to avoid
permission issues between the container and the local user. This option may be
unnecessary on Mac or Windows, so adjust the commands as appropriate. For
simplicity, we opt to mount our data directory as a volume instead of
individually mounting directories.

### BirdNET

#### Building

We build the [old BirdNET model](https://github.com/kahst/BirdNET) which is
built on top of theano. This model is deprecated, so this is only of academic
interest (e.g. how does this perform relative to the modern model).

```bash
docker-compose -f docker/docker-compose.birdnet-old.yml build
docker-compose -f docker/docker-compose.birdnet-old.yml push
```

The image for the [BirdNET analyzer
model](https://github.com/kahst/BirdNET-Analyzer) is built in a similar way.

```bash
docker-compose -f docker/docker-compose.birdnet.yml build
docker-compose -f docker/docker-compose.birdnet.yml push
```

#### Usage

We can mount our local paths into the container to run the scripts:

```bash
docker run --rm \
    -u $(id -u):$(id -g) \
    -v ${PWD}/data:/mnt/data \
    -e NUMBA_CACHE_DIR=/tmp \
    -it us-central1-docker.pkg.dev/birdclef-eda-f22/birdclef-eda-f22/birdnet:latest \
    analyze.py \
        --i /mnt/data/raw/birdclef-2022/train_audio/afrsil1 \
        --o /mnt/data/processed/birdnet/analysis/afrsil1 \
        --threads 4 \
        --rtype csv
```

Note the `NUMBA_CACHE_DIR` to avoid librosa/numba cache issues (see [this stackoverflow post](https://stackoverflow.com/questions/59290386/runtimeerror-at-cannot-cache-function-shear-dense-no-locator-available-fo)).

See [2022-10-23-birdnet-exploration](https://github.com/dsgt-birdclef/birdclef-eda-f22/tree/main/users/acmiyaguchi/notebooks/2022-10-23-birdnet-exploration.ipynb) for an interactive introduction into using the docker images.

We put together a script to generate analysis of all of the training data, given
that training data from the kaggle competition exists under
`data/raw/birdclef-2022/train_audio`.

```bash
./scripts/birdnet_analyze_batch.sh
```

It turns out to be much simpler to let the docker container run as root, and
then chown the files afterwards. There are error logs that get written to the
code directory within the container, and permission errors can cause some
headaches.

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

We can use the docker compose file to run a wrapper script, with predefined paths for volume mounting:

```bash
docker compose \
    -f docker/docker-compose.bird-mixit.yml \
    run -u $(id -u):$(id -g) \
    bird-mixit \
        python scripts/mixit_ogg_wrapper.py \
            --input /mnt/data/raw/birdclef-2022/train_audio/afrsil1/XC125458.ogg \
            --output /mnt/data/processed/mixit/afrisil1/XC125458.ogg \
            --model_name output_sources4 \
            --num_sources 4
```

We can manually write out the full command:

```bash
docker run --rm \
    -u $(id -u):$(id -g) \
    -v ${PWD}/data:/mnt/data \
    -it us-central1-docker.pkg.dev/birdclef-eda-f22/birdclef-eda-f22/bird-mixit:latest \
        python scripts/mixit_ogg_wrapper.py \
            --input /mnt/data/raw/birdclef-2022/train_audio/afrsil1/XC125458.ogg \
            --output /mnt/data/processed/mixit/afrisil1/XC125458.ogg \
            --model_name output_sources4 \
            --num_sources 4
```

We can also run this GPU support.

```bash
docker run --rm \
    --gpus=all \
    -u $(id -u):$(id -g) \
    -v ${PWD}/data:/mnt/data \
    -it us-central1-docker.pkg.dev/birdclef-eda-f22/birdclef-eda-f22/bird-mixit-gpu:latest \
        python scripts/mixit_ogg_wrapper.py \
            --input /mnt/data/raw/birdclef-2022/train_audio/afrsil1/XC125458.ogg \
            --output /mnt/data/processed/mixit/afrisil1/XC125458.ogg \
            --model_name output_sources4 \
            --num_sources 4
```

We put together a small script that will run the mixit model against all of the
files in a particular species directory, and additionally runs birdnet against
all of the resulting sound separated files.

```bash
./scripts/mixit_batch.sh chukar
```
