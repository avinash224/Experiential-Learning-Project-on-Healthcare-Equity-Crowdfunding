# -*- coding: utf-8 -*-
"""
Created on Wed May 27 17:16:04 2020

@author: NISARG
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

df = pd.read_csv("C:/Users/NISARG/Desktop/Nisarg_Bhatt/Experential/Week_3/Book1.csv",encoding='cp1252')
print(df["Comments:"].head)

from nltk.sentiment.vader import SentimentIntensityAnalyzer
sid = SentimentIntensityAnalyzer()

df["Comments:"] = df['Comments:'].fillna(method = "ffill")

compound_score = []

for i in range(len(df["Comments:"])):
    message_text = df["Comments:"][i]
    
    scores = sid.polarity_scores(message_text)

    for key in sorted(scores):
        print('{0}: {1}, '.format(key, scores[key]), end='')
    
    compound_score_final = scores["compound"]
    
    compound_score.append(compound_score_final)

print(compound_score)

nlp = pd.DataFrame(df["Comments:"])
nlp["Scores"] = compound_score

nlp = nlp.iloc[:9]


print(nlp.head())

#nlp.to_csv (r'C:/Users/NISARG/Desktop/Nisarg_Bhatt/Experential/nlp_score_1.csv', index = False, header=True)
'''    
    

message_text = 'Problem is described well with a great pivot to a potential solution'

scores = sid.polarity_scores(message_text)

for key in sorted(scores):
        print('{0}: {1}, '.format(key, scores[key]), end='')

'''

#Numerical
print(df.dtypes)
df = df.select_dtypes(exclude=['object'])
df_new = df.corr()
#sns.heatmap(df.corr())

df_check = df_new['How likely is it that the startup will meet its projected 12 month milestones?']
df_check = df_check.to_frame()

df_check.to_csv (r'C:/Users/NISARG/Desktop/Nisarg_Bhatt/Experential/numerical.csv', index = False, header=True)


print(df_check)


#Model
data = pd.read_csv("C:/Users/NISARG/Desktop/Nisarg_Bhatt/Experential/data.csv",encoding='cp1252')
print(data)

#Removing All the columns with minimum significance
df = df.drop(['Has the startup receive market validation?','How well is the problem defined?',
              'How realistic are the 12 month research goals?',
              'Does the clinical/scientific team have relevant prior experience with startups?',
              'Rate the clinical barriers to adoption faced by the startup.'], axis = 1) 

print(df.columns)

X = df.drop(['How likely is it that the startup will meet its projected 12 month milestones?'], axis = 1)
y = df['How likely is it that the startup will meet its projected 12 month milestones?']

from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

from sklearn import linear_model
from sklearn.metrics import mean_squared_error, r2_score
regr = linear_model.LinearRegression()
regr.fit(X_train, y_train)
y_pred = regr.predict(X_test)

print('Coefficients: \n', regr.coef_)
# The mean squared error
print('Mean squared error: %.2f'
      % mean_squared_error(y_test, y_pred))

