# pbl-blc-emulator

**Observation-driven deep-learning emulator** for **planetary boundary layer height (PBLH)** and **boundary-layer clouds (BLCs)** using **morning soundings** and **diurnally varying surface meteorology/fluxes**.
**ARM Observation–validated; applicable to ERA5/MERRA-2 inputs.**

---

## **Author**

**Tianning Su** — Lawrence Livermore National Laboratory (LLNL)
📧 **[su10@llnl.gov](mailto:su10@llnl.gov)**

---

## **Purpose**

* Estimate **PBLH**
* Simulate **cloud occurrence**, **cloud-base height (CBH)**, **cloud thickness**, and **vertical cloud-fraction profiles**

---

## **Inputs (required)**

* **Surface meteorology/fluxes:** **N×14** for **local time 04–17** (exactly 14 hourly columns)
* **Morning sounding:** **one profile per day** (\~06 LT)

**Outputs:** daily arrays over **LT 04–17** and a 2-D cloud profile.

---

## **How to use (notebook)**

### **1) Prepare inputs**

* Run first cell inside **`Main.ipynb`**.
* Expected files in **`./input/`**:

  * `Surface_Meteorology.mat`: `rh, u, v, p, pre, t, sh, lh, date` — each **N×14 (LT 04–17)**; `date` as **YYYYMMDD**
  * `Morning_Profile.mat`: `theta, height, rh, u, v, time` — one profile per day
* The notebook creates **`input_for_dnn.mat`**.

### **2) Run the DNN**

* Run second cell inside **`Main.ipynb`**.
* Models are expected under **`./models/`**; outputs are written to **`./output/`**.

### **3) Analyze results**

* Open **`Analyze_output.ipynb`** for an **example workflow** to visualize daily cloud profiles and PBLH and to export a **`YYYYMMDD.png`** plot.
  *The plotting example lives in the notebook*

---

## **Outputs**

The notebooks save:

* **`./output/dnn_output.mat`** and **`./output/dnn_output.nc`**

**Variables & shapes**

* `pblh (LM×14)`, `blc_occurrence (LM×14)`, `cbh (LM×14)`
* `cldcf (LM×14×11)`, `cldthick (LM×14)`, `cld_prof (LM×14×150)`
* `height (150)`, `date (LM)`

> **All hour dimensions are LT 04–17.** *(If you plot 05–17, simply drop the first hour.)*

---

## **Data format (important)**

* **Surface inputs must be LT 04–17 (N×14).** Convert first if your data are in another window.
* **Morning sounding:** one profile per day; used as initial/boundary condition.

---

## **Citations**

Please cite the following when using this repository:

* **Su, T., & Zhang, Y. (2024).** *Deep-learning-driven simulations of boundary layer clouds over the Southern Great Plains.* **Geoscientific Model Development, 17**(16), 6319–6336.
* **Su, T., & Zhang, Y. (2024).** *Deep-learning-derived planetary boundary layer height from conventional meteorological measurements.* **Atmospheric Chemistry and Physics, 24**(11), 6477–6493.

---

## **License**

**GPL-3.0** — see `LICENSE`.
