#!/bin/bash
#SBATCH -p gpu20
#SBATCH -t 20:00:00
#SBATCH -o til_dsc_newsgroup_srk-%j.out
#SBATCH --gres gpu:1

#export HF_DATASETS_CACHE='/HPS/MultiClassSampling/work/zixuan/dataset_cache'

for id in 4
do
    CUDA_VISIBLE_DEVICES=1 python  run.py \
    --bert_model 'bert-base-uncased' \
    --experiment w2v \
    --note random$id \
    --ntasks 10 \
    --class_per_task 2 \
    --task newsgroup \
    --idrandom $id \
    --scenario til_classification \
    --output_dir './OutputBert' \
    --approach w2v_gru_srk_ncl \
    --eval_batch_size 128 \
    --train_batch_size 256 \
    --nepochs=100 \
    --lr=0.05 \
    --lr_min=1e-4 \
    --lr_factor=3 \
    --lr_patience=3 \
    --clipgrad=10000
done
#--nepochs 1
