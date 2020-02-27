Toronto Homicides
================
Tim Chisamore
2020-02-26

# 1 Introduction

The Toronto Police Service (TPS) provides data on homicides, shootings,
and major crime indicators (MCI), among other things, through the Public
Safety Data Portal.

We were interested in exploring homicides in Toronto through time and
space using a variety of methods.

# 2 Methods

Initiallty, the exploration of the Toronto homicide data was descriptive
in nature. We began by looking at the number of homicides by year and
continued graphically exploring other fields of interest.

We then applied the Early Aberration Reporting System (EARS) C1
algorithm to the data binned into yearmonths, i.e., values of the year
and month, such as Feb 2020. This algorithm uses the preceeding seven
units of data to construct a 95% confidence interval via the calculation
of rolling averages and standard deviations. Obviously, any value
exceeding this constructed threshold will be considered aberrant.

# 3 Results

From Figure 1, we can see there’s been no obvious increase or decrease
in the number of homicides over the past 15 years. If anything, there’s
appears to be a non-linear association between year and number of
homicides. Further, much of the variation looks to be occurring due to
stabbings and shootings.

![Figure 1: Homicides by Year and
Type](/Users/timothychisamore/Documents/Projects/R/toronto_homicides/output/documents/toronto_homicides_files/figure-gfm/homicides_by_year_and_type-1.png)

Figure 2 indicates that more homicides occurr at the beginning and end
of the week than in the middle. This isn’t surprising as people tend to
be out and about on the weekends more than midweek. Moreover, much like
above, there doesn’t appear to be any obvious patterns in the homicide
types.

![Figure 2: Homicides by Day and
Type](/Users/timothychisamore/Documents/Projects/R/toronto_homicides/output/documents/toronto_homicides_files/figure-gfm/homicides_by_day_and_type-1.png)

Figure 1 and Figure 2 speak to homicides by year and day, respectively,
however, we were interested in seeing how the number of homicides varied
by these concurrently. Figure 3 displays this information, note that the
Toronto van attack occurred on April 23rd, 2018, which was a Monday.
This explains the the large number of cases seen on Mondays in 2018 as
10 people were murdered that day.

![Figure 3: Homicides by Day and
Year](/Users/timothychisamore/Documents/Projects/R/toronto_homicides/output/documents/toronto_homicides_files/figure-gfm/homicides_by_day_and_year-1.png)

As with most count time series data, there was interest in fitting
models to this data and potentially forecasting. Figure 4 displays the
monthly time series for homicides by homicide type, including total. As
in the plot above, there is evidence of the 2018 van attack, best seen
in the bottom facet as these homicides were classified as “other”.

![Figure 4: Homicides by Month and
Type](/Users/timothychisamore/Documents/Projects/R/toronto_homicides/output/documents/toronto_homicides_files/figure-gfm/homicides_by_month_and_type-1.png)

Within the field of epidemiology, it is often of interest to use
aberration detection algorithms to identify high case counts over some
specified unit of time. Figure 5 displays the EARS C1 threshold for
monthly homicides, red triangles indicate months where the observed
numbers exceeded this threshold. Note that this algorithm only uses
recent data and disregards seasonality and so it may not be ideal.
However, it did detect multiple months with aberrant numbers of
homicides, including April, 2018.

![Figure 5: Homicide Surveillance by
Year-Month](/Users/timothychisamore/Documents/Projects/R/toronto_homicides/output/documents/toronto_homicides_files/figure-gfm/homicide_surveillance_by_yearmonth-1.png)

Toronto has 140 neighbourhoods and so it is of interest to examine the
spatial hetergeneity of the rate of homicides through time. Figure 6 is
a choropleth map showing the homicide rate per 100,000 by neighbourhood
in 2018. Again, you can see the evidence of the 2018 van attack that
took place in the neighbourhood of Lansing-Westgate, which is located in
North
York.

<div class="figure">

<img src="/Users/timothychisamore/Documents/Projects/R/toronto_homicides/output/plots/homicides_by_neighbourhood/homicide_rate_by_neighbourhood_2018.png" alt="Figure 6: Homicide Rate by Neighbourhood in 2018" width="3600" />

<p class="caption">

Figure 6: Homicide Rate by Neighbourhood in
2018

</p>

</div>

<div class="figure">

<img src="/Users/timothychisamore/Documents/Projects/R/toronto_homicides/output/plots/homicide_rate_by_on_marg_quintile_dimension_and_year/deprivation/homicide_rate_by_on_marg_quintile_deprivation_2018.png" alt="Figure 7: Homicide Rate by ON-MARG Material Deprivation Quintile in 2018" width="3600" />

<p class="caption">

Figure 7: Homicide Rate by ON-MARG Material Deprivation Quintile in 2018

</p>

</div>

# 4 Discussion
