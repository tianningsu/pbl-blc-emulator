# pbl-blc-emulator
Observation-driven deep-learning emulator for planetary boundary layer height (PBLH) and boundary-layer clouds (BLCs) using morning soundings and diurnally varying surface meteorology/fluxes. ARM observation–validated; applicable to ERA5/MERRA-2 inputs.

Purpose:
Estimates PBLH and simulates cloud occurrence, cloud-base height (CBH), thickness, and vertical cloud-fraction profiles.

Inputs (required):
Surface meteorology/fluxes: N×14 for local time 04–17 (exactly 14 hourly columns).
Morning sounding: one profile per day (~06 LT).
Outputs: daily arrays over LT 04–17 and a 3-D cloud profile.

How to use (notebook-first)

Prepare inputs
See process_input.m and follow the guidance inside Main.ipynb (first cells).
Expected files in ./input/:

Surface_Meteorology.mat: rh,u,v,p,pre,t,sh,lh,date each N×14 (LT 04–17); date as YYYYMMDD.

Morning_Profile.mat: theta,height,rh,u,v,time (one profile per day).
The notebook will create input_for_dnn.mat.

Run the DNN
Open Main.ipynb and run all cells.
Models are expected under ./models/; outputs are written to ./output/.

Analyze results
Open Analyze_output.ipynb for an example workflow to visualize daily cloud profiles and PBLH and to export a YYYYMMDD.png plot.
(The plotting example is already inside the notebook—no need to copy it here.)

Outputs

The notebooks save:

./output/dnn_output.mat and ./output/dnn_output.nc with:

pblh (LM×14), blc_occurrence (LM×14), cbh (LM×14),
cldcf (LM×14×11), cldthick (LM×14), cld_prof (LM×14×150),
height (150), date (LM)
(All hour dimensions are LT 04–17.)
