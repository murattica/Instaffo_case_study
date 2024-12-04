
# Marketing Analytics Case Study

This repository showcases my approach to solving the marketing analytics case study. The task was divided into two main components: defining KPI metrics to support marketing decision-making (Task 1) and designing a robust data model to calculate and analyze these metrics (Task 2). Below, I will outline the methodology, key considerations, and design decisions for Task 2.

---

### **Task 1: KPI Design**
I have provided a detailed report in this repository that explains the rationale behind the selected KPIs: **Activation Rate**, **ROAS (Return on Ad Spend)**, and **Cost Per Hire (CPH)**. These KPIs were designed to strike a balance between short-term actionability and long-term strategic insights for optimizing marketing performance. The report also explains how each KPI supports specific marketing decisions and how they were calculated.

---

### **Task 2: Dimensional Model Design**

#### **Fact and Dimension Tables**
To calculate the KPIs, I utilized the following **fact** and **dimension** tables:
1. **Fact Tables:**
   - `fact_application_logs`: Tracks job applications and their statuses (e.g., applied, hired) to calculate metrics.
   - `fact_campaign_spend`: Stores campaign-level spend data, which forms the foundation for ROAS and CPH calculations.
2. **Dimension Tables:**
   - `dim_candidates`: Contains details about job seekers (e.g., channel, campaign, demographics).
   - `dim_jobs`: Includes information about job postings, negotiated salaries, and commission rates.

For simplicity, I assumed that these tables were already available and skipped the load and staging layers. This allowed me to focus on optimizing calculations and designing the downstream models.

#### **Daily and Monthly Aggregations**
- Calculations for metrics were first performed at the **daily level** for Activation Rate. This allowed granular insights into early-stage engagement.
- For ROAS and CPH, I aggregated calculations at the **monthly level** to improve computational efficiency and align with reporting needs.

#### **Reducing Redundancy**
- I designed shared models for ROAS and Cost Per Hire calculations to prevent redundancy and duplication of logic. Both metrics rely on similar inputs (e.g., spend, hires), so combining them made the pipeline more maintainable.

#### **Incremental Processing**
- The pipeline leverages an **incremental processing strategy** to process only new or updated data. This approach reduces computational costs and ensures scalability as the data grows.

#### **Multi-Dimensional Analysis**
The designed model supports multi-dimensional analysis by allowing slicing and dicing across key dimensions such as:
- **Channel and Campaign**: Assessing performance at different marketing channels and campaigns.
- **Time Periods**: Comparing trends across days or months.
- **Demographics and Job Types**: Analyzing how different audience segments and job categories impact key metrics.

These capabilities enable a deeper understanding of marketing efficiency and support informed decision-making.

#### **Filters and Backfill Capability**
Although I haven't implemented all the filters, I would use a **filter and variable system** to process only relevant data. This system would enable:
- **Backfills** for historical data corrections.
- Dynamic filtering to improve performance during pipeline runs.

The filter system would be similar to the design prepared for the Enpal task assessment, where processing was optimized by dynamically managing data ranges and targets.

---

### **Visual Representations**

#### **Lineage Diagram**
The lineage diagram below illustrates the flow of data through the pipeline, starting from fact and dimension tables and progressing through intermediate models to the final reporting tables.


#### **ERD Diagram**
The ERD diagram below shows the relationships between columns in the fact and dimension tables. It highlights the key attributes used for calculations and their connections.

---

### **Conclusion**
This dimensional model design balances computational efficiency, scalability, and analytical depth. It provides a robust foundation for monitoring and optimizing marketing performance through the defined KPIs while ensuring flexibility for future enhancements.
