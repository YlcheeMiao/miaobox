# Jupyter customization script

Install [jupyter-vim-binding](https://github.com/lambdalisue/jupyter-vim-binding/wiki/Installation) with "IPython-notebook-extensions".

Install both Nbextension ([instruction](http://jupyter-contrib-nbextensions.readthedocs.io/en/latest/install.html)) and all the available plugins:
```
pip install jupyter_contrib_nbextensions
jupyter contrib nbextension install --user
```

**Make sure you upgrade to Jupyter 5.0**. Plugins like `scratchpad` does not work well with older Jupyter. Also you don't need the Keyboard shortcut editor plugin for 5.0.

Access `localhost:8888/nbextensions` to install the extra plugins in a GUI. 

Run `./symlink.sh` to customize:

- Jupyter keymap
- Jupyter CSS
- Jupyter config.py
- IPython config.py
- IPython startup script

## Jupyter set password

```
python -m notebook.auth password
```

## References

- Customization wiki: https://github.com/lambdalisue/jupyter-vim-binding/wiki/Customization

- Jupyter themes: https://github.com/dunovank/jupyter-themes
