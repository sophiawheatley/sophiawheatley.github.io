---
layout: post
title: Linear Mixed Effects Models
date: 2020-09-20
---

## OASIS Dataset Analysis (II)

Link to the original paper
https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2895005/

Aim of this post: use linear mixed-effects models to look at the fixed and random effects in this dataset.

## Linear mixed-effects models (LME)

Linear mixed effects models are based on the simple linear regression model that allow for the measure of both fixed and random effects. Definitions of random and fixed effects are not necessarily to do with the variables themselves but vary depending on the research question. Fixed effects are the effects of variables of interest. In this blog for example one of the variables of interest is the MMSE score so we want to look at its effect on the likelihood of the subject developing dementia. Whereas random effects are usually any variation are a result of regions that are not of interest to us. For example variability between subjects can be seen as a random effect. These models are used for when there is non-independence in the data and are also good for designs with repeated measures as well as data with missing values. Whereas with an ANOVA test, independence of variables and a normally distributed sample is assumed.

## Loading and Preprocessing


```python
import pandas as pd
```


```python
oasis_df = pd.read_csv('oasis_longitudinal.csv')

oasis_df = oasis_df.drop(['MRI ID','MR Delay', 'Hand'], axis=1)
oasis_df = oasis_df.rename({'Subject ID': 'Subject_ID', "M/F" : 'Gender'}, axis=1)
oasis_df['Gender'] = oasis_df['Gender'].astype('category')
oasis_df['Gender'] = oasis_df['Gender'].cat.codes

oasis_df
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
      <th>Gender</th>
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
      <td>1</td>
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
      <td>1</td>
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
      <td>1</td>
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
      <td>1</td>
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
      <td>1</td>
      <td>80</td>
      <td>12</td>
      <td>NaN</td>
      <td>22.0</td>
      <td>0.5</td>
      <td>1698</td>
      <td>0.701</td>
      <td>1.034</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>368</th>
      <td>OAS2_0185</td>
      <td>Demented</td>
      <td>2</td>
      <td>1</td>
      <td>82</td>
      <td>16</td>
      <td>1.0</td>
      <td>28.0</td>
      <td>0.5</td>
      <td>1693</td>
      <td>0.694</td>
      <td>1.037</td>
    </tr>
    <tr>
      <th>369</th>
      <td>OAS2_0185</td>
      <td>Demented</td>
      <td>3</td>
      <td>1</td>
      <td>86</td>
      <td>16</td>
      <td>1.0</td>
      <td>26.0</td>
      <td>0.5</td>
      <td>1688</td>
      <td>0.675</td>
      <td>1.040</td>
    </tr>
    <tr>
      <th>370</th>
      <td>OAS2_0186</td>
      <td>Nondemented</td>
      <td>1</td>
      <td>0</td>
      <td>61</td>
      <td>13</td>
      <td>2.0</td>
      <td>30.0</td>
      <td>0.0</td>
      <td>1319</td>
      <td>0.801</td>
      <td>1.331</td>
    </tr>
    <tr>
      <th>371</th>
      <td>OAS2_0186</td>
      <td>Nondemented</td>
      <td>2</td>
      <td>0</td>
      <td>63</td>
      <td>13</td>
      <td>2.0</td>
      <td>30.0</td>
      <td>0.0</td>
      <td>1327</td>
      <td>0.796</td>
      <td>1.323</td>
    </tr>
    <tr>
      <th>372</th>
      <td>OAS2_0186</td>
      <td>Nondemented</td>
      <td>3</td>
      <td>0</td>
      <td>65</td>
      <td>13</td>
      <td>2.0</td>
      <td>30.0</td>
      <td>0.0</td>
      <td>1333</td>
      <td>0.801</td>
      <td>1.317</td>
    </tr>
  </tbody>
</table>
<p>373 rows × 12 columns</p>
</div>



The dummy coding is done here for the 'Group' column as these are categorical. Also we want to remove the participants who already have dementia as we want to see what potentially affects whether someone develops dementia.


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
      <th>Gender</th>
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
      <td>1</td>
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
      <td>0</td>
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
      <td>1</td>
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
      <td>0</td>
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
      <td>0</td>
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



### Questions

1. Which factors most affect whether a participant develops dementia?
2. Which factors affect participants' scores from baseline compared to their second visit?

For this post, linear mixed effects models are used instead.


```python
both_visits = oasis_df[oasis_df['Visit'] <= 2].dropna()

