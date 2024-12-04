
# Marketing Analytics Case Study

This repository showcases my approach to solving the marketing analytics case study. The task was divided into two main components: defining KPI metrics to support marketing decision-making (Task 1) and designing a robust data model to calculate and analyze these metrics (Task 2). Below, I will outline the methodology, key considerations, and design decisions for Task 2.

---

### **Task 1: KPI Design**
I have provided a detailed report in [this](https://docs.google.com/document/d/1uTq3ZCMz8J9qYmHe4q-8mbPYSoegK_f-pngz7P2rPfo/edit?usp=sharing) repository that explains the rationale behind the selected KPIs: **Activation Rate**, **ROAS (Return on Ad Spend)**, and **Cost Per Hire (CPH)**. These KPIs were designed to strike a balance between short-term actionability and long-term strategic insights for optimizing marketing performance. The report also explains how each KPI supports specific marketing decisions and how they were calculated.

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

### **Frequency-Specific Models and Layered Architecture**
I intentionally avoided creating a single model to house all metrics in one table due to differences in their frequencies. Activation Rate is calculated daily, while ROAS and Cost Per Hire are aggregated monthly. This approach ensures that each metric's granularity aligns with its purpose.

I structured the models into three distinct layers to maintain clarity, scalability, and flexibility:

**Fact and Dimension Tables (Warehouse Layer):** This layer contains raw fact and dimension tables (e.g., fact_application_logs, fact_campaign_spend, dim_candidates, dim_jobs) that serve as the foundation for all calculations. These tables are assumed to be available and are not modified.

**Intermediate Layer:** This layer is used for further aggregations and staging meaningful data structures for reporting. For example, models like candidate_activity and monthly_spend provide consolidated data that makes downstream reporting more efficient.

**Reporting Layer:** The reporting layer provides models specifically designed for dashboards and sharing with analysts. This layer includes the final models like daily_activation_rate, monthly_roas, and monthly_cost_per_hire, enabling analysts to create reports tailored to their needs. For unique reporting requirements, a dedicated folder can be created within this layer, along with an additional staging layer for detailed calculations, without modifying the warehouse-level tables.

These separate layers ensure that reporting and analytics remain modular and flexible. For example, a dashboard can show daily trends for Activation Rate to assess engagement quality, while another can present monthly ROAS and CPH to evaluate profitability and cost-efficiency. By cross-checking these metrics, campaigns can be compared, and performance improvements can be identified.

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

---

### **Visual Representations**

#### **Lineage Diagram**
<img width="1503" alt="image" src="https://github.com/user-attachments/assets/ef36392e-fb93-499c-8444-6915e774cecc">


#### **ERD Diagram**
<img width="744" alt="image" src="https://github.com/user-attachments/assets/72e0e0a1-cd33-4ccc-8024-eccf6a6086e6">


---

### **Conclusion**
This dimensional model design balances computational efficiency, scalability, and analytical depth. It provides a robust foundation for monitoring and optimizing marketing performance through the defined KPIs while ensuring flexibility for future enhancements.
