#!/bin/bash

if [ ! -d "OutputBert" ]; then
  mkdir OutputBert
fi

for id in 1
do
    CUDA_VISIBLE_DEVICES=0 python  run.py \
    --bert_model 'bert-base-uncased' \
    --note random$id,epoch24\
    --ntasks 19 \
    --idrandom $id \
    --output_dir './OutputBert' \
    --approach bert_adapter_attention_mask_ncl \
    --experiment bert_adapter_attention_mask \
    --fp16
done