both_visits = both_visits.groupby('Subject_ID').filter(lambda x: len(x) == 2)
both_visits_EDUC_SES_gender = both_visits[['Subject_ID','EDUC','SES','Gender']] #keep values that do not change
both_visits = both_visits.sort_values(["Subject_ID", "Visit"])
both_visits_diff = both_visits.groupby(['Subject_ID'])[['Age', 'MMSE',
                                                        'CDR', 'eTIV', 'nWBV', 'ASF']].diff().dropna()
both_visits = both_visits[["Subject_ID", "Group"]].merge(both_visits_diff, left_index=True, right_index=True)
both_visits = both_visits.merge(both_visits_EDUC_SES_gender, left_index=True, right_index=True, suffixes=(None,'_y'))
both_visits = both_visits.drop(columns = ['Subject_ID_y'])

dummies = pd.get_dummies(both_visits["Group"])
both_visits = both_visits.merge(dummies, left_index=True, right_index=True).dropna()

both_visits = both_visits[both_visits["Demented"] != 1]
both_visits = both_visits.drop(columns='Group')
```

# Preliminary Tests


```python
import numpy as np
import statsmodels.formula.api as smf
import statsmodels.api as sm
import pylab as py
import seaborn as sns
import matplotlib.pyplot as plt
```


```python
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
      <th>Age</th>
      <th>MMSE</th>
      <th>CDR</th>
      <th>eTIV</th>
      <th>nWBV</th>
      <th>ASF</th>
      <th>EDUC</th>
      <th>SES</th>
      <th>Gender</th>
      <th>Converted</th>
      <th>Demented</th>
      <th>Nondemented</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1</th>
      <td>OAS2_0001</td>
      <td>1.0</td>
      <td>3.0</td>
      <td>0.0</td>
      <td>17.0</td>
      <td>-0.015</td>
      <td>-0.007</td>
      <td>14</td>
      <td>2.0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>6</th>
      <td>OAS2_0004</td>
      <td>2.0</td>
      <td>-1.0</td>
      <td>0.0</td>
      <td>-15.0</td>
      <td>0.008</td>
      <td>0.018</td>
      <td>18</td>
      <td>3.0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>8</th>
      <td>OAS2_0005</td>
      <td>3.0</td>
      <td>1.0</td>
      <td>0.5</td>
      <td>12.0</td>
      <td>-0.001</td>
      <td>-0.007</td>
      <td>12</td>
      <td>4.0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>14</th>
      <td>OAS2_0008</td>
      <td>2.0</td>
      <td>-1.0</td>
      <td>0.0</td>
      <td>-15.0</td>
      <td>0.005</td>
      <td>0.016</td>
      <td>14</td>
      <td>2.0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>20</th>
      <td>OAS2_0012</td>
      <td>2.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>-10.0</td>
      <td>-0.010</td>
      <td>0.010</td>
      <td>16</td>
      <td>2.0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>




```python
model_fit = smf.ols('Converted ~ Age+EDUC+SES+MMSE+eTIV+nWBV+ASF+Gender', data=both_visits).fit()

X = pd.DataFrame(both_visits, columns=['Age','EDUC','SES', 'MMSE','eTIV','nWBV','ASF', 'Gender'])
y = pd.DataFrame(both_visits.Converted)
dataframe = pd.concat([X, y], axis=1)

table = sm.stats.anova_lm(model_fit, typ=2)
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
      <td>1.274274</td>
      <td>1.0</td>
      <td>12.471175</td>
      <td>0.000720</td>
    </tr>
    <tr>
      <th>SES</th>
      <td>0.962042</td>
      <td>1.0</td>
      <td>9.415391</td>
      <td>0.003019</td>
    </tr>
    <tr>
      <th>Age</th>
      <td>0.602529</td>
      <td>1.0</td>
      <td>5.896878</td>
      <td>0.017632</td>
    </tr>
    <tr>
      <th>EDUC</th>
      <td>0.545404</td>
      <td>1.0</td>
      <td>5.337811</td>
      <td>0.023696</td>
    </tr>
    <tr>
      <th>Gender</th>
      <td>0.136944</td>
      <td>1.0</td>
      <td>1.340251</td>
      <td>0.250764</td>
    </tr>
    <tr>
      <th>ASF</th>
      <td>0.035178</td>
      <td>1.0</td>
      <td>0.344279</td>
      <td>0.559180</td>
    </tr>
    <tr>
      <th>eTIV</th>
      <td>0.033727</td>
      <td>1.0</td>
      <td>0.330083</td>
      <td>0.567377</td>
    </tr>
    <tr>
      <th>nWBV</th>
      <td>0.000235</td>
      <td>1.0</td>
      <td>0.002301</td>
      <td>0.961871</td>
    </tr>
    <tr>
      <th>Residual</th>
      <td>7.458961</td>
      <td>73.0</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>



```python
#model values
model_fitted_y = model_fit.fittedvalues
model_residuals = model_fit.resid
model_norm_residuals = model_fit.get_influence().resid_studentized_internal
model_norm_residuals_abs_sqrt = np.sqrt(np.abs(model_norm_residuals))
model_abs_resid = np.abs(model_residuals)
model_leverage = model_fit.get_influence().hat_matrix_diag
model_cooks = model_fit.get_influence().cooks_distance[0]
```

## Q-Q plot

In order to check whether the data used is normally distributed, we can use a quantile-quantile plot. It is a probability plot comparing two probability distributions where the x coordinate is a theoretical quantile and the y-coordinate is the quantile from the actual data. If the distribution is normal then the points will roughly lie on the line *y = x*.


```python
from statsmodels.graphics.gofplots import ProbPlot

