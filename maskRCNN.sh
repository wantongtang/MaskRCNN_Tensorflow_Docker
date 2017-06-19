#!/bin/bash

# Script to create and compile FastMaskRCNN code

### Cleanup
#rm -rf FastMaskRCNN


### Some dependencies (Python 2.7)
# use 'sudo pip' if installing globally
#pip install sklearn
pip install future
pip install Cython
pip install scikit-image


### MaskRCNN
cd /home/maskrcnn
# git clone https://github.com/CharlesShang/FastMaskRCNN
cd FastMaskRCNN


### Prerequisite
cd ./libs/datasets/pycocotools
make
cd ../../..

### Create directory structure
# mkdir -p data/coco
# mkdir -p data/pretrained_models
# mkdir -p output/mask_rcnn


### Download models
cd data/pretrained_models
if [ ! -f "resnet_v1_50_2016_08_28.tar.gz" ];then
	wget -c http://download.tensorflow.org/models/resnet_v1_50_2016_08_28.tar.gz
fi
tar -xzvf resnet_v1_50_2016_08_28.tar.gz
cd ../..

### Download dataset
cd data/coco
if [ ! -f "train2014.zip" ];then
	wget -c http://msvocds.blob.core.windows.net/coco2014/train2014.zip
fi
unzip train2014.zip
if [ ! -f "val2014.zip" ];then
	wget -c http://msvocds.blob.core.windows.net/coco2014/val2014.zip
fi
unzip val2014.zip
if [ ! -f "instances_train-val2014.zip" ];then
	wget -c http://msvocds.blob.core.windows.net/annotations-1-0-3/instances_train-val2014.zip
fi
unzip instances_train-val2014.zip
if [ ! -f "person_keypoints_trainval2014.zip" ];then
	wget -c http://msvocds.blob.core.windows.net/annotations-1-0-3/person_keypoints_trainval2014.zip
fi
unzip person_keypoints_trainval2014.zip
if [ ! -f "captions_train-val2014.zip" ];then
	wget -c http://msvocds.blob.core.windows.net/annotations-1-0-3/captions_train-val2014.zip
fi
unzip captions_train-val2014.zip
cd ../..

### Generation annotations
python download_and_convert_data.py


### Compile libraries
cd libs
make
cd ..

### Train
python train/train.py


