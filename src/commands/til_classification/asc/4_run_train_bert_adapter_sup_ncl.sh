#!/bin/bash
#SBATCH -p gpu20
#SBATCH -t 10:00:00
#SBATCH -o dil_asc_bert_adapter_sup_4-%j.out
#SBATCH --gres gpu:1


for id in 4
do
     python  run.py \
    --bert_model 'bert-base-uncased' \
    --note random$id,sup\
    --idrandom $id \
    --ntasks 19 \
    --task asc \
    --scenario til_classification \
    --output_dir './OutputBert' \
    --approach bert_adapter_ncl \
    --experiment bert \
    --eval_batch_size 128 \
    --num_train_epochs 10 \
    --apply_bert_output \
    --apply_bert_attention_output \
    --build_adapter \
    --xusemeval_num_train_epochs 10 \
    --bingdomains_num_train_epochs 30 \
    --bingdomains_num_train_epochs_multiplier 3 \
    --temp 1 \
    --base_temp 1 \
    --sup_loss
done
#--nepochs 1
