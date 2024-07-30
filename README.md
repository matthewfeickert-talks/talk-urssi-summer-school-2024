# [Distributing your Science: Turning analyses into scientific tools](https://matthewfeickert-talks.github.io/talk-urssi-summer-school-2024/)

Talk given at as part of the [July 2024 US Research Software Sustainability Institute (URSSI) Summer School on Research Software and Open Science](https://github.com/si2-urssi/summerschool-July2024).

Viewable online [here](https://matthewfeickert-talks.github.io/talk-urssi-summer-school-2024/).

A version of this talk was originally given as part of the [ORIGINS Data Science Lab Forum's 2023 seminar series](https://github.com/matthewfeickert-talks/talk-odsl-forum-seminar-2023).

## Setup

### Conda

To ensure an environment that is able to build all the examples you can use the provided `environment.yml` file

```console
conda env create --yes --file environment.yml
```

### pixi

[Install `pixi`](https://pixi.sh/latest/#installation) and then from the top level of the repository run

```
pixi install
```

To enter into an interactive shell with the `pixi` environment activated run

```
pixi shell
```

## Acknowledgments

* [Matthew Feickert](http://www.matthewfeickert.com/) is supported by the US National Science Foundation under Cooperative Agreements [OAC-1836650](https://nsf.gov/awardsearch/showAward?AWD_ID=1836650) and [PHY-2323298](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2323298) ([IRIS-HEP](https://iris-hep.org/)).