QQ = ProbPlot(model_norm_residuals)
plot_lm_2 = QQ.qqplot(line='45', alpha=0.5, color='#4C72B0', lw=1)
plot_lm_2.axes[0].set_title('Normal Q-Q Plot')
plot_lm_2.axes[0].set_xlabel('Theoretical Quantiles')
plot_lm_2.axes[0].set_ylabel('Standardized Residuals');
```


![png](OASIS_dataset_analysis-2_files/OASIS_dataset_analysis-2_15_0.png)


The Q-Q plot shows that there are many outliers that do not fit well on the line indication a deviation from a normal distribution. This makes it evident that another type of statistical model might be better for this dataset.

## Shapiro-Wilk Test
Another more robust test for normality is the Shapiro-Wilk Test (Shapiro & Wilk, 1965) and this was applied to the measures from the data below. For this test the null hypothesis if that the observations are normally distributed.


```python
from scipy.stats import shapiro
from tabulate import tabulate
```


```python
shapiro_results = []

for column in both_visits:
    try:
        s = shapiro(both_visits[column])
        shapiro_results.append([column, s.statistic, s.pvalue])
    except Exception as e:
        pass

df = pd.DataFrame(shapiro_results)
df = df.drop([9,10,11], axis=0) #drop dummy measures
print('Shapiro-Wilk Test \n')
print(tabulate(df, headers=['Measure', 'W statistic', 'p value'],showindex="never",tablefmt="presto"))  
```

    Shapiro-Wilk Test

     Measure   |   W statistic |     p value
    -----------+---------------+-------------
     Age       |      0.84819  | 1.06861e-07
     MMSE      |      0.857197 | 2.17703e-07
     CDR       |      0.431455 | 3.12775e-16
     eTIV      |      0.859982 | 2.72737e-07
     nWBV      |      0.987887 | 0.640755
     ASF       |      0.878246 | 1.28239e-06
     EDUC      |      0.933238 | 0.000356511
     SES       |      0.876038 | 1.05635e-06
     Gender    |      0.578552 | 5.53986e-14


    /usr/local/lib/python3.8/site-packages/scipy/stats/morestats.py:1678: UserWarning: Input data for shapiro has range zero. The results may not be accurate.
      warnings.warn("Input data for shapiro has range zero. The results "


The only variable that seems to be normally distributed here is the nWBV with W = 0.99 and p value = .64, indicating normality. This is expected as these values have already been normalised as mentioned in the paper.

## Linear Mixed Effects Models

In this first model, using the statsmodel function *mixedlm()*, five of the variables are treated as fixed effects with subject as the random effect as defined in the argument *groups*. This would be the equivalent of \begin{equation*} Converted \backsim MMSE... + (1 | Subject)\end{equation*} in R. All of the effects are calculated here in terms of interactions and simple effects. By default and because I have not specified it there is a random intercept for each group. The Bayesian Information Criteria (BIC) is pulled here as well to have a criteria for model fitting: the higher the score, the better. However it should be noted that every time a variable is added this score will increase.


```python
#fit model
mixed = smf.mixedlm('Converted ~ MMSE*nWBV*eTIV*EDUC*SES',data=both_visits, groups=both_visits['Subject_ID'])
mixed_fit = mixed.fit(reml=False)
```

    /usr/local/lib/python3.8/site-packages/statsmodels/regression/mixed_linear_model.py:2189: ConvergenceWarning: The Hessian matrix at the estimated parameter values is not positive definite.
      warnings.warn(msg, ConvergenceWarning)



```python
#print summary
mixed_fit_results = mixed_fit.summary()
print(mixed_fit_results)
BIC_1 = mixed_fit.bic
print('Bayesian Information Criteria (BIC): ', BIC_1)
```

                    Mixed Linear Model Regression Results
    ======================================================================
    Model:                 MixedLM      Dependent Variable:      Converted
    No. Observations:      82           Method:                  ML       
    No. Groups:            82           Scale:                   0.0307   
    Min. group size:       1            Log-Likelihood:          -1.9069  
    Max. group size:       1            Converged:               Yes      
    Mean group size:       1.0                                            
    ----------------------------------------------------------------------
                             Coef.  Std.Err.   z    P>|z|  [0.025   0.975]
    ----------------------------------------------------------------------
    Intercept                 0.094    0.715  0.131 0.896   -1.308   1.496
    MMSE                     -0.904    0.732 -1.234 0.217   -2.338   0.531
    nWBV                    -21.038   77.849 -0.270 0.787 -173.618 131.543
    MMSE:nWBV               -43.271   60.534 -0.715 0.475 -161.916  75.374
    eTIV                      0.007    0.050  0.132 0.895   -0.092   0.106
    MMSE:eTIV                 0.252    0.075  3.379 0.001    0.106   0.398
    nWBV:eTIV                -2.221    6.510 -0.341 0.733  -14.980  10.538
    MMSE:nWBV:eTIV           17.493    5.061  3.456 0.001    7.573  27.413
    EDUC                      0.006    0.043  0.149 0.881   -0.078   0.091
    MMSE:EDUC                 0.078    0.050  1.552 0.121   -0.021   0.177
    nWBV:EDUC                 1.439    5.041  0.285 0.775   -8.442  11.319
    MMSE:nWBV:EDUC            5.166    4.077  1.267 0.205   -2.825  13.156
    eTIV:EDUC                -0.000    0.003 -0.003 0.998   -0.006   0.006
    MMSE:eTIV:EDUC           -0.016    0.005 -3.350 0.001   -0.026  -0.007
    nWBV:eTIV:EDUC            0.013    0.409  0.032 0.974   -0.788   0.814
    MMSE:nWBV:eTIV:EDUC      -1.143    0.328 -3.485 0.000   -1.786  -0.500
    SES                       0.242    0.252  0.959 0.337   -0.253   0.737
    MMSE:SES                  0.267    0.251  1.061 0.289   -0.226   0.760
    nWBV:SES                 34.571   27.602  1.252 0.210  -19.528  88.671
    MMSE:nWBV:SES            27.258   24.879  1.096 0.273  -21.503  76.020
    eTIV:SES                  0.021    0.022  0.960 0.337   -0.022   0.065
    MMSE:eTIV:SES            -0.103    0.029 -3.577 0.000   -0.159  -0.046
    nWBV:eTIV:SES             0.131    2.114  0.062 0.950   -4.011   4.274
    MMSE:nWBV:eTIV:SES       -7.349    1.830 -4.015 0.000  -10.936  -3.761
    EDUC:SES                 -0.021    0.018 -1.156 0.248   -0.055   0.014
    MMSE:EDUC:SES            -0.026    0.019 -1.368 0.171   -0.063   0.011
    nWBV:EDUC:SES            -2.718    2.036 -1.335 0.182   -6.708   1.271
    MMSE:nWBV:EDUC:SES       -2.800    1.827 -1.533 0.125   -6.381   0.781
    eTIV:EDUC:SES            -0.001    0.002 -0.892 0.372   -0.004   0.002
    MMSE:eTIV:EDUC:SES        0.007    0.002  3.341 0.001    0.003   0.011
    nWBV:eTIV:EDUC:SES        0.069    0.144  0.479 0.632   -0.214   0.352
    MMSE:nWBV:eTIV:EDUC:SES   0.493    0.135  3.656 0.000    0.229   0.758
    Group Var                 0.031                                       
    ======================================================================

    Bayesian Information Criteria (BIC):  153.6421986502787



```python
#convert summary results to dataframe
def summary_to_df(results):
    pvals = results.pvalues
    coeff = results.params
    conf_lower = results.conf_int()[0] #lower confidence interval of the fitted parameters
    conf_higher = results.conf_int()[1]

    results_df = pd.DataFrame({"pvals":pvals,
                               "coeff":coeff,
                               "conf_lower":conf_lower,
                               "conf_higher":conf_higher
                                })

    results_df = results_df[["coeff","pvals","conf_lower","conf_higher"]]
    return results_df
