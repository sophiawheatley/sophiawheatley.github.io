---
layout: post
title: OASIS Dataset Analysis
date: 2020-09-02
---

## OASIS Dataset Analysis

I wanted to try out some analysis using a freely available longitudinal dataset containing older participants from [Kaggle](https://www.kaggle.com/jboysen/mri-and-alzheimers). Here's a link to the [original paper](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2895005/).



### Information about the data

The data comes from a project titled "Open Access Series of Imaging Studies (OASIS): Longitudinal MRI Data in Nondemented and Demented Older Adults" by Marcus and colleagues. Participants were taken from a longitudinal pool of the Washington University Alzheimer Disease Research Center (ADRC). There were 150 participants with ages ranging from 60 to 96 years and various measures were taken such as T1-weighted MRI scans, brain volume measure and cognitive tests. These scans were taken at least one year apart with participants having two or more visits each. There were 72 participants that did not have dementia throughout the study, 64 had dementia from baseline including with 51 diagnosed as having mild to moderate Alzheimer's disease and 14 did not have dementia at baseline but were diagnosed with dementia later in the study.


### Columns
* Subject ID  
* MRI ID
* Group - Demented, Non-demented or Converted
* Visit - ordinality of visit 1st, 2nd,... 5th
* MR Delay - number of days between two medical visits
* M/F - Sex
* Hand - Handedness, all were right-handed
* Age - in years
* EDUC - years of education
* SES - social economic status
* MMSE - Mini Mental State Examination score from 0-30, scores of 24 or more indicate normal cognition
* CDR - Clinical Dementia Rating
* eTIV - Estimated total intracranial volume
* nWBV - Normalized whole-brain volume
* ASF - Atlas scaling factor


```python
import pandas as pd
```


```python
oasis_df = pd.read_csv('oasis_longitudinal.csv')

oasis_df = oasis_df.drop(['MRI ID','MR Delay', 'Hand'], axis=1)
oasis_df = oasis_df.rename({'Subject ID': 'Subject_ID'}, axis=1)

oasis_df.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Subject_ID</th>
      <th>Group</th>
      <th>Visit</th>
      <th>M/F</th>
      <th>Age</th>
      <th>EDUC</th>
      <th>SES</th>
      <th>MMSE</th>
      <th>CDR</th>
      <th>eTIV</th>
      <th>nWBV</th>
      <th>ASF</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>OAS2_0001</td>
      <td>Nondemented</td>
      <td>1</td>
      <td>M</td>
      <td>87</td>
      <td>14</td>
      <td>2.0</td>
      <td>27.0</td>
      <td>0.0</td>
      <td>1987</td>
      <td>0.696</td>
      <td>0.883</td>
    </tr>
    <tr>
      <th>1</th>
      <td>OAS2_0001</td>
      <td>Nondemented</td>
      <td>2</td>
      <td>M</td>
      <td>88</td>
      <td>14</td>
      <td>2.0</td>
      <td>30.0</td>
      <td>0.0</td>
      <td>2004</td>
      <td>0.681</td>
      <td>0.876</td>
    </tr>
    <tr>
      <th>2</th>
      <td>OAS2_0002</td>
      <td>Demented</td>
      <td>1</td>
      <td>M</td>
      <td>75</td>
      <td>12</td>
      <td>NaN</td>
      <td>23.0</td>
      <td>0.5</td>
      <td>1678</td>
      <td>0.736</td>
      <td>1.046</td>
    </tr>
    <tr>
      <th>3</th>
      <td>OAS2_0002</td>
      <td>Demented</td>
      <td>2</td>
      <td>M</td>
      <td>76</td>
      <td>12</td>
      <td>NaN</td>
      <td>28.0</td>
      <td>0.5</td>
      <td>1738</td>
      <td>0.713</td>
      <td>1.010</td>
    </tr>
    <tr>
      <th>4</th>
      <td>OAS2_0002</td>
      <td>Demented</td>
      <td>3</td>
      <td>M</td>
      <td>80</td>
      <td>12</td>
      <td>NaN</td>
      <td>22.0</td>
      <td>0.5</td>
      <td>1698</td>
      <td>0.701</td>
      <td>1.034</td>
    </tr>
  </tbody>
</table>
</div>



### Exploratory analysis


```python
import matplotlib.pyplot as plt
oasis_df[oasis_df['Visit'] == 1].hist(['Age', 'EDUC', 'MMSE', 'ASF'],bins = 20);
plt.tight_layout()
```


![png](/assets/notebooks/OASIS_dataset_analysis_files/OASIS_dataset_analysis_4_0.png)


```python
# one plot with three lines for each of the three groups
oasis_df.groupby('Group').hist('Age');
```


![png](/assets/notebooks/OASIS_dataset_analysis_files/OASIS_dataset_analysis_5_0.png)



![png](/assets/notebooks/OASIS_dataset_analysis_files/OASIS_dataset_analysis_5_1.png)



![png](/assets/notebooks/OASIS_dataset_analysis_files/OASIS_dataset_analysis_5_2.png)


The reason for the split for participants with 1 visit is to make sure that there is data for all participants as only 58 participants had 3 scans. The number of participants decreases significantly with 6 people having 5 visits.


```python
oasis_df[oasis_df['Visit'] == 3].count()
```




    Subject_ID    58
    Group         58
    Visit         58
    M/F           58
    Age           58
    EDUC          58
    SES           55
    MMSE          57
    CDR           58
    eTIV          58
    nWBV          58
    ASF           58
    dtype: int64




```python
oasis_df[oasis_df['Visit'] == 5].count()
```




    Subject_ID    6
    Group         6
    Visit         6
    M/F           6
    Age           6
    EDUC          6
    SES           6
    MMSE          6
    CDR           6
    eTIV          6
    nWBV          6
    ASF           6
    dtype: int64



The dummy coding here is necessary for us to run the ANOVA models as these are categorical. Also we want to remove the participants who already have dementia as we want to see what potentially affects whether someone develops dementia.


```python
one_visit = oasis_df[oasis_df['Visit'] == 1] # subset of data
dummies = pd.get_dummies(one_visit["Group"]) # dummy coding for group
one_visit = one_visit.merge(dummies, left_index=True, right_index=True).dropna()
one_visit = one_visit[ one_visit["Demented"] != 1 ] # removed participants who already have dementia
one_visit.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Subject_ID</th>
      <th>Group</th>
      <th>Visit</th>
      <th>M/F</th>
      <th>Age</th>
      <th>EDUC</th>
      <th>SES</th>
      <th>MMSE</th>
      <th>CDR</th>
      <th>eTIV</th>
      <th>nWBV</th>
      <th>ASF</th>
      <th>Converted</th>
      <th>Demented</th>
      <th>Nondemented</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>OAS2_0001</td>
      <td>Nondemented</td>
      <td>1</td>
      <td>M</td>
      <td>87</td>
      <td>14</td>
      <td>2.0</td>
      <td>27.0</td>
      <td>0.0</td>
      <td>1987</td>
      <td>0.696</td>
      <td>0.883</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>5</th>
      <td>OAS2_0004</td>
      <td>Nondemented</td>
      <td>1</td>
      <td>F</td>
      <td>88</td>
      <td>18</td>
      <td>3.0</td>
      <td>28.0</td>
      <td>0.0</td>
      <td>1215</td>
      <td>0.710</td>
      <td>1.444</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>7</th>
      <td>OAS2_0005</td>
      <td>Nondemented</td>
      <td>1</td>
      <td>M</td>
      <td>80</td>
      <td>12</td>
      <td>4.0</td>
      <td>28.0</td>
      <td>0.0</td>
      <td>1689</td>
      <td>0.712</td>
      <td>1.039</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>13</th>
      <td>OAS2_0008</td>
      <td>Nondemented</td>
      <td>1</td>
      <td>F</td>
      <td>93</td>
      <td>14</td>
      <td>2.0</td>
      <td>30.0</td>
      <td>0.0</td>
      <td>1272</td>
      <td>0.698</td>
      <td>1.380</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>19</th>
      <td>OAS2_0012</td>
      <td>Nondemented</td>
      <td>1</td>
      <td>F</td>
      <td>78</td>
      <td>16</td>
      <td>2.0</td>
      <td>29.0</td>
      <td>0.0</td>
      <td>1333</td>
      <td>0.748</td>
      <td>1.316</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>




```python
one_visit.describe()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Visit</th>
      <th>Age</th>
      <th>EDUC</th>
      <th>SES</th>
      <th>MMSE</th>
      <th>CDR</th>
      <th>eTIV</th>
      <th>nWBV</th>
      <th>ASF</th>
      <th>Converted</th>
      <th>Demented</th>
      <th>Nondemented</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>86.0</td>
      <td>86.000000</td>
      <td>86.000000</td>
      <td>86.000000</td>
      <td>86.000000</td>
      <td>86.000000</td>
      <td>86.000000</td>
      <td>86.000000</td>
      <td>86.000000</td>
      <td>86.000000</td>
      <td>86.0</td>
      <td>86.000000</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>1.0</td>
      <td>75.697674</td>
      <td>15.162791</td>
      <td>2.325581</td>
      <td>29.220930</td>
      <td>0.005814</td>
      <td>1473.302326</td>
      <td>0.744767</td>
      <td>1.207535</td>
      <td>0.162791</td>
      <td>0.0</td>
      <td>0.837209</td>
    </tr>
    <tr>
      <th>std</th>
      <td>0.0</td>
      <td>8.125587</td>
      <td>2.691426</td>
      <td>1.067618</td>
      <td>0.859564</td>
      <td>0.053916</td>
      <td>176.483165</td>
      <td>0.037712</td>
      <td>0.139402</td>
      <td>0.371340</td>
      <td>0.0</td>
      <td>0.371340</td>
    </tr>
    <tr>
      <th>min</th>
      <td>1.0</td>
      <td>60.000000</td>
      <td>8.000000</td>
      <td>1.000000</td>
      <td>26.000000</td>
      <td>0.000000</td>
      <td>1123.000000</td>
      <td>0.666000</td>
      <td>0.883000</td>
      <td>0.000000</td>
      <td>0.0</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>1.0</td>
      <td>69.000000</td>
      <td>13.000000</td>
      <td>1.250000</td>
      <td>29.000000</td>
      <td>0.000000</td>
      <td>1347.250000</td>
      <td>0.716500</td>
      <td>1.106500</td>
      <td>0.000000</td>
      <td>0.0</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>1.0</td>
      <td>76.000000</td>
      <td>16.000000</td>
      <td>2.000000</td>
      <td>29.000000</td>
      <td>0.000000</td>
      <td>1442.000000</td>
      <td>0.746500</td>
      <td>1.217500</td>
      <td>0.000000</td>
      <td>0.0</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>1.0</td>
      <td>81.000000</td>
      <td>18.000000</td>
      <td>3.000000</td>
      <td>30.000000</td>
      <td>0.000000</td>
      <td>1586.000000</td>
      <td>0.769000</td>
      <td>1.302750</td>
      <td>0.000000</td>
      <td>0.0</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>max</th>
      <td>1.0</td>
      <td>93.000000</td>
      <td>23.000000</td>
      <td>5.000000</td>
      <td>30.000000</td>
      <td>0.500000</td>
      <td>1987.000000</td>
      <td>0.837000</td>
      <td>1.563000</td>
      <td>1.000000</td>
      <td>0.0</td>
      <td>1.000000</td>
    </tr>
  </tbody>
</table>
</div>



### Questions

1. Which factors most effect whether a participant gets dementia?
2. Which factors affect participants' scores from baseline compared to their second visit?

In order to answer these questions I have used an ANOVA from the statsmodels package.


```python
from statsmodels.formula.api import ols
import statsmodels.api as sm

lm = ols('Converted ~ Age+EDUC+SES+MMSE+CDR+eTIV+nWBV+ASF', data=one_visit).fit()

table = sm.stats.anova_lm(lm, typ=2)

with pd.option_context('display.max_rows', None, 'display.max_columns', None):  # more options can be specified also
    display(table.sort_values("F", ascending=False))
```


<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>sum_sq</th>
      <th>df</th>
      <th>F</th>
      <th>PR(&gt;F)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>SES</th>
      <td>0.554050</td>
      <td>1.0</td>
      <td>4.274423</td>
      <td>0.042050</td>
    </tr>
    <tr>
      <th>CDR</th>
      <td>0.496295</td>
      <td>1.0</td>
      <td>3.828854</td>
      <td>0.054003</td>
    </tr>
    <tr>
      <th>EDUC</th>
      <td>0.173316</td>
      <td>1.0</td>
      <td>1.337110</td>
      <td>0.251119</td>
    </tr>
    <tr>
      <th>eTIV</th>
      <td>0.169517</td>
      <td>1.0</td>
      <td>1.307803</td>
      <td>0.256336</td>
    </tr>
    <tr>
      <th>ASF</th>
      <td>0.139126</td>
      <td>1.0</td>
      <td>1.073343</td>
      <td>0.303434</td>
    </tr>
    <tr>
      <th>Age</th>
      <td>0.087177</td>
      <td>1.0</td>
      <td>0.672562</td>
      <td>0.414691</td>
    </tr>
    <tr>
      <th>MMSE</th>
      <td>0.031221</td>
      <td>1.0</td>
      <td>0.240867</td>
      <td>0.624977</td>
    </tr>
    <tr>
      <th>nWBV</th>
      <td>0.000661</td>
      <td>1.0</td>
      <td>0.005098</td>
      <td>0.943264</td>
    </tr>
    <tr>
      <th>Residual</th>
      <td>9.980727</td>
      <td>77.0</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>


This ANOVA was comparing the simple effects of the variables on the 'Converted' group from participants' first visit to the hospital. The findings from this model, was a significant effect of socioeconomic status: F(1,77) = 4.27, p < .05.

Below the change between scores from baseline and the second visit were calculated. As expected, the education and socioeconomic status values did not change as they are fixed effects.


```python
both_visits = oasis_df[oasis_df['Visit'] <= 2].dropna()
both_visits = both_visits.groupby('Subject_ID').filter(lambda x: len(x) == 2)

both_visits = both_visits.sort_values(["Subject_ID", "Visit"])
both_visits_diff = both_visits.groupby(['Subject_ID'])[['Age', 'EDUC', 'SES', 'MMSE',
       'CDR', 'eTIV', 'nWBV', 'ASF']].diff().dropna()
both_visits = both_visits[["Subject_ID", "Group"]].merge(both_visits_diff, left_index=True, right_index=True)

dummies = pd.get_dummies(both_visits["Group"])
both_visits = both_visits.merge(dummies, left_index=True, right_index=True).dropna()

both_visits = both_visits[ both_visits["Demented"] != 1 ]

both_visits.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Subject_ID</th>
      <th>Group</th>
      <th>Age</th>
      <th>EDUC</th>
      <th>SES</th>
      <th>MMSE</th>
      <th>CDR</th>
      <th>eTIV</th>
      <th>nWBV</th>
      <th>ASF</th>
      <th>Converted</th>
      <th>Demented</th>
      <th>Nondemented</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1</th>
      <td>OAS2_0001</td>
      <td>Nondemented</td>
      <td>1.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>3.0</td>
      <td>0.0</td>
      <td>17.0</td>
      <td>-0.015</td>
      <td>-0.007</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>6</th>
      <td>OAS2_0004</td>
      <td>Nondemented</td>
      <td>2.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>-1.0</td>
      <td>0.0</td>
      <td>-15.0</td>
      <td>0.008</td>
      <td>0.018</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>8</th>
      <td>OAS2_0005</td>
      <td>Nondemented</td>
      <td>3.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>1.0</td>
      <td>0.5</td>
      <td>12.0</td>
      <td>-0.001</td>
      <td>-0.007</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>14</th>
      <td>OAS2_0008</td>
      <td>Nondemented</td>
      <td>2.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>-1.0</td>
      <td>0.0</td>
      <td>-15.0</td>
      <td>0.005</td>
      <td>0.016</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>20</th>
      <td>OAS2_0012</td>
      <td>Nondemented</td>
      <td>2.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>-10.0</td>
      <td>-0.010</td>
      <td>0.010</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>




```python
both_visits.describe()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Age</th>
      <th>EDUC</th>
      <th>SES</th>
      <th>MMSE</th>
      <th>CDR</th>
      <th>eTIV</th>
      <th>nWBV</th>
      <th>ASF</th>
      <th>Converted</th>
      <th>Demented</th>
      <th>Nondemented</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>82.000000</td>
      <td>82.0</td>
      <td>82.0</td>
      <td>82.000000</td>
      <td>82.000000</td>
      <td>82.000000</td>
      <td>82.000000</td>
      <td>82.000000</td>
      <td>82.000000</td>
      <td>82.0</td>
      <td>82.000000</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>2.109756</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>-0.256098</td>
      <td>0.048780</td>
      <td>5.634146</td>
      <td>-0.008354</td>
      <td>-0.003902</td>
      <td>0.146341</td>
      <td>0.0</td>
      <td>0.853659</td>
    </tr>
    <tr>
      <th>std</th>
      <td>0.916328</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>1.340821</td>
      <td>0.168687</td>
      <td>24.268311</td>
      <td>0.010230</td>
      <td>0.018681</td>
      <td>0.355623</td>
      <td>0.0</td>
      <td>0.355623</td>
    </tr>
    <tr>
      <th>min</th>
      <td>0.000000</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>-5.000000</td>
      <td>-0.500000</td>
      <td>-64.000000</td>
      <td>-0.037000</td>
      <td>-0.097000</td>
      <td>0.000000</td>
      <td>0.0</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>2.000000</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>-1.000000</td>
      <td>0.000000</td>
      <td>-8.500000</td>
      <td>-0.016000</td>
      <td>-0.012000</td>
      <td>0.000000</td>
      <td>0.0</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>2.000000</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>3.000000</td>
      <td>-0.007000</td>
      <td>-0.004000</td>
      <td>0.000000</td>
      <td>0.0</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>2.000000</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.750000</td>
      <td>0.000000</td>
      <td>14.750000</td>
      <td>-0.001000</td>
      <td>0.006750</td>
      <td>0.000000</td>
      <td>0.0</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>max</th>
      <td>5.000000</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>3.000000</td>
      <td>0.500000</td>
      <td>123.000000</td>
      <td>0.015000</td>
      <td>0.052000</td>
      <td>1.000000</td>
      <td>0.0</td>
      <td>1.000000</td>
    </tr>
  </tbody>
</table>
</div>



An analysis on the change in values from visit 1 and visit 2 were compared using ANOVA. The model is very simple looking at the effect of the selected variables on the 'Converted' group. The ANOVA table shows us that the only significant effect is the MMSE : F(1,76) = 9.23, p < .05. As this test is used widely for the diagnosis of Alzheimer's disease and Mild Cognitive Impairment - I can't say that I am surprised.


```python
from statsmodels.formula.api import ols
import statsmodels.api as sm

lm = ols('Converted ~ Age+EDUC+SES+MMSE+eTIV+nWBV+ASF', data=both_visits).fit()

table = sm.stats.anova_lm(lm, typ=2)

with pd.option_context('display.max_rows', None, 'display.max_columns', None):  
    display(table.sort_values("F", ascending=False))
```


<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>sum_sq</th>
      <th>df</th>
      <th>F</th>
      <th>PR(&gt;F)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>MMSE</th>
      <td>1.034612</td>
      <td>1.0</td>
      <td>9.229063</td>
      <td>0.003264</td>
    </tr>
    <tr>
      <th>Age</th>
      <td>0.356191</td>
      <td>1.0</td>
      <td>3.177338</td>
      <td>0.078660</td>
    </tr>
    <tr>
      <th>nWBV</th>
      <td>0.011161</td>
      <td>1.0</td>
      <td>0.099564</td>
      <td>0.753219</td>
    </tr>
    <tr>
      <th>eTIV</th>
      <td>0.001202</td>
      <td>1.0</td>
      <td>0.010724</td>
      <td>0.917795</td>
    </tr>
    <tr>
      <th>EDUC</th>
      <td>0.000866</td>
      <td>1.0</td>
      <td>0.007729</td>
      <td>0.930176</td>
    </tr>
    <tr>
      <th>ASF</th>
      <td>0.000820</td>
      <td>1.0</td>
      <td>0.007311</td>
      <td>0.932086</td>
    </tr>
    <tr>
      <th>SES</th>
      <td>0.000052</td>
      <td>1.0</td>
      <td>0.000463</td>
      <td>0.982891</td>
    </tr>
    <tr>
      <th>Residual</th>
      <td>8.519879</td>
      <td>76.0</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>


I do want to emphasize that this is a mere exercise for me to test out using ANOVAs in Python and I am not claiming that my results can be used as any kind of 'proof' of what causes dementia. Especially as the data is not as large as other population datasets with thousands of participants. I also want to say that this project does not end here and I will be making a follow-up post using other methods e.g. Linear Mixed-Effects Model. Furthermore I would like to explore more questions in relation to this dataset other than the two mentioned in this post.
