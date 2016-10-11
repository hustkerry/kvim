#!/usr/bin/env python
#-*- coding:utf-8 -*-

"""
@author : yao.yu@wenba100.com
@date : 2016年8月1日

descripte the main function of this module:
    
"""
import pickle
import pandas as pd
import matplotlib.pyplot as plt 
import numpy as np
from sklearn.ensemble import GradientBoostingClassifier

import os,sys  
parentdir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))  
sys.path.insert(0,parentdir)
from rank_common import rank_judge
from rank_net import RankNet
from pointwise import mc_rank
from rank_sample import deal_feature, deal_feature_online

def statistic(sort_by = 'rank', reverse = False, top = 5):
    num = 0
    questions = {}
    data = pd.read_csv('./rerank.csv')
    for index, row in data.iterrows():
        ques_index = int(row['ques_index'])
        label_score = int(row['level'])
        rank = int(row['rank'])
        rank_binary = float(row['rank_score_binary'])
        rank_multi = float(row['rank_score_multi'])
        rank_order_multi = float(row['rank_score_order_multi'])
        if not ques_index in questions:
            questions[ques_index] = []
            questions[ques_index].append({'label' : label_score, 'rank' : rank, 'rank_binary' : rank_binary, 'rank_multi' : rank_multi, 'rank_order_multi' : rank_order_multi})
        else:
            questions[ques_index].append({'label' : label_score, 'rank' : rank, 'rank_binary' : rank_binary, 'rank_multi' : rank_multi, 'rank_order_multi' : rank_order_multi})
    all_data = []
    for key in questions:
        temp = sorted(questions[key], key = lambda x: x[sort_by], reverse = reverse)
        data = [item['label'] for item in temp]
        all_data.append(data)
    rank_jg = rank_judge.RankJudger(data = all_data, top = top)
    ndcg_score = rank_jg.ndcg()
    map_score = rank_jg.map_()
    err_score = rank_jg.err()
    return [ndcg_score, map_score, err_score]
    
                
        
        
def train_core():
    data = pd.read_csv('./test_online_all.csv')  
    #data = deal_feature(data, True)
    data = deal_feature_online(data, True)

    rank_net = RankNet()
    rank_net.weight = pickle.load(open('weight_scipy_del_back.txt', 'rb'))
    rank_net.feature_num = len(rank_net.weight)
    #print rank_net.weight
    rank_net_score_no_L2 = rank_net.predict_rank_score(data)
    
    #二分类
    targets = ['level', 'level_01', 'level_12', 'level_23', 'origin']
    index = ['ques_index', 'rank', 'doc_id']
    data_test = pd.read_csv('./test_online_all.csv')  
    train_data = pd.read_csv('./train_online.csv') 
    features = [i for i in data_test.columns if (i not in index and i not in targets)]
    gbm = GradientBoostingClassifier(random_state = 10)
    mulit_class_rank = mc_rank.McRank(classifier = gbm, t_method_a = 1, t_method_func = 'linear')
    mulit_class_rank.fit(train_data[features], train_data['level_01'])
    rank_scores_binary = mulit_class_rank.predict_rank_score(data_test[features])
    
    
    del data
    data = pd.read_csv('./test_online_all.csv')  
    #data = deal_feature(data, True)
    data = deal_feature_online(data, True)
    rank_net_sci = RankNet()
    rank_net_sci.weight = pickle.load(open('weight_scipy_del.txt', 'rb'))
    rank_net_sci.feature_num = len(rank_net_sci.weight)
    #print rank_net.weight
    rank_net_score_L2 = rank_net_sci.predict_rank_score(data)
    
    data['rank_score_binary'] = rank_net_score_no_L2
    data['rank_score_multi'] = rank_net_score_L2
    data['rank_score_order_multi'] = rank_scores_binary
    data.to_csv('rerank.csv', index=False)
    for i in range(len(rank_net.weight)):
        print rank_net.weight[i], rank_net_sci.weight[i]
    