```


```python
summary_df = summary_to_df(mixed_fit)
sig_pvals = summary_df[summary_df ['pvals']<= 0.05]
sig_pvals
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
      <th>coeff</th>
      <th>pvals</th>
      <th>conf_lower</th>
      <th>conf_higher</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>MMSE:eTIV</th>
      <td>0.251948</td>
      <td>0.000726</td>
      <td>0.105827</td>
      <td>0.398068</td>
    </tr>
    <tr>
      <th>MMSE:nWBV:eTIV</th>
      <td>17.493033</td>
      <td>0.000548</td>
      <td>7.572879</td>
      <td>27.413187</td>
    </tr>
    <tr>
      <th>MMSE:eTIV:EDUC</th>
      <td>-0.016371</td>
      <td>0.000809</td>
      <td>-0.025949</td>
      <td>-0.006792</td>
    </tr>
    <tr>
      <th>MMSE:nWBV:eTIV:EDUC</th>
      <td>-1.143294</td>
      <td>0.000492</td>
      <td>-1.786245</td>
      <td>-0.500342</td>
    </tr>
    <tr>
      <th>MMSE:eTIV:SES</th>
      <td>-0.102714</td>
      <td>0.000348</td>
      <td>-0.158998</td>
      <td>-0.046431</td>
    </tr>
    <tr>
      <th>MMSE:nWBV:eTIV:SES</th>
      <td>-7.348724</td>
      <td>0.000059</td>
      <td>-10.936178</td>
      <td>-3.761270</td>
    </tr>
    <tr>
      <th>MMSE:eTIV:EDUC:SES</th>
      <td>0.006792</td>
      <td>0.000834</td>
      <td>0.002808</td>
      <td>0.010776</td>
    </tr>
    <tr>
      <th>MMSE:nWBV:eTIV:EDUC:SES</th>
      <td>0.493338</td>
      <td>0.000256</td>
      <td>0.228863</td>
      <td>0.757812</td>
    </tr>
  </tbody>
