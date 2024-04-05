# "The time between Paleolithic hearths": temporal estimations program

----------------------------------------------------------------------------

## SYSTEM REQUIREMENTS AND INSTALLATION:

This program runs on Matlab 2018 and later versions.
No other installation is needed. You only need to have Matlab installed,
the routine is executed by this program. 

-----------------------------------------------------------------------------

## DEMO:

The code includes all the necessary information to perform calculations 
with the article data. No change is necessary to run this example.

IMPORTANT: It is necessary that the two files (the Matlab routine .m and 
the .dat file) are in the same Matlab folder.

The expected output is a figure and a table with the numerical 
values corresponding to the steps described in the Supplementary 
Materials E of the article.

-------------------------------------------------------------------

## INSTRUCTIONS FOR USE:

To run the Matlab routine, you need to write in the main Matlab Command Window:

```matlab
[output]=elapsed_min_time(d1,i1,a1,d2,i2,a2);
```

The input parameters are:

- d1,i1,a1,d2,i2,a2: the values d1, i1 and a1 are relatived to the first archeomagnetic
directional data (d1 is declination, i1 is inclinaiton, and a1 is the  &#945;<sub>95</sub> value). The same for
d2, i2 and a2, but for the second archeomagnetic directional data.

- In the El Salt study, we use five directions that are analized in consecutive pairs as follows:

|  Direction (hearth)      |Dec. (º):	 |Inc. (º):	| &#945;<sub>95</sub> (º): |
| ----------- |--------- |------|--------|
| Dir 1 (H34): |6.6       |55.4  |3.8 |
|Dir 2 (H55): |3.6        |49.8  |4.4 |        
|Dir 3 (H48): |3.5	 |55.6  |6.9 | 
|Dir 4 (H59): |4.1        |43.7  |5.1 |          
|Dir 5 (H50): |352.9-360  |54.0  |5.0 |

Note that the declination is included as ±180 (i.e. 352.9 -> 352.9-360 = -4.9). The four pairs to be compaired are: 1 vs. 2, 2 vs. 3, 3 vs. 4, 4 vs. 5.

The output are given in two formats:

- An image in a PDF "Figure_output.pdf" including a) the PDF for the directional pair of data and b-d) the combined PDFs that show the probability of the elapsed minimum time for the different paleoreconstructions: b) SHA.DIF.14k, c) ARCHKALMAG14k, d) Toy-Model. For each PDF, it is marked the
mode value (most often value) and the values at 95% and 68% of probability.

- A table "output.dat" contains the previous elapsed minimum times in rows (mode, 95%, 68%). 
First row -> SHA.DIF.14k; second row -> ARCHKALMAG14k; third row -> Toy-Model.

-------------------------------------------------------------------
