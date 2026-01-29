# Spatial Regression & Spatial Random Forest — East Java Poverty Rate (2024)

This repository contains an end-to-end **spatial modeling workflow** to analyze and predict **district/city poverty rate (%) in East Java (Jawa Timur), 2024** using:

- **Global baseline:** Ordinary Least Squares (OLS) + regression diagnostics  
- **Spatial econometrics:** **SAR/SLM (Spatial Lag)**, **SEM (Spatial Error)**, and **SAC** models  
- **Machine learning:** **Spatial Random Forest (spatialRF)** for stronger predictive performance and variable importance  

> Materials included: **paper/report**, **presentation**, and **plots/scripts** used to produce results.

---

## TL;DR (Key Findings)

From the report/paper:

- **Spatial dependence exists** in poverty rates (neighboring districts tend to have similar poverty levels), so spatial models are justified.
- In the regression-based models, the strongest and most consistent drivers are:
  - **Rata-rata Lama Sekolah (RLS)** *(X2)* → **negative** association with poverty (higher schooling ↘ poverty)
  - **Gini Ratio** *(X1)* → **positive** association with poverty (higher inequality ↗ poverty)
  - **Jumlah Sepeda Motor** *(X4)* → tends to be **negative** (proxy of household mobility/asset ownership)
  - **Jumlah Tenaga Medis** *(X3)* → **not consistently significant** in the parametric models
- **Spatial Random Forest performs best for prediction** in this project (reported **R² ≈ 0.687** and **RMSE ≈ 1.042**), and variable importance ranks **RLS** as the most influential predictor.

---

## Dataset & Variables

**Study area:** 38 districts/cities in **East Java (Jawa Timur)**  
**Year:** 2024  
**Source:** BPS (as used in the report)

**Response (Y):**  
- `Presentase Penduduk Miskin` (poverty rate, %)

**Predictors (X):**  
- `Gini_Ratio` *(X1)* — inequality indicator  
- `RLS` *(X2)* — average years of schooling  
- `Tenaga_Medis` *(X3)* — number of medical personnel  
- `Sepeda_Motor` *(X4)* — number of motorcycles  

Dataset file in this repo:
- `T4 RF Dataset.xlsx`

---

## Methods

### 1) OLS baseline + diagnostics
- Fit: $ Y = \beta_0 + \beta_1 X_1 + \beta_2 X_2 + \beta_3 X_3 + \beta_4 X_4 + \varepsilon $
- Diagnostics in `Regression Assumption Test.R`:
  - Normality (Shapiro-Wilk)
  - Multicollinearity (VIF)
  - Homoscedasticity (Breusch–Pagan)
  - Residual independence (Durbin–Watson)

### 2) Spatial econometrics (SAR/SEM/SAC)
Spatial weights (W) are built from district adjacency (contiguity) using the **East Java shapefile**.

- **Moran’s I** checks spatial autocorrelation.
- **LM tests (lag/error)** guide which spatial model is appropriate.
- Models estimated (as used in the notebook/report):
  - **SAR / SLM (Spatial Lag):** includes spatially lagged dependent variable $ \rho WY $
  - **SEM (Spatial Error):** spatial dependence in residuals $ \lambda W\varepsilon $
  - **SAC:** combination of lag + error dependence

### 3) Spatial Random Forest (spatialRF)
Implemented via `spatialRF` package with:
- Training Random Forest with spatial context
- Variable importance
- Spatial residual mapping (join predictions back to the shapefile)

Scripts:
- `Scripts/RF T4.R`  
- `Scripts/PLOT T4.R`

Notebook:
- `Scripts/R_Regresi_Spasial.ipynb`

---

## Repository Structure

```text
Spatial/
├─ Docs/
│  ├─ RFRS Presentation.pdf
│  ├─ RSRF Makalah.pdf
│  └─ RSRF Paper.pdf
├─ Scripts/
│  ├─ PLOT T4.R
│  ├─ RF T4.R
│  ├─ R_Regresi_Spasial.ipynb
│  └─ Regression Assumption Test.R
└─ T4 RF Dataset.xlsx
```

---

## How to Run

### Prerequisites
- **R (recommended ≥ 4.2)**
- R packages used across scripts/notebook:
  - `readxl`, `dplyr`, `sf`, `spdep`, `spatialreg`
  - `ggplot2`, `tmap`
  - `car`, `lmtest`
  - `spatialRF`

Install (example):
```r
install.packages(c(
  "readxl","dplyr","sf","spdep","spatialreg",
  "ggplot2","tmap","car","lmtest","spatialRF"
))
```

### Step 0 — Prepare the shapefile (required)
The scripts expect an **East Java administrative boundary shapefile** (district/city level).  
Put the shapefile in your working directory and make sure the layer name matches what the scripts use, e.g.:

- `EastJava.shp` + related files (`.dbf`, `.shx`, `.prj`, etc.)

> If your shapefile uses different names/paths, edit the `st_read("...")` line in the scripts.

### Option A — Run the Spatial Random Forest workflow
1. Open `Scripts/RF T4.R`
2. Adjust file paths if needed (dataset + shapefile)
3. Run the script to train the model + view variable importance + residual results
4. Use `Scripts/PLOT T4.R` to generate/preview additional plots

### Option B — Run spatial regression (OLS → SAR/SEM/SAC)
1. Open `Scripts/R_Regresi_Spasial.ipynb`
2. Run cells in order:
   - data loading
   - weights construction
   - Moran’s I
   - LM tests
   - SAR / SEM / SAC estimation
3. Optional: run `Scripts/Regression Assumption Test.R` for OLS diagnostics

---

## Outputs You Should Expect
Depending on which script you run, you will see:
- Printed model summaries (OLS, SAR/SEM/SAC)
- Moran’s I + LM test outputs
- SpatialRF results (R²/RMSE, variable importance)
- Maps/plots (via `tmap` / `ggplot2`) for:
  - observed poverty
  - predictions
  - residuals

---

## Notes
- If any join between the dataset and shapefile fails, check the **region identifier column** (district/city name or code) and align naming (case/spacing).
- Spatial workflows are sensitive to CRS. Ensure both dataset coordinates (if any) and shapefile CRS are consistent.

---

## References / Materials
See:
- `Docs/RSRF Makalah.pdf`
- `Docs/RSRF Paper.pdf`
- `Docs/RFRS Presentation.pdf`
