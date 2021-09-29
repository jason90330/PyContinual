#!/bin/bash
#SBATCH -p gpu20
#SBATCH -t 10:00:00
#SBATCH -o dil_dsc_bert_adapter_mask_ent_last_id_-%j.out
#SBATCH --gres gpu:1


for id in 1
do
     python  run.py \
    --bert_model 'bert-base-uncased' \
    --note random$id,last_id,200 \
    --ntasks 10 \
    --nclasses 2 \
    --task dsc \
    --scenario dil_classification \
    --idrandom $id \
    --output_dir './OutputBert' \
    --approach bert_adapter_mask_ncl \
    --experiment bert \
    --apply_bert_output \
    --apply_bert_attention_output \
    --build_adapter_mask \
    --eval_batch_size 128 \
    --num_train_epochs 20 \
    --train_data_size 200 \
    --last_id
done
#    --train_data_size 2000 \
#    --model_path "./models/fp32/dil_classification/dsc/adapter_mask_ent_200_$id" \
#    --save_model