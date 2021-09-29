#!/bin/bash
#SBATCH -p gpu20
#SBATCH -t 10:00:00
#SBATCH -o til_dsc_bert_kim_hat_full_4-%j.out
#SBATCH --gres gpu:1

for id in 4
do
     python  run.py \
    --bert_model 'bert-base-uncased' \
    --experiment bert \
    --approach bert_kim_hat_ncl \
    --note random$id,full \
    --ntasks 10 \
    --task dsc \
    --idrandom $id \
    --scenario til_classification \
    --output_dir './OutputBert' \
    --train_batch_size 128 \
    --eval_batch_size 128 \
    --nepochs=100 \
    --lr=0.05 \
    --lr_min=1e-4 \
    --lr_factor=3 \
    --lr_patience=3 \
    --clipgrad=10000
done
#--nepochs 1
#    --train_data_size 200 \
