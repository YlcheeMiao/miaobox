#!/bin/bash
mkdir -p ~/.jupyter/custom
mkdir -p ~/.ipython/profile_default/startup
ln -fs $(pwd)/custom.js ~/.jupyter/custom/custom.js
ln -fs $(pwd)/custom.css ~/.jupyter/custom/custom.css
ln -fs $(pwd)/jupyter_notebook_config.py ~/.jupyter/
ln -fs $(pwd)/ipython_starter.py ~/.ipython/profile_default/startup/
ln -fs $(pwd)/ipython_config.py ~/.ipython/profile_default/

