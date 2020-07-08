"""
IPython starter code
"""
#import go_vncdriver # must be imported before TF
#import tensorflow as tf
import os
import sys
# import cv2
from time import sleep
import logging
import json
import argparse
import time
import re

import numpy as np
import random
import torch
th = torch
import torch.autograd as autograd
import torch.optim as optim
import torch.nn as nn
import torch.nn.functional as F
import torchvision
import torchvision.transforms as transf

from PIL import Image
from collections import *
import matplotlib.pyplot as plt
import seaborn
import math