</table>
</div>



We can see the significant effects of the interactions here. It seems that the combinations of these variables is an important measure for the question.


```python
#fit model 2
mixed2 = smf.mixedlm('Converted ~ MMSE+SES+EDUC+nWBV+eTIV+Age+Gender',data=both_visits, groups=both_visits['Subject_ID'])
mixed2_fit = mixed2.fit(reml=False)

print(mixed2_fit.summary())
print('Bayesian Information Criteria (BIC): ', mixed2_fit.bic)
```

             Mixed Linear Model Regression Results
    =======================================================
    Model:            MixedLM Dependent Variable: Converted
    No. Observations: 82      Method:             ML       
    No. Groups:       82      Scale:              0.0457   
    Min. group size:  1       Log-Likelihood:     -18.2564
    Max. group size:  1       Converged:          Yes      
    Mean group size:  1.0                                  
    -------------------------------------------------------
                 Coef.  Std.Err.   z    P>|z| [0.025 0.975]
    -------------------------------------------------------
    Intercept     0.849    0.199  4.274 0.000  0.460  1.239
    MMSE         -0.098    0.026 -3.792 0.000 -0.149 -0.048
    SES          -0.144    0.029 -4.997 0.000 -0.200 -0.087
    EDUC         -0.043    0.009 -4.695 0.000 -0.061 -0.025
    nWBV         -0.553    4.346 -0.127 0.899 -9.071  7.966
    eTIV         -0.000    0.002 -0.021 0.983 -0.003  0.003
    Age           0.109    0.041  2.636 0.008  0.028  0.189
    Gender        0.089    0.074  1.205 0.228 -0.056  0.233
    Group Var     0.046                                    
    =======================================================

    Bayesian Information Criteria (BIC):  80.58007408355029


    /usr/local/lib/python3.8/site-packages/statsmodels/regression/mixed_linear_model.py:2189: ConvergenceWarning: The Hessian matrix at the estimated parameter values is not positive definite.
      warnings.warn(msg, ConvergenceWarning)


The second LME model only measures the simple effects of the fixed effects. The BIC is a lot smaller as there are fewer observations.


