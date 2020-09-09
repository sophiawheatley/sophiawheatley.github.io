---
layout: post
title: Brain networks
date: 2020-07-16
---
# Complex Brain Networks
## 1. What is a complex network?
Networks have been used in various areas of scientific research so much so that the term 'network science' was coined for this interdisciplinary field.
One type of network which has been proposed is a 'complex network' which is a network with certain features that make it different compared to simple networks (Bullmore & Sporns, 2009).
These features could be differing levels of clustering, 'small-worldness' or presence of hubs (high degree nodes) to name a few.  
An example of a complex network is the 'scale-free network' proposed by Barabási and Albert (Barabási & Albert, 1999) who found that networks such as the World Wide Web showed degree distributions[^1] following a power law asymptomatically that: ${Prob(k)}\sim{k^{-3}}$.
The degree exponent was shown to be around $γ=3$ and ranging between 2 and 3 in various systems in their original findings, but can lie outside of these bounds.
An another important finding was what they termed 'preferential attachment' which defines when a new node is added to the network, it is more likely to attach or create a connection with a higher degree node rather than a node with fewer connections.
Small-world networks can also be described as being complex networks and research has found that networks in real life also show 'small-world' characteristics.

## 2. How can complex network be used to model the human brain?
Let's split this question into **Why** and **How** this can be done with the current neuroimaging data before looking at the research.

### 2.1 Why?
We might ask: what makes complex models a good way of modelling the brain?
One answer is that although many researchers have shown that certain regions are involved in certain functions such as vision and audition, we still do not know how these areas work together to make up the human 'connectome'.
Another reason is that 'small-world' attributes have been found in the brain for example when modelling a functional network using fMRI time series data (Achard et al., 2006).
Low-frequency oscillations especially from 0.03-0.06 Hz were concluded to have a small-world architecture and reflect the connectivity of anatomical structures in the brain.
Highly connected hubs were found and they showed degree distribution which could be explained by a truncated power law (therefore not a scale-free network).
These findings imply that the probability of the presence of large hubs are quite low.
In addition, the small-world architecture was also found to fit a model of structural data of the reticular formation and not the scale-free network model (Humphries, Gurney & Prescott, 2006).
So neither a power-law nor truncated power-law explained the degree distribution of the anatomical data used.


### 2.2 How?
In Bullmore & Sporns' (Bullmore & Sporns, 2009) review on complex models in the brain they explain three types of models that can be formed from brain imaging data:
- Structural
   - anatomical connectivity, using MRI, DTI
- Functional
   - how the elements rely on each other for functions, using EEG, MEG
- Effective
   - causal/directional relationships, using causal estimation modelling e.g. Granger causality

In order to compose these models, they suggest that the steps that can be taken for these different models are:
1. Define the nodes in the network by using parcellation[^2] or use electrodes or sensors
2. Find and estimate a measure of association between these nodes
3. Create an association matrix by running all pairwise associations between nodes and apply a threshold to each element of the matrix to produce a binary adjacency matrix[^3] or undirected graph
4. Calculate network parameters in this graphical model and compare with equivalent parameters in random networks

The first study to show small-world properties and degree distribution of anatomical networks in the human brain with the use of cortical thickness MRI was by He and colleagues (He et al., 2007).
There were several main findings: small-world properties, short mean distances between regions and truncated power-law distributions when looking at the probability of finding a connection between two regions in healthy volunteers.


## 3. AD models with the use of networks
It has been suggested previously that Alzheimer's disease (AD) is a 'disconnection syndrome' (Delbueck, Van der Linden & Collette, 2003).
The concept of disconnection in brain disorders was first used to explain the observed lesions between brain regions as manifested in 'split-brain' patients where the corpus callosum is severed resulting in disruption in signals between the two hemispheres.  
Models created from healthy controls and comparing them with models of AD patients may shed light on hypothesized disconnections in the brains of AD patients.
A similar method was used by Stam and colleagues, they measured the 'phase lag index' (PLI) [^4] of controls in resting state MEG data and then applied features to create two potential models for fitting to AD patients' data (Stam et al., 2009).
The reason why PLI was used was to counteract volume conduction, a common problem in functional connectivity.
Volume conduction is the electrical spread across the entire head after a postsynaptic potential, obscuring the actual source of the signal.
Using the PLI data from a control participant, they constructed two models: 'Random Failure' & 'Targeted Attack'.
The 'Random Failure' model was formed by randomly selecting an edge and decreasing it's weight by factor of 2 with probability 1.
For the 'Targeted Attack' model, the probability was dependent on the degree of both vertices connected by an edge.
The AD group showed significantly lower mean PLI for alpha (8-10 Hz) and beta (13-30 Hz) frequency bands and the Targeted Attack model fit the data better than the Random model.
From the results they concluded that AD patients networks resembled random networks more so than the controls.

