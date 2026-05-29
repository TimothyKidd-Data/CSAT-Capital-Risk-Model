/* 
PROJECT: Regional Claims Performance & Capital Risk Analysis
GOAL: Identify operational bottlenecks causing stuck capital.
*/

/* PHASE 1: THE DIAGNOSIS 
Goal: Prove that high hold times in TX and CA are directly tied to millions 
in stuck capital and low customer satisfaction. 
*/
SELECT 
  State,
  COUNT(*) AS Total_Claims_Volume,
  -- Use cleaning formula here to get the true total of stuck money
  ROUND(SUM(SAFE_CAST(REPLACE(REPLACE(Reserve_Amount, '$', ''), ',', '') AS FLOAT64)),2) AS Total_Capital_Stuck,
  -- Clean the hold time (in case it was read as text) and find the average
  ROUND(AVG(SAFE_CAST(Avg_Hold_Time_Min AS FLOAT64)), 1) AS Average_Wait_Time,
  -- Average the satisfaction score to see how angry the customers are
  ROUND(AVG(SAFE_CAST(customer_satisfaction_Score AS FLOAT64)), 1) AS Average_CSAT_Score
FROM `portfolio-data-analysis-495222.portfolio_data.clean_data_master`
WHERE State IN ('TX', 'CA') 
GROUP BY State;


/* PHASE 2: HALFTIME ADJUSTMENT (Scouting the dirty data) 
Goal: Investigate anomalies in the team names before grouping.
*/
SELECT DISTINCT Team
FROM `portfolio-data-analysis-495222.portfolio_data.clean_data_master`
ORDER BY Team;


/* PHASE 3: THE AUDIBLE (Data Mapping & Segmentation)
Goal: Clean the corrupted Team column on the fly and break down 
the TX and CA volume to find the specific operational bottleneck.
*/
SELECT 
  State,
  
  -- Fixing the typos before they get grouped
  CASE   
    WHEN Team = 'Team Team Alpha' THEN 'Team Alpha'
    WHEN Team = 'Team Team Central' THEN 'Team Central'
    WHEN Team = 'Team Team West' THEN 'Team West'
    WHEN Team = 'Team SouthTeam West' THEN 'Team SouthWest' 
    WHEN Team IS NULL THEN 'Unassigned'
    ELSE Team -- If it's already correct, leave it alone
  END AS Clean_Team,

  -- The Metrics build
  COUNT(*) AS Volume,
  -- Use REPLACE to remove '$' and ',' so SAFE_CAST can work
  ROUND(SUM(SAFE_CAST(REPLACE(REPLACE(Reserve_Amount, '$', ''), ',', '') AS FLOAT64)), 2) AS Total_Capital_Stuck,
  ROUND(AVG(SAFE_CAST(Avg_Hold_Time_Min AS FLOAT64)), 1) AS Avg_Wait_Time

FROM `portfolio-data-analysis-495222.portfolio_data.clean_data_master`
WHERE State IN ('TX', 'CA') 
GROUP BY State, Clean_Team 
ORDER BY Volume DESC;


/* PHASE 4: THE POWER BI EXPORT PIPELINE
Goal: Clean the raw data line-by-line so Power BI can ingest it perfectly.
Notice: No 'GROUP BY' clause. We need row-level data for the dashboard.
*/
SELECT 
  Claim_ID,
  State,
  Region,
  CASE 
    WHEN Team = 'Team Team Alpha' THEN 'Team Alpha'
    WHEN Team = 'Team Team Central' THEN 'Team Central'
    WHEN Team = 'Team Team West' THEN 'Team West'
    WHEN Team = 'Team SouthTeam West' THEN 'Team SouthWest' 
    WHEN Team IS NULL THEN 'Unassigned'
    ELSE Team 
  END AS Clean_Team,
  SAFE_CAST(Avg_Hold_Time_Min AS FLOAT64) AS Hold_Time_Minutes,
  SAFE_CAST(customer_satisfaction_Score AS FLOAT64) AS CSAT_Score,
  SAFE_CAST(REPLACE(REPLACE(Reserve_Amount, '$', ''), ',', '') AS FLOAT64) AS Reserve_Dollars
FROM `portfolio-data-analysis-495222.portfolio_data.clean_data_master`;