# SEAKERsim
Modeling the dynamics of a prodrug-secreting CAR-T cell platform.

## Introduction
CAR-T cell therapy has shown clinical promise in eradicating liquid malignancies[^1]. However, increasing evidence suggests engineering immunotherapies to combat solid tumors requires a multimodal approach[^2][^3]. The selective enzyme-activated killer [(SEAKER)](https://www.nature.com/articles/s41589-021-00932-1) system combines T cell prodrug therapies to synergistically eradicate tumor mass[^4]. SEAKER cells are tumor-targeted T cells that release a prodrug-activating enzyme, combining T cell cytolytic activity with local chemotherapy. The activity of SEAKER cells in the tumor represents a dynamic system. Tumor antigens stimulate T cells, promoting T cell proliferation and amplifying enzyme release (CPG), subsequently activating prodrug, P-AMS, to AMS which nonselectively kills both tumor and T cells. The differences in timescale and magnitude of each of the aforementioned conditional processes motivates simulating their time course under experimentally relevant conditions. The present work develops a first pass simulation of the SEAKER system in vitro to inform preclinical development by drawing conclusions about optimal SEAKER-tumor cell ratio, prodrug design, and enzyme selection.
<p align="center">
<img src="Schematic.png" width=50% height=50%>
</p>

## Approach
The SEAKER system was simulated with a mass action model to track the time courses of the relevant species and their cognate effects on each other. The mass action model is represented by a system of four coupled ordinary differential equations (ODEs), written in general form as:

$$
\begin{pmatrix} 
y_1'(t) \\ 
y_2'(t) \\
y_3'(t) \\
y_4'(t)
\end{pmatrix} = \begin{pmatrix} 
f(y_1(t), y_3(t)  \\ 
f(y_1(t), y_3(t)) \\
f(y_4(t), y_4'(t)) \\
f(t, y_1(t))
\end{pmatrix}
$$

Where CTL cell number, Raji (tumor target) cell number, fraction of killed cells of interest, and activated prodrug (AMS) concentration at any instant $t$ is represented by the solution to the ODE system, $y(t)$:

$$
y(t)=\begin{pmatrix} 
y_1(t) = \text{CTL [cells]} \\ 
y_2(t)=\text{Raji [cells]} \\
y_3(t)=\text{fraction of cells killed} \\
y_4(t)=\text{AMS [nM]}
\end{pmatrix}
$$

## Results & Discussion
The time course of the SEAKER system in vitro was simulated from 0 to 100 hours by solving the ODE system in MATLAB. Briefly, the conditions recapitulate a 10 mL volume of culture in which 10^-4 Raji cells have been seeded at time 0 and were instantaneously subjected to CTLs at effector:target (E:T) ratios of 1:10, 1:1, 10:1, or 100:1 with 5.0 uM P-AMS. CTLs were assumed to be stimulated after 30 minutes, accounted for by a sudden change in doubling time (sec. 5.3). Figure 2 shows that CTL and AMS kill Raji cells at distinctly different timepoints for different E:T ratios. The roll-off observed in CTL and Raji traces in each panel indicates where [AMS]=f(t, CTL}(t)) has reached the $EC_{50}$ and effects an indiscriminate decrease in cell growth. Steady state values for CTL and Raji cell numbers occur significantly past the endpoint for an in vitro assay.
<p align="center">
<img src="fig1.png" width=50% height=50%>
</p>


[^1]: Maude et al. (2014). N Engl J Med.
[^2]: Morgan et al. (2010). Mol Ther.
[^3]: Cameron et al. (2013). Sci Transl Med.
[^4]: Gardner et al. (2021). Nat Chem Biol.