```python
summary_df2 = summary_to_df(mixed2_fit)
sig_pvals2 = summary_df2[summary_df2['pvals'] <= 0.05]
sig_pvals2
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
      <th>coeff</th>
      <th>pvals</th>
      <th>conf_lower</th>
      <th>conf_higher</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Intercept</th>
      <td>0.849244</td>
      <td>1.921953e-05</td>
      <td>0.459778</td>
      <td>1.238711</td>
    </tr>
    <tr>
      <th>MMSE</th>
      <td>-0.098328</td>
      <td>1.494001e-04</td>
      <td>-0.149149</td>
      <td>-0.047506</td>
    </tr>
    <tr>
      <th>SES</th>
      <td>-0.143899</td>
      <td>5.828538e-07</td>
      <td>-0.200342</td>
      <td>-0.087456</td>
    </tr>
    <tr>
      <th>EDUC</th>
      <td>-0.042990</td>
      <td>2.666300e-06</td>
      <td>-0.060937</td>
      <td>-0.025043</td>
    </tr>
    <tr>
      <th>Age</th>
      <td>0.108547</td>
      <td>8.391635e-03</td>
      <td>0.027835</td>
      <td>0.189259</td>
    </tr>
  </tbody>
</table>
</div>



The estimated p values show that the four variables that seem to have the most effect on the Converted variable is: MMSE, SES, EDUC and Age. Age is perhaps a variable that should not be included in the model as dementia is an age-related disorder we would expect that as age increases so does the risk of dementia. However it is interesting to see SES, MMSE and EDUC which are most likely connected especially in certain countries with starker disparities in wealth. Let's go back to the original dataset and look at these potential relationships. I have used a subset of the dataset named *one_visit* which contains only the first visit i.e. the baseline values because all of the participants had at least one visit. Also the effect of time on the scores especially for MMSE will change and there will be multiple scores for one participant.


```python
oasis_df2 = oasis_df.dropna() #remove missing scores

g = sns.regplot(x='SES',y='EDUC', data=one_visit,color="skyblue", scatter_kws={'s':30}, label = 'A');
g = g.set(xlim=(0,6), xlabel="SES (1-5)", ylabel="Education (Years)")


correlation_matrix = np.corrcoef(one_visit['SES'], one_visit['EDUC'])
correlation_xy = correlation_matrix[0,1]
r_squared = correlation_xy**2


print("R-Squared:","{:.2f}".format(r_squared))

```

    R-Squared: 0.47



![png](OASIS_dataset_analysis-2_files/OASIS_dataset_analysis-2_32_1.png)



```python
g2 = sns.regplot(x='SES',y='MMSE', data=one_visit);
g2 = g2.set(xlim=(0, 6))

correlation_matrix = np.corrcoef(one_visit['SES'], one_visit['MMSE'])
correlation_xy = correlation_matrix[0,1]
r_squared = correlation_xy**2

print("R-Squared:","{:.4f}".format(r_squared))
```

    R-Squared: 0.0002



![png](OASIS_dataset_analysis-2_files/OASIS_dataset_analysis-2_33_1.png)



```python
g3 = sns.regplot(x='EDUC',y='MMSE', data=one_visit, color="g");
g3 = g3.set(xlim=(7, 25))

oasis_df2 = one_visit.dropna()
correlation_matrix = np.corrcoef(one_visit['EDUC'], one_visit['MMSE'])
correlation_xy = correlation_matrix[0,1]
r_squared = correlation_xy**2

print("R-Squared:","{:.2f}".format(r_squared))
```

    R-Squared: 0.01



![png](OASIS_dataset_analysis-2_files/OASIS_dataset_analysis-2_34_1.png)


Running the simple linear regression models comparing two of the variables at a time, it is evident that in this dataset EDUC, MMSE & SES do not correlate that well with R-squared values of 0.47, 0.0002 & 0.01. Although Education and SES seem to show a pattern in the graph it is not a strong enough correlation to assume a connection between the two.

LME models are common practice in longitudinal studies and did give more insight into the data compared to the ANOVA which is probably not the best method to use for this dataset due to missing data and non-independence of variables. In addition, the models that I used may not be the best for this dataset either and can be interpreted in other ways for example some might suggest that socioeconomic status could be treated as a random effect depending on how the sample was collected. Another aspect I did not delve into is possible nested effects.

### References

Shapiro, S. S., & Wilk, M. B. (1965). An analysis of variance test for normality (complete samples). Biometrika, 52(3/4), 591-611.
