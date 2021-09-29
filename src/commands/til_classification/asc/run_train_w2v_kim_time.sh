#!/bin/bash
#SBATCH -p gpu20
#SBATCH -t 10:00:00
#SBATCH -o til_dsc_ncl_full_4-%j.out
#SBATCH --gres gpu:1

#
##L2,
#for id in 4
#do
#    CUDA_VISIBLE_DEVICES=0 python  run.py \
#    --experiment w2v_as \
#    --note random$id \
#    --ntasks 19 \
#    --idrandom $id \
#    --approach w2v_kim_l2_ncl \
#    --eval_batch_size 32 \
#    --train_batch_size 128 \
#    --task asc \
#    --scenario til_classification \
#    --exit_after_first_task \
#    --nepochs 1
#done
#
##EWC
#for id in 4
#do
#    CUDA_VISIBLE_DEVICES=0 python  run.py \
#    --experiment w2v_as \
#    --note random$id \
#    --ntasks 19 \
#    --idrandom $id \
#    --approach w2v_kim_ewc_ncl \
#    --eval_batch_size 32 \
#    --train_batch_size 128 \
#    --task asc \
#    --scenario til_classification \
#    --exit_after_first_task \
#    --nepochs 1
#done


#,UCL,
for id in 4
do
    CUDA_VISIBLE_DEVICES=0 python  run.py \
    --experiment w2v_as \
    --note random$id \
    --ntasks 19 \
    --idrandom $id \
    --approach w2v_kim_ucl_ncl \
    --eval_batch_size 32 \
    --train_batch_size 128 \
    --task asc \
    --scenario til_classification \
    --exit_after_first_task \
    --nepochs 1
done


##OWM
#for id in 4
#do
#    CUDA_VISIBLE_DEVICES=0 python  run.py \
#    --experiment w2v_as \
#    --note random$id \
#    --ntasks 19 \
#    --idrandom $id \
#    --approach w2v_kim_owm_ncl \
#    --eval_batch_size 32 \
#    --train_batch_size 128 \
#    --task asc \
#    --scenario til_classification \
#    --exit_after_first_task \
#    --nepochs 1
#done
#
#
##,HAT
#for id in 4
#do
#    CUDA_VISIBLE_DEVICES=0 python  run.py \
#    --experiment w2v_as \
#    --note random$id \
#    --ntasks 19 \
#    --idrandom $id \
#    --approach w2v_kim_hat_ncl \
#    --eval_batch_size 32 \
#    --train_batch_size 128 \
#    --task asc \
#    --scenario til_classification \
#    --exit_after_first_task \
#    --nepochs 1
#done
#
