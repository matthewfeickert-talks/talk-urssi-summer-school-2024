class: middle, center, title-slide
count: false

# Distributing your Science:<br> Turning analyses into scientific tools
.large.blue[Matthew Feickert]<br>
.large[(University of Wisconsin-Madison)]
<br>
[matthew.feickert@cern.ch](mailto:matthew.feickert@cern.ch)
<br>

ORIGINS Data Science Lab Forum

September 8th, 2023

---
# My motivations on this topic

.kol-1-2[
.large[
* Postdoc in high energy physics and data science at University of Wisconsin-Madison Data Science Institute
* Analysis Systems area lead for IRIS-HEP
* Member of ATLAS collaboration
   - Happy collaborator of TUM ATLAS group!
* Administrator of Scikit-HEP community organization
* Care about .bold[reusable] open science to be able to push physics forward at the .bold[community scale]
]
]
.kol-1-2[
.center.width-65[[![logo_IRIS-HEP](assets/logos/logo_institution.png)](https://datascience.wisc.edu/institute/)]

.center.width-30[[![logo_IRIS-HEP](assets/logos/logo_IRIS-HEP.png)](https://iris-hep.org/)]

.center.width-40[[![logo_ATLAS](assets/logos/logo_ATLAS.png)](https://atlas.cern/)]

.center.width-30[[![logo_ATLAS](figures/scikit-hep-logo.svg)](https://scikit-hep.org/)]
]

---
# Knowledgeable colleagues

<br>

.grid[
.kol-1-2.center[
<!-- https://avatars.githubusercontent.com/u/4616906?v=4 -->
.circle.width-55[![Henry](figures/collaborators/schreiner.png)]

[Henry Schreiner](http://iscinumpy.dev/)

Princeton University, IRIS-HEP, PyPA, Scikit-Build
]
.kol-1-2.center[
<!-- https://avatars.githubusercontent.com/u/1248413?v=4 -->
.circle.width-50[![Angus](figures/collaborators/hollands.jpg)]

[Angus Hollands](https://github.com/agoose77)

Princeton University, The Executable Books Project
]
]

.center[Most of what we will discuss today has been covered extensively by them]

---
# Hypothetical workflow for the typical scientist

<!-- TODO: Spread this out across multiple slides with images -->

.huge[
1. Work on idea for paper with collaborators
2. Do exploratory analysis in scripts and Jupyter ecosystem
3. As research progresses need to write more complicated functions and workflows
4. Code begins to sprawl across multiple directories
5. Software dependencies begin to become more complicated
6. The code "works on my machine", but what about your collaborators?
]

.center.huge.bold[People heroically press forward, but this is painful, and not reusable]

---
# Reusable science, step by step

.large[
In this first scenario, you will probably see a lot of `sys.path` manipulation and `utils.py`
]

.huge[
```
$ tree examples/edit_sys_path
examples/edit_sys_path
├── code
│   └── utils.py  # helper functions rosen, rosen_der
├── example.py  # want to import rosen, rosen_der
└── jupytext.toml

1 directory, 3 files
```
]

---
# Reusable science, step by step

.large[
In this first scenario, you will probably see a lot of `sys.path` manipulation and `utils.py`
]

.large[
```python
# example.py
import sys
from pathlib import Path

# Make ./code/utils.py visible to sys.path
# sys.path[1] should be after cwd and before virtual environment
sys.path.insert(1, str(Path(__file__).parent / "code"))
from utils import rosen, rosen_der

x0 = np.array([1.3, 0.7, 0.8, 1.9, 1.2])
result = minimize(rosen, x0, method="BFGS",
                  jac=rosen_der, options={"disp": True})
optimized_params = result.x
# array([1.00000004, 1.0000001 , 1.00000021, 1.00000044, 1.00000092])
```
]

---
# Reusable science, step by step

.large[
In this first scenario, you will probably see a lot of `sys.path` manipulation and `utils.py`

* This is _already better_ than having everything in a single massive file
* However, now things are tied to this relative path on your computer

```python
# Make ./code/utils.py visible to sys.path
sys.path.insert(1, str(Path(__file__).parent / "code"))
from utils import rosen, rosen_der
```

and are brittle to refactoring and change

* But we can do much better!
]

---
# Next steps: Packaging your code

.huge[
* Real emphasis is just that .bold[your code is now installable]
   - Anywhere your Python virtual environment is active you can use your code

* So following The Zen of Python this should be very straightforward?
]
.large[
```
$ python -c 'import this' | grep obvious
There should be one-- and preferably only one --obvious way to do it.
Although that way may not be obvious at first unless you're Dutch.
```
]

---
# Next steps: Packaging your code

.huge[
Maybe not so much. :(
]

<!-- Centering wasn't working without HTML -->
<p style="text-align:center;">
   <a href="https://github.com/scientific-python/cookie">
      <img src="figures/cookie-backend-options.png"/; width=50%>
   </a>
</p>

.center.huge[
You might be asking: Why is there more than one thing?
]

---
# Next steps: Packaging your code

.huge[
The .blue[good news]: Python packaging has improved .bold[dramatically] in the last 5 years
]

* It has never been easier to just point your package manager to some code locally, or on the internet, and get working Python code installed and running on your machine regardless of operating system or architecture
* This is a small .bold[miracle]

.huge[
The .red[bad news]: Python packaging has expanded .bold[dramatically] in the last 5 years
]

* By cratering standards the PyPA allowed for an ecosystem of packaging backends to be created to tackle various problems (this is good!)
* This means that our The Zen of Python expectations are violated and we need to make design choices (hard for beginners)

---
# Next steps: Packaging your code

.huge[
The .green[okay news]: You can probably default to the simplest thing
]

* pure Python: Probably [`hatch`](https://github.com/ofek/hatch)
* compiled extensions: Probably [`setuptools` + `pybind11`](https://pybind11.readthedocs.io/) or [`scikit-build-core`](https://scikit-build-core.readthedocs.io/) + [`pybind11`](https://github.com/pybind/pybind11)

.kol-1-2[
<br>
<p style="text-align:center;">
   <a href="https://packaging.python.org/en/latest/tutorials/packaging-projects/">
      <img src="figures/pypa-packaging-tutorial.png"; width=100%>
   </a>
</p>

.caption[[Python Packaging User Guide, Packaging Python Projects Tutorial](https://packaging.python.org/en/latest/tutorials/packaging-projects/)]
]
.kol-1-2[
<p style="text-align:center;">
   <a href="https://learn.scientific-python.org/development/guides/packaging-simple/">
      <img src="figures/scientific-python-packaging.png"; width=100%>
   </a>
</p>

.caption[[Scientific Python Library Development Guide](https://learn.scientific-python.org/development/)]
]

---
# Simple packaging example

.huge[Modern [PEP 518](https://peps.python.org/pep-0518/) compliant build backends just need a single file: `pyproject.toml`]

```
$ tree examples/simple_packaging
examples/simple_packaging
├── LICENSE
├── pyproject.toml  # controls packaging and interactions with tools
├── README.md
├── src
│   └── rosen
│       ├── example.py
│       ├── __init__.py
│       └── _version.py
└── tests
    └── test_example.py

3 directories, 7 files
```

---
# Simple packaging example: `pyproject.toml`

.huge[
What is `.toml`?


> "TOML aims to be a .bold[minimal configuration file format] that's easy to read due to obvious semantics. TOML is designed to map unambiguously to a hash table. TOML should be .bold[easy to parse into data structures] in a wide variety of languages." &mdash; https://toml.io/ (emphasis mine)

In recent years TOML has seen a rise in popularity for configuration files and lock files. Things that need to be easy to read (humans) and easy to parse (machines).
]

---
# Simple packaging example: `pyproject.toml`

.huge[
Defining how your project should get .bold[built]
]

```toml
[build-system]
requires = [
    "hatchling>=1.13.0",
    "hatch-vcs>=0.3.0",
]
build-backend = "hatchling.build"

...
```

---
# Simple packaging example: `pyproject.toml`

.huge[
Defining project .bold[metadata and requirements]
]

```toml
[project]
name = "rosen"
dynamic = ["version"]
description = "Example package for demonstration"
readme = "README.md"
license = { text = "MIT" }  # SPDX short identifier
authors = [
  { name = "Matthew Feickert", email = "matthew.feickert@cern.ch" },
]
requires-python = ">=3.8"

dependencies = [
    "scipy>=1.6.0",
    "numpy",  # compatible versions controlled through scipy
]

...
```

---
# Simple packaging example: `pyproject.toml`

.huge[
Configuring .bold[tooling options and interactions] with other tools
]

```toml
[tool.hatch.version]
source = "vcs"

[tool.hatch.version.raw-options]
local_scheme = "no-local-version"
# Need to give root as we aren't at the same level as the git repo
root = "../.."

[tool.hatch.build.hooks.vcs]
version-file = "src/rosen/_version.py"
...
```

---
# Simple packaging example: Installing your code

You can now .bold[locally install] your package into your Python virtual environment

```
$ cd examples/simple_packaging
$ python -m pip install --upgrade pip wheel
$ python -m pip install .
Successfully built rosen
Installing collected packages: rosen
Successfully installed rosen-0.0.1
$ python -m pip show rosen
Name: rosen
Version: 0.0.1
Summary: Example package for demonstration
Home-page:
Author:
Author-email: Matthew Feickert <matthew.feickert@cern.ch>
License: MIT
Location: ***/lib/python3.11/site-packages
Requires: numpy, scipy
Required-by:
```

---
# Simple packaging example: Installing your code

.huge[
and use it anywhere
]

.large[
```python
# example.py
import numpy as np
from scipy.optimize import minimize

# We can now import our code
from rosen.example import rosen, rosen_der

x0 = np.array([1.3, 0.7, 0.8, 1.9, 1.2])
result = minimize(rosen, x0, method="BFGS",
                  jac=rosen_der, options={"disp": True})
optimized_params = result.x
# array([1.00000004, 1.0000001 , 1.00000021, 1.00000044, 1.00000092])
```
]

---
# Packaging doesn't slow down development

.huge[
[PEP 518](https://peps.python.org/pep-0518/) compliant build backends allow for "[editable installs](https://pip.pypa.io/en/latest/topics/local-project-installs/#editable-installs)"
]

.large[
```
$ python -m pip install --upgrade --editable .
$ python -m pip show rosen | grep --ignore-case 'location'
Location: ***/lib/python3.11/site-packages
Editable project location: ***/examples/simple_packaging
```
]

.huge[
Editable installs add the files in the development directory to Python’s import path. (Only need to re-installation if you change the project metadata.)

Can .bold[develop] your code under `src/` and have .bold[immediate] access to it
]

---
# Packaging compiled extensions

.huge[
With modern packaging infrastructure, packaging compiled extensions requires small extra work
]

```
$ tree examples/compiled_packaging
examples/compiled_packaging
├── CMakeLists.txt  # Addition of CMake
├── LICENSE
├── pyproject.toml  # build backend change
├── README.md
├── src
│   ├── basic_math.cpp  # C++ extension
│   └── rosen_cpp
│       ├── example.py
│       └── __init__.py
└── tests
    └── test_example.py

3 directories, 8 files
```

---
# Packaging compiled extensions

.huge[
.bold[`pyproject.toml`]:

Swap build system to [`scikit-build-core`](https://scikit-build-core.readthedocs.io/) + [`pybind11`](https://github.com/pybind/pybind11)

```toml
[build-system]
requires = [
  "scikit-build-core",
  "pybind11"
  ]
build-backend = "scikit_build_core.build"

...
```
]

---
# Packaging compiled extensions

.huge[
.bold[`CMakeLists.txt`]:
]

.large[
```cmake
# Specify CMake version and project language
cmake_minimum_required(VERSION 3.15...3.26)
project(${SKBUILD_PROJECT_NAME} LANGUAGES CXX)

# Setup pybind11
set(PYBIND11_FINDPYTHON ON)
find_package(pybind11 CONFIG REQUIRED)

# Add the pybind11 module to build targets
pybind11_add_module(basic_math MODULE src/basic_math.cpp)
install(TARGETS basic_math DESTINATION ${SKBUILD_PROJECT_NAME})
```
]

---
# Packaging compiled extensions

.huge[
.bold[`src/basic_math.cpp`]:
]

.large[
```c++
#include <pybind11/pybind11.h>

int add(int i, int j) { return i + j; }

namespace py = pybind11;

PYBIND11_MODULE(basic_math, m) {
  m.def("add", &add, R"pbdoc(
      Add two numbers
  )pbdoc");

...

}
```
]

---
# Packaging compiled extensions: Installing

Installing locally is the same as for the pure-Python example:

```
$ cd examples/simple_packaging
$ python -m pip install --upgrade pip wheel
$ python -m pip install .
Successfully built rosen-cpp
Installing collected packages: rosen-cpp
Successfully installed rosen-cpp-0.0.1
```

Module name is that given in C++:

```python
from rosen_cpp import basic_math

basic_math.add(1, 2)
# 3
```

---
# Going further: Distributing packages

.huge[
If your code is publicly available on the WWW in a Git repository, you've already done a version of distribution!
]

.tiny[
(tiny font sorry)
```
# General pattern is:
# python -m pip install "project @ git+https://example.com/repo/project.git@branch#subdirectory=path"
$ python -m pip install \
  "git+https://github.com/matthewfeickert-talks/talk-odsl-forum-seminar-2023.git#subdirectory=examples/simple_packaging"
```
]

(more reasonable font size, and more common, example)

```
# Works for pure-Python packages
$ python -m pip install --upgrade "git+https://github.com/scikit-hep/pyhf.git"
# as well as packages with compiled extensions
$ python -m pip install --upgrade "git+https://github.com/scikit-hep/iminuit.git"
```

---
# Going further: Distributing packages

.huge[
Ideally we'd prefer a more organized approach: distribution through a .bold[package index]

First we need to create .bold[distributions] of our packaged code.

Distributions that `pip` can install:

* .bold[[source distribution (sdist)](https://packaging.python.org/en/latest/glossary/#term-Source-Distribution-or-sdist)]: A tarfile (`.tar.gz`) of the source files of our package (subset of all the files in the repository)
* .bold[[wheel](https://packaging.python.org/en/latest/glossary/#term-Built-Distribution)]: A zipfile (`.whl`) of the file system structure and package metadata with any dependencies prebuilt
   - No arbitrary code execution, only decompressing and copying of files
]

---
# Going further: Distributing packages

.huge[
To create these .bold[distributions] from source code, rely on our package .bold[build backend] (e.g. [`hatchling`](https://hatch.pypa.io/)) and .bold[build frontend] tool like [`build`](https://pypa-build.readthedocs.io/en/stable/)
]

```
$ python -m pip install --upgrade build
$ python -m build .
* Creating venv isolated environment...
* Installing packages in isolated environment... (hatch-vcs>=0.3.0, hatchling>=1.13.0)
* Getting build dependencies for sdist...
* Building sdist...
* Building wheel from sdist
* Creating venv isolated environment...
* Installing packages in isolated environment... (hatch-vcs>=0.3.0, hatchling>=1.13.0)
* Getting build dependencies for wheel...
* Building wheel...
Successfully built rosen-0.0.1.tar.gz and rosen-0.0.1-py3-none-any.whl
$ ls dist
rosen-0.0.1-py3-none-any.whl  rosen-0.0.1.tar.gz
```

---
# Going further: Distributing packages

.huge[
Can now [securely upload](https://blog.pypi.org/posts/2023-04-20-introducing-trusted-publishers/) the distributions under `./dist/` to [.italic[any] package index](https://packaging.python.org/en/latest/guides/hosting-your-own-index/) that understands how to use them.

The most common is the [Python Package Index (PyPI)](https://pypi.org/) which serves as the default package index for `pip`.

<p style="text-align:center;">
   <a href="https://pypi.org/">
      <img src="figures/pypi-page.png"; width=45%>
   </a>
</p>
]

---
# Distributing packages: [conda-forge](https://conda-forge.org/)

.huge[
The `conda` family of package managers ([`conda`](https://docs.conda.io/), [`mamba`](https://mamba.readthedocs.io/), [`micromamba`](https://mamba.readthedocs.io/en/latest/user_guide/micromamba.html), [`pixi`](https://prefix.dev/docs/pixi/overview)) take an alternative approach from `pip`.

Instead of installing Python packages, they act as general purpose package managers and install .bold[all dependencies] (including Python) as OS and architecture specific .bold[built binaries] (`.conda` files &mdash; `zip`file containing compressed `tar` files) hosted on conda-forge.

Allows an additional level of runtime environment specification not possible with just `pip`, though getting environment solves right can become more complicated.
]

---
# Distributing packages: [conda-forge](https://conda-forge.org/)

.huge[
Popular in scientific computing as arbitrary binaries can be hosted, including compilers (e.g. `gcc`, Fortran) and even the [full NVIDIA CUDA stack](https://twitter.com/jeremyphoward/status/1697435241152127369)!

With the change to full binaries only this also requires that specification of the environment being installed is important.

With sdists and wheels, if there is no compatible wheel available, `pip` will automatically .bold[fall back] to trying to locally build from the sidst. Can't do that if there is .bold[no matching `.conda` binary]!
]

---
# Defining the environment: [Application vs. Library](https://iscinumpy.dev/post/app-vs-library/)

.huge[
Have been reasonably assuming that packaged code can be used in arbitrary environments with other code that is compatible (library-like).

For distributing code, this is probably the correct view, but your analysis is not a library. Your analysis is an application (a hand crafted implementation of code from libraries).

While your analysis might run with arbitrary configurations of the defined libraries and runtimes (.bold[reusable]) want to also have a hash-level specified version for .bold[reproduciblity]: a .bold[lock file]
]

---
# Defining the environment: Lock file

.huge[
Lock files are simple: A hash level record of every dependency in the environment.

Allow for reproducibility by simply being an list of every file to download from the internet.

Should be programmatically generated from a high level requirements file and maintained in version control with your analysis.

* For `pip`: [`pip-tools`](https://pip-tools.readthedocs.io/en/latest/), [`pdm`](https://pdm.fming.dev/), [`pipenv`](https://pipenv.pypa.io/), [`poetry`](https://python-poetry.org/)
* For `conda` family: [`conda-lock`](https://conda.github.io/conda-lock/), [`pixi`](https://prefix.dev/docs/pixi/)
]

---
# Defining the environment: Comparing to Julia

.huge[
The approach of [`pixi`](https://prefix.dev/docs/pixi/) is [similar to Julia](https://pkgdocs.julialang.org/v1/toml-files/).

* `Project.toml`: .bold[describes the project on a high level]
* `Manifest.toml`: .bold[absolute record] of the state of the packages in the environment (a lock file)

Julia's package manager [`Pkg.jl`](https://pkgdocs.julialang.org/v1/) provides users a high level interface to edit `Project.toml` and then automatically updates `Manifest.toml` in response. Reproducibility of environment by default!

* Library: `Project.toml` in version control
* Application: `Project.toml` and `Manifest.toml` in version control
]

---
# Areas still to discuss another time

.huge[
* Full environment specification with Linux (Open Container Initiative (OCI)) container images (Docker, Apptainer, Podman)
* Orchestration of multiple environments inside of an analysis
   - Using workflow languages
* The difficult realities of long term preservation
   - Assumptions of present technologies don't translate forever into the future, infrastructure goes away
   - How to store files that aren't "code" (e.g. images, training data, database files) &mdash; c.f. Zenodo
* What analysis reuse looks like
   - [RECAST](https://arxiv.org/abs/1010.2506) (particle physics)
]

---
# Recommendations: Tooling

.huge[
Don't start your next Python project from scratch! Use the Scientific Python library development Cookiecutter: [`cookie`](https://github.com/scientific-python/cookie)

```
$ pipx install cookiecutter
$ cookiecutter gh:scientific-python/cookie
#  [1/14] The name of your project (package):
# ...
```

`cookie` will setup your repository for you with templated layouts for 11 different build backends and adheres to packaging and development best practices.
]

---
# Recommendations: Community Guides

.huge[
Packaging standards and best practices continue to change and get better. Instead of trying to maintain your own resources .bold[follow and engage] with community resources created by the teams that are building the tools and infrastructure.
]

<p style="text-align:center;">
   <a href="https://learn.scientific-python.org/development/">
      <img src="figures/scientific-python-development-guide.png"; width=60%>
   </a>
</p>
.caption[[Scientific Python Library Development Guide](https://learn.scientific-python.org/development/)]

---
# Recommendations: Collaboration

.large[
Find and start working with Research Software Engineers (RSE).

* I don't think that most scientists care/get excited about learning packaging tools. We just want things to work. RSEs can make that easier and are SUPER knowledgeable!
   - I'm among the "not excited". I care about packaging because I care about reusable tools for science.
]

<p style="text-align:center;">
   <a href="https://society-rse.org/">
      <img src="figures/rse-page.png"; width=40%>
   </a>
</p>
.caption[[Society of Research Software Engineering](https://society-rse.org/)]

---
# Recommendations: Zenodo
.center.huge[Versioned archive of .bold[everything]: code, documents, data products, data sets]

.kol-1-2[
.center.width-95[[![zenodo-landing-page](figures/zenodo-landing-page.png)](https://zenodo.org/)]
.center[DOI for project and each version]
]
.kol-1-2[
.center.width-60[[![why_use_zenodo](figures/why_use_zenodo.png)](https://zenodo.org/)]
]

---
# Summary

.huge[
* Whirlwind tour of lifting analysis code from version control, to packages, distributed binaries, and the rest of the world
* Not a hopeless bog of technical debt, but community infrastructure built by people who you can collaborate with
* Reusable code can be a nucleation point for communities
]

.kol-1-4[
<p style="text-align:center;">
   <a href="https://github.com/">
      <img src="figures/github-mark.svg"; width=95%>
   </a>
</p>
]
.kol-1-4[
<p style="text-align:center;">
   <a href="https://pypi.org/">
      <img src="figures/pypi-logo.svg"; width=95%>
   </a>
</p>
]
.kol-1-4[
<br>
<p style="text-align:center;">
   <a href="https://conda-forge.org/">
      <img src="figures/conda-forge-anvil.png"; width=95%>
   </a>
</p>
]
.kol-1-4[
<p style="text-align:center;">
   <a href="https://paperswithcode.com/">
      <img src="figures/papers-with-code.png"; width=95%>
   </a>
</p>
]

---
# References

1. [Level Up Your Python](https://henryiii.github.io/level-up-your-python/), Henry Schreiner
2. [Python Packaging User Guide, Packaging Python Projects Tutorial](https://packaging.python.org/en/latest/tutorials/packaging-projects/), The PyPA
3. [Scientific Python Library Development Guide](https://learn.scientific-python.org/development/), Scientific Python (originally made by Scikit-HEP)
4. [`cookie`](https://github.com/scientific-python/cookie), Scientific Python (originally made by Scikit-HEP)
5. [INTERSECT's packaging tutorial](https://intersect-training.org/packaging/), INTERSECT

---
class: end-slide, center

Backup

---
# Zenodo: DOI minting made easy

- Everything on Zenodo has a DOI
   - Provides both a .bold[project] DOI (resolves to latest) and .bold[version specific] DOI
- Enable it to [automatically preserve work from GitHub](https://guides.github.com/activities/citable-code/) (can also directly upload, but lose out on automation)
   - Benefit from having a DOI for .bold[every version] regardless of software paper landscape state
- Once you have a DOI, put it .bold[everywhere] (again)
   - Recommend sharing the project DOI and letting users select a specific version if they want it

.center[
.width-80[[![Zenodo_DOI_guide](figures/Zenodo_DOI_guide.png)](https://zenodo.org/account/settings/github/)]
]

---
# Julia ecosystem for easier CUDA

.huge[
Julia's packaging system seems to be working, as using [CUDA libraries in Julia](https://juliagpu.org/) is rather simple.
]

---

class: end-slide, center
count: false

The end.
