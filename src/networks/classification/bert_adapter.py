#coding: utf-8
import sys
import torch
from transformers import BertModel, BertConfig
import utils
from torch import nn
import torch.nn.functional as F

class Net(torch.nn.Module):

    def __init__(self,taskcla,args):

        super(Net,self).__init__()
        config = BertConfig.from_pretrained(args.bert_model)
        config.return_dict=False
        config.apply_bert_output = args.apply_bert_output
        config.apply_bert_attention_output = args.apply_bert_attention_output
        config.apply_one_layer_shared = args.apply_one_layer_shared
        config.apply_two_layer_shared = args.apply_two_layer_shared
        config.build_adapter_mask = args.build_adapter_mask
        # config.build_adapter = args.build_adapter # of course it should be yes
        config.build_adapter = True # of course it should be yes

        config.build_adapter_ucl = args.build_adapter_ucl
        config.build_adapter_owm = args.build_adapter_owm
        config.build_adapter_grow = args.build_adapter_grow
        config.build_adapter_attention_mask = args.build_adapter_attention_mask
        config.build_adapter_two_modules = args.build_adapter_two_modules
        config.build_adapter_capsule_mask = args.build_adapter_capsule_mask
        config.build_adapter_capsule = args.build_adapter_capsule
        config.build_adapter_mlp_mask = args.build_adapter_mlp_mask
        config.adapter_size = args.bert_adapter_size

        self.bert = BertModel.from_pretrained(args.bert_model,config=config)

        #BERT fixed all ===========
        for param in self.bert.parameters():
            # param.requires_grad = True
            param.requires_grad = False

        #But adapter is open

        #Only adapters are trainable

        if config.apply_bert_output and config.apply_bert_attention_output:
            adaters = \
                [self.bert.encoder.layer[layer_id].attention.output.adapter for layer_id in range(config.num_hidden_layers)] + \
                [self.bert.encoder.layer[layer_id].attention.output.LayerNorm for layer_id in range(config.num_hidden_layers)] + \
                [self.bert.encoder.layer[layer_id].output.adapter for layer_id in range(config.num_hidden_layers)] + \
                [self.bert.encoder.layer[layer_id].output.LayerNorm for layer_id in range(config.num_hidden_layers)]

        elif config.apply_bert_output:
            adaters = \
                [self.bert.encoder.layer[layer_id].output.adapter for layer_id in range(config.num_hidden_layers)] + \
                [self.bert.encoder.layer[layer_id].output.LayerNorm for layer_id in range(config.num_hidden_layers)]

        elif self.apply_bert_attention_output:
            adaters = \
                [self.bert.encoder.layer[layer_id].attention.output.adapter for layer_id in range(config.num_hidden_layers)] + \
                [self.bert.encoder.layer[layer_id].attention.output.LayerNorm for layer_id in range(config.num_hidden_layers)]


        for adapter in adaters:
            for param in adapter.parameters():
                param.requires_grad = True
                # param.requires_grad = False

        self.taskcla=taskcla
        self.dropout = nn.Dropout(args.hidden_dropout_prob)
        self.args = args
        if 'dil' in args.scenario:
            self.last=torch.nn.Linear(args.bert_hidden_size,args.nclasses)
        elif 'til' in args.scenario:
            self.last=torch.nn.ModuleList()
            for t,n in self.taskcla:
                self.last.append(torch.nn.Linear(args.bert_hidden_size,n))


        print('BERT ADAPTER')

        return

    def forward(self,input_ids, segment_ids, input_mask,start_mixup=None,l=None,idx=None,mix_type=None):
        output_dict = {}

        if start_mixup and mix_type is not None and 'tmix' in mix_type:
            print('tmix: ')

            sequence_output,pooled_output = \
                self.bert(input_ids=input_ids, token_type_ids=segment_ids, attention_mask=input_mask,
                          start_mixup=start_mixup,l=l,idx=idx,pre_t='tmix')
            pooled_output = self.dropout(pooled_output)
            # print('tmix')
        else:
            print('others: ')
            sequence_output, pooled_output = \
                self.bert(input_ids=input_ids, token_type_ids=segment_ids, attention_mask=input_mask)
            pooled_output = self.dropout(pooled_output)
            #shared head

        if 'dil' in self.args.scenario:
            y = self.last(pooled_output)
        elif 'til' in self.args.scenario:
            y=[]
            for t,i in self.taskcla:
                y.append(self.last[t](pooled_output))

        output_dict['y'] = y
        output_dict['normalized_pooled_rep'] = F.normalize(pooled_output, dim=1)

        return output_dict