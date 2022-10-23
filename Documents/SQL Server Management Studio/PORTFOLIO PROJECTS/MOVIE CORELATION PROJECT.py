#!/usr/bin/env python
# coding: utf-8

# In[2]:


# import libraries

import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib
import matplotlib.pyplot as plt
plt.style.use('ggplot')
from matplotlib.pyplot import figure
 
get_ipython().run_line_magic('matplotlib', 'inline')
matplotlib.rcParams['figure.figsize']=(12,8) # adjust the configuration of the plots we will create.


# In[3]:


# Read in the data.

df = pd.read_csv(r"C:\Users\meabh\Downloads\Movies_dataset\movies.csv")


# In[4]:


df


# In[5]:


df.head()


# In[8]:


# Lets see if there are any missing data.

for col in df.columns:
    pct_missing = np.mean(df[col].isnull())
    print('{} - {}%'.format(col, pct_missing))


# In[11]:


df.isnull().sum()


# In[24]:


budget_null = np.where(df.budget.isnull()==True)


# In[26]:


df.iloc[budget_null]  # very imp query.


# In[ ]:





# In[16]:


df.dtypes


# In[19]:


df.info()


# In[10]:


df['budget'].isnull().sum()


# In[13]:


df['budget'].fillna(0, inplace = True)


# In[14]:


df['budget'].isnull().sum()


# In[15]:


#change data type of column

df['budget']= df['budget'].astype('int64')


##4df['gross']= df['gross'].astype.numeric()


# In[16]:


df.dtypes


# In[17]:


df


# In[28]:


df = df.sort_values(by = 'gross', inplace = False, ascending = False )


# In[19]:


pd.set_option('display.max_rows()',None)

##Query to show all the data in the table.


# In[21]:


df['company']


# In[22]:


#Budget High correlation
#company high correlation


# In[27]:


#scatter plot budget vs gross


plt.scatter(x = df['budget'], y = df['gross'])



plt.title('Budget vs Gross Earning')

plt.xlabel('Budget for film')
plt.ylabel('Gross Earning')

plt.show()


# In[29]:


df.head()


# In[32]:


#plot Budget vs Gross in Seaborn

sns.regplot(x='budget', y='gross', data=df, scatter_kws={'color':'red'}, line_kws={'color':'green'})


# In[33]:


#lets start looking at correlations


# In[36]:


df.corr('pearson')  #pearson, kendall, spearman


# In[ ]:


#high correlation between budget and gross


# In[38]:


correlation_matrix = df.corr('pearson')


# In[40]:


sns.heatmap(correlation_matrix, annot = True)

plt.title('Correlation matrix for numeric features')

plt.xlabel('Movie features')
plt.ylabel('Movie features')

plt.show()


# In[ ]:




