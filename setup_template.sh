#!/bin/bash
set -e
set -u

# ADD YOUR OWN DIR
pip install -e ../isaacgym/python
pip install -e ../rsl_rl
pip install -e ../legged_gym

/bin/bash