def autolabel(rects, scores, ax):
    # attach some text labels
    for i in range(len(rects)):
        ax.text(rects[i].get_x()+rects[i].get_width()/2.0, rects[i].get_height() + 0.05, '%.3f' % scores[i], ha='center', va='bottom')
        
def draw_bar(scores, name = 'NDCG', y_start = 0, y_end = 1):
    groups = 5
    fig, ax = plt.subplots()  
    fig.set_figwidth(12)
    index = np.arange(0, groups)
    bar_width = 0.2
    opacity = 0.6  
    rects1 = plt.bar(index, scores['base'], bar_width, alpha=opacity, color='r',label='baseline') 
    rects2 = plt.bar(index + bar_width, scores['rank_binary'], bar_width, alpha=opacity, color='g',label='RankNet_W1') 
    rects3 = plt.bar(index + 2*bar_width, scores['rank_multi'], bar_width, alpha=opacity, color='c',label='RankNet_W2') 
    rects4 = plt.bar(index + 3*bar_width, scores['rank_order_multi'], bar_width, alpha=opacity, color='m',label='McRank') 
    
    autolabel(rects1, scores['base'], ax)
    autolabel(rects2, scores['rank_binary'], ax)
    autolabel(rects3, scores['rank_multi'], ax)
    autolabel(rects4, scores['rank_order_multi'], ax)
    
    plt.ylabel(name)  
    plt.title('score by top_n and different methods') 
    plt.xticks(index + bar_width+0.2, ('top 1', 'top 2', 'top 3', 'top 4', 'top 5'))
    plt.ylim(y_start,y_end)  
    plt.legend(loc='upper center', bbox_to_anchor=(0.5, -0.05)) 
    plt.tight_layout()  
    plt.show() 
    
def draw_scores():
    ndcg_scores = {}
    map_scores = {}
    err_scores = {}
    for i in range(1, 6):
        base_scores = statistic(sort_by = 'rank', reverse = False, top = i)
        rank_binary_scores = statistic(sort_by = 'rank_binary', reverse = True, top = i)
        rank_multi_scores = statistic(sort_by = 'rank_multi', reverse = True, top = i)
        rank_order_multi_scores = statistic(sort_by = 'rank_order_multi', reverse = True, top = i)
        if not 'base' in ndcg_scores:
            ndcg_scores['base'] = []
            ndcg_scores['rank_binary'] = []
            ndcg_scores['rank_multi'] = []
            ndcg_scores['rank_order_multi'] = []
            map_scores['base'] = []
            map_scores['rank_binary'] = []
            map_scores['rank_multi'] = []
            map_scores['rank_order_multi'] = []
            err_scores['base'] = []
            err_scores['rank_binary'] = []
            err_scores['rank_multi'] = []
            err_scores['rank_order_multi'] = []
        ndcg_scores['base'].append(base_scores[0])
        ndcg_scores['rank_binary'].append(rank_binary_scores[0])
        ndcg_scores['rank_multi'].append(rank_multi_scores[0])
        ndcg_scores['rank_order_multi'].append(rank_order_multi_scores[0])
        map_scores['base'].append(base_scores[1])
        map_scores['rank_binary'].append(rank_binary_scores[1])
        map_scores['rank_multi'].append(rank_multi_scores[1])
        map_scores['rank_order_multi'].append(rank_order_multi_scores[1])
        err_scores['base'].append(base_scores[2])
        err_scores['rank_binary'].append(rank_binary_scores[2])
        err_scores['rank_multi'].append(rank_multi_scores[2])
        err_scores['rank_order_multi'].append(rank_order_multi_scores[2])
    draw_bar(ndcg_scores, 'NDCG', 0.6, 1)
    #draw_bar(map_scores, 'MAP', 0.6, 1)
    draw_bar(err_scores, 'ERR', 0.5, 1)


if __name__ == '__main__':
    print '********************************************ranknet**************************************************'
    train_core()
    draw_scores()
    
    
     
        