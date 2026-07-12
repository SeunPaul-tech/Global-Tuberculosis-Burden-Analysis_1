# Global Tuberculosis Burden Analysis

## Table of Contents

- [Project Overview](#project-overview)
- [Data Sources](#data-sources)
- [Tools](#tools)
- [Data Cleaning & Preparation](#data-cleaning--preparation)
- [Exploratory Data Analysis](#exploratory-data-analysis)
- [Data Analysis](#data-analysis)
- [Results & Findings](#results--findings)
- [Recommendations](#recommendations)
- [Limitations](#limitations)
- [References](#references)

---

# Project Overview

Tuberculosis (TB) remains one of the world's deadliest infectious diseases, affecting millions of people annually despite significant advances in diagnosis and treatment. Monitoring TB trends is essential for measuring progress toward global health targets and identifying regions requiring additional public health interventions.

This project analyzes country-level tuberculosis data to understand the global burden of the disease across different regions and years. Using PostgreSQL for data cleaning and analytical querying, Power BI for interactive visualization, and Figma for dashboard planning, the project transforms raw epidemiological data into actionable insights for healthcare professionals, policymakers, and researchers.

The analysis focuses on major TB indicators including prevalence, incidence, mortality, HIV-associated TB, case detection rates, and population-adjusted disease burden to better understand how tuberculosis impacts countries worldwide.

### Project Objectives

- Analyze global tuberculosis trends over time.
- Identify countries and regions with the highest disease burden.
- Examine trends in TB incidence, prevalence, and mortality.
- Assess the relationship between HIV and tuberculosis.
- Evaluate global TB case detection performance.
- Compare disease burden using population-adjusted metrics.
- Develop an interactive dashboard that supports evidence-based public health decision-making.

---

# Data Sources

The analysis uses the **WHO Global Tuberculosis Burden by Country dataset**, containing annual tuberculosis estimates reported across countries worldwide.

The dataset contains variables including:

- Country and ISO codes
- WHO Region
- Reporting Year
- Estimated Population
- TB Prevalence (Cases and Rate per 100,000)
- TB Incidence (Cases and Rate per 100,000)
- TB Mortality (Deaths and Rate per 100,000)
- HIV-associated TB Cases
- HIV-associated TB Deaths
- HIV among Incident TB Cases (%)
- Case Detection Rate (CDR)
- Estimation Methods
- Confidence Interval (Low and High Estimates)

These variables provide a comprehensive picture of tuberculosis burden at both national and regional levels.

---

# Tools

| Tool | Purpose |
|------|---------|
| **PostgreSQL** | Data cleaning, validation, exploratory data analysis (EDA), statistical analysis, and SQL querying using CTEs, Window Functions, Aggregate Functions, Correlation Analysis, and Ranking Functions. |
| **Power BI** | Data modeling, DAX calculations, KPI development, interactive dashboard creation, time intelligence, geographic visualization, conditional formatting, and reporting. |
| **Figma** | Dashboard wireframing, UI/UX planning, layout design, color palette selection, and visual consistency before implementation in Power BI. |

---

# Data Cleaning & Preparation

To ensure the reliability and consistency of the dataset, several preprocessing steps were carried out in PostgreSQL before importing the data into Power BI.

The cleaning process included:

- Creating a relational database table for the WHO tuberculosis dataset.
- Importing the CSV dataset into PostgreSQL.
- Checking for duplicate records using `ROW_NUMBER()`.
- Confirming that no duplicate records existed.
- Creating a working copy of the dataset for cleaning while preserving the raw data.
- Standardizing country names (e.g., Republic of Korea, DRC Congo, United Kingdom).
- Converting WHO regional abbreviations into full region names.
- Handling missing values by replacing them with appropriate averages or median values depending on the variable.
- Removing columns that contained entirely null values.
- Validating numerical fields used for analysis.
- Preparing a clean dataset for visualization in Power BI.

Within Power BI:

- Built an optimized data model.
- Created DAX measures for KPIs and trend analysis.
- Applied conditional formatting for KPI cards.
- Designed interactive report pages with filters and slicers.

---

# Exploratory Data Analysis

The exploratory analysis sought to answer important public health questions across six major themes.

## Disease Burden

- Which countries have the highest TB prevalence?
- Which countries have the lowest TB prevalence?
- Which WHO regions carry the highest TB burden?
- How has TB prevalence changed over time?
- Which countries have experienced the greatest decline in TB prevalence?

## Incidence Analysis

- Which countries report the highest incidence rates?
- Which regions contribute the greatest number of new TB cases?
- Is TB incidence increasing or decreasing over time?
- Which countries consistently record high incidence rates?

## Mortality Analysis

- Which countries have the highest TB mortality?
- Which regions account for the largest number of TB deaths?
- How has TB mortality changed over time?
- Are mortality rates declining in high-burden countries?

## HIV & Tuberculosis

- Which countries have the highest percentage of HIV among incident TB cases?
- Which countries report the highest HIV-associated TB deaths?
- Which WHO regions experience the greatest HIV/TB burden?
- Is HIV strongly associated with higher TB mortality?

## Case Detection

- Which countries have the highest TB case detection rates?
- Which countries have poor TB detection performance?
- Has case detection improved over time?
- Is improved case detection associated with lower mortality?

## Population-Adjusted Analysis

- Which countries have the highest TB burden relative to population?
- Which countries contribute the most TB cases globally?
- Which large-population countries maintain relatively low TB incidence rates?

---

# Data Analysis

The analytical phase combined SQL queries with Power BI DAX calculations to uncover trends and generate insights.

SQL techniques used include:

- Aggregate Functions
- Window Functions
- Common Table Expressions (CTEs)
- Ranking Functions
- Correlation Analysis (`CORR()`)
- Trend Analysis
- Population-adjusted calculations

Power BI DAX measures were created for:

- Total Population
- Total TB Cases
- Total TB Deaths
- Total HIV/TB Deaths
- TB Incidence Rate
- TB Mortality Rate
- Population Density
- Previous Year Population
- Percentage Change
- Trend Indicators
- Conditional Formatting Measures

Interactive report pages enable users to analyze results by year, country, and region.

---

# Results & Findings

The analysis revealed several important public health insights.

- India recorded the highest average tuberculosis prevalence, with over **4 million estimated cases** during the study period.
- South-East Asia consistently carried the highest regional TB burden, accounting for the largest number of incident cases and TB-related deaths.
- Namibia recorded the highest average TB incidence rate per 100,000 population.
- The Central African Republic reported the highest average TB mortality rate.
- Zimbabwe recorded the highest proportion of HIV among incident TB cases.
- Nigeria recorded the highest cumulative HIV-associated TB deaths.
- Africa experienced the greatest HIV/TB burden based on HIV-associated TB incidence.
- Global case detection rates improved steadily over time, indicating progress in TB surveillance and diagnosis.
- Nigeria recorded one of the poorest average TB case detection rates.
- Cambodia exhibited the highest tuberculosis burden relative to its population.
- India contributed the largest estimated number of tuberculosis cases globally.
- Australia, Canada, and the United States maintained relatively low TB incidence despite having large populations.

### Correlation Analysis

Two statistical relationships were also examined:

- A **weak positive correlation (0.22)** was observed between HIV prevalence among incident TB cases and TB mortality, suggesting HIV alone does not fully explain TB mortality differences across countries.
- A **moderate negative correlation (-0.54)** was found between case detection rates and mortality, indicating that stronger TB detection systems are generally associated with better health outcomes.

---

# Recommendations

Based on the findings, the following recommendations are proposed:

- Increase investments in tuberculosis screening programmes within high-burden countries.
- Strengthen surveillance systems to improve reporting accuracy and data completeness.
- Expand integrated HIV/TB healthcare services across Africa and other high-burden regions.
- Improve access to early diagnosis and treatment in countries with poor case detection performance.
- Prioritize interventions in South-East Asia and Africa where disease burden remains highest.
- Continue monitoring TB indicators using interactive dashboards to support evidence-based policy decisions.
- Incorporate socioeconomic and healthcare access indicators into future analyses for a more comprehensive understanding of TB drivers.

---

# Limitations

While the analysis provides valuable insights, several limitations should be acknowledged.

- The dataset relies on estimates reported by national health systems and the World Health Organization.
- Missing values were imputed using statistical averages and median values, which may not perfectly represent actual observations.
- The analysis is descriptive and does not establish causal relationships.
- Socioeconomic, environmental, and healthcare infrastructure variables were not included.
- Reporting methodologies may vary across countries and years.
- Predictive modeling and forecasting were outside the scope of this project.

---

# References

- World Health Organization (WHO). (2025). *Global Tuberculosis Report 2025*. Retrieved from https://www.who.int/teams/global-programme-on-tuberculosis-and-lung-health/tb-reports/global-tuberculosis-report-2025
- WHO Global Tuberculosis Database.
- PostgreSQL Documentation.
- Microsoft Power BI Documentation.
- Microsoft Learn – DAX Documentation.
- Figma Documentation.