One study which used longitudinal data from the Alzheimer's Disease Neuroimaging Initiative (ADNI) compared resting state fMRI images in AD patients and controls at two time points (Kundu et al., 2019).
The data was compared at two time points: baseline screening and the year after.
They used a Bayesian joint network learning approach to estimate the resting state networks for the two groups at the two time points.
AD patients displayed a decrease in small-worldness and global network metrics at both time points and found that certain hub nodes were disrupted due to AD progression.
The highest number of hub nodes were found in the default mode network and executive control (EC) in healthy controls.
Whereas in the AD group fewer hubs were evident in the resting state networks, apart from at the baseline when some did find four hubs in the EC, but was reduced to two in the year follow-up.  


## Conclusion
Although network research has added to a better understanding of brain networks, there are still some questions that have been left unanswered, but also some counterarguments.
In a recent review by Bassett & Bullmore, they discuss recent studies and how the research has progressed over the last 15 years (Bassett & Bullmore, 2017).  
I will just list some key points that they assessed in their paper:
* Small-world networks do not fully explain brain networks and is only a starting point for the research into brain connectivity.
* Many studies have looked at other features such as degree distribution, hubs, organization and more that are not just related to 'small-worldness'.
* Binary graphs (used frequently in the field) are a much too simplified way of modelling the brain.
  * A threshold against a measure such as the clustering coefficient can change the connection density of the graph depending on the threshold set.
  * If the threshold is low then there will be many weak connections in the graph and if it is high then only the strong connections will be represented as edges in the graph.
  * It is more effective to use weighted graphs instead to assess the weak and strong connections in the network.
  * Research into weak connections could be applied to psychological disorders e.g. schizophrenia (Bassett et al., 2012a).

The review concludes that small-worldness is still a relevant concept in the field of neuroscience.
The fascinating research using graph theory to understand the brain has come far and I look forward to future studies in the field.


<hr />
## References

Achard, S., Salvador, R., Whitcher, B., Suckling, J., & Bullmore, E. D. (2006). A resilient, low-frequency, small-world human brain functional network with highly connected association cortical hubs. Journal of Neuroscience, 26(1), 63-72.

Barabási, A. L., & Albert, R. (1999). Emergence of scaling in random networks. science, 286(5439), 509-512.

Bassett, D. S., & Bullmore, E. T. (2017). Small-world brain networks revisited. The Neuroscientist, 23(5), 499-516.

Bassett, D. S., Nelson, B. G., Mueller, B. A., Camchong, J., & Lim, K. O. (2012). Altered resting state complexity in schizophrenia. Neuroimage, 59(3), 2196-2207.

Bullmore, E., & Sporns, O. (2009). Complex brain networks: graph theoretical analysis of structural and functional systems. Nature reviews neuroscience, 10(3), 186-198.

Delbeuck, X., Van der Linden, M., & Collette, F. (2003). Alzheimer'disease as a disconnection syndrome?. Neuropsychology review, 13(2), 79-92.

He, Y., Chen, Z. J., & Evans, A. C. (2007). Small-world anatomical networks in the human brain revealed by cortical thickness from MRI. Cerebral cortex, 17(10), 2407-2419.

Humphries, M. D., Gurney, K., & Prescott, T. J. (2006). The brainstem reticular formation is a small-world, not scale-free, network. Proceedings of the Royal Society B: Biological Sciences, 273(1585), 503-511.

Kundu, S., Lukemire, J., Wang, Y., & Guo, Y. (2019). A Novel Joint Brain Network Analysis Using Longitudinal Alzheimer’s Disease Data. Scientific reports, 9(1), 1-18.

Paneri, S., & Gregoriou, G. G. (2017). Top-down control of visual attention by the prefrontal cortex. functional specialization and long-range interactions. Frontiers in neuroscience, 11, 545.

Stam, C. J., De Haan, W., Daffertshofer, A. B. F. J., Jones, B. F., Manshanden, I., van Cappellen van Walsum, A. M., ... & Berendse, H. W. (2009). Graph theoretical analysis of magnetoencephalographic functional connectivity in Alzheimer's disease. Brain, 132(1), 213-224.

<hr />

[^1]: Degree distribution is the probability distribution of the degrees in a network.

[^2]: Parcellation is the segmentation of an object, here the brain, into regions of interest.

[^3]: An adjacency matrix contains the number of edges for each pair of nodes in the graph. They are usually binary whereby 1 indicating an edge between the nodes and 0 indicating no edge.

[^4]: Phase lag index (PLI) is the consistency between two signals where one is lagging or leading the other (See *Stam et al., 2009* for more detail).  
