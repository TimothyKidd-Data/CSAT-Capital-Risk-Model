# Regional Claims Performance & Capital Risk Analysis

## Executive Summary
Customer Satisfaction (CSAT) scores were experiencing a measurable decline across regional networks, coinciding with millions of dollars in capital tied up in unresolved claim reserves. This project identifies the root cause of the operational friction and provides a data-driven recommendation to release trapped capital and improve the customer experience.

## The Objective
To diagnose the operational bottlenecks causing increased average hold times, low CSAT, and inflated reserve balances across the national claims network, with a specific focus on the Texas and California regions.

## Tools & Pipeline
* **Data Profiling:** Microsoft Excel
* **Data Cleaning & Aggregation:** SQL (Google BigQuery)
* **Data Visualization & Dashboarding:** Microsoft Power BI

## Data Cleaning & Transformation (SQL)
The raw dataset required significant transformation before analysis could occur.
* **Type Conversion:** Utilized `SAFE_CAST` to convert string data into `FLOAT64` for mathematical aggregations.
* **String Manipulation:** Deployed nested `REPLACE` functions to strip currency symbols ($) and commas from financial strings to calculate accurate reserve totals.
* **Categorical Standardization:** Discovered corrupted string values in the `Team` column (e.g., "Team Team Alpha", "Team SouthTeam West"). Engineered a dynamic `CASE` statement to clean and map the operational groups on the fly prior to aggregation.

## Key Findings: The Volume Bottleneck
By analyzing regional performance, I identified claim volume as the root cause of the systemic failure in Texas. 

* **The State-Level Issue:** Texas processes a disproportionate amount of the national claim volume (528 claims compared to California's 432), resulting in an average hold time of over 4.2 minutes and millions in stuck capital.
* **The Team-Level Root Cause:** By segmenting the data further, I discovered the volume is not evenly distributed. The bottleneck is isolated entirely within Texas Teams Alpha, Beta, and Gamma. Because these three operational teams are overwhelmed, Texas accounts for the top 9 longest average wait times in the entire network.

## Business Recommendation
To immediately improve CSAT and release trapped capital, management must execute an operational adjustment: Reallocate adjuster headcount from lower-volume regions to reinforce Texas Teams Alpha, Beta, and Gamma. Alternatively, deploy automated routing for low-complexity claims in the Texas region to clear the queue and relieve the operational strain.
