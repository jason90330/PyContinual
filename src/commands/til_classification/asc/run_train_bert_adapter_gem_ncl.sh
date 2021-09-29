#!/bin/bash
#SBATCH -p gpu20
#SBATCH -t 10:00:00
#SBATCH -o til_asc_adapter_gem_0.02_4-%j.out
#SBATCH --gres gpu:1


for id in 4
do
     python  run.py \
    --bert_model 'bert-base-uncased' \
    --output_dir './OutputBert' \
    --note random$id,0.02\
    --ntasks 19 \
    --task asc \
    --scenario til_classification \
    --idrandom $id \
    --approach bert_adapter_gem_ncl \
    --experiment bert_adapter \
    --apply_bert_attention_output \
    --apply_bert_output \
    --build_adapter \
    --eval_batch_size 200 \
    --xusemeval_num_train_epochs 10 \
    --bingdomains_num_train_epochs 30 \
    --bingdomains_num_train_epochs_multiplier 3\
    --buffer_size 128 \
    --buffer_percent 0.02 \
    --gamma 0.5 \
    --model_path "./models/fp32/til_classification/asc/adapter_gem_0.02_$id" \
    --save_model \
    --resume_model \
    --resume_from_file "./models/fp32/til_classification/asc/adapter_gem_0.02_$id" \
    --resume_from_task 18
done
#--nepochs 1
#    --learning_rate 3e-4 \
#    --train_batch_size 200 \
