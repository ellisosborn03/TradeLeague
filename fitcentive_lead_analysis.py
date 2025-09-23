#!/usr/bin/env python3
"""
Fitcentive Lead Source Analysis - September 18-19, 2025
Comprehensive analysis of user acquisition and demographics
"""

import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import seaborn as sns
from datetime import datetime

# Set style for professional charts
plt.style.use('seaborn-v0_8')
sns.set_palette("husl")

# Raw data from database queries
lead_source_data = [
    {"date": "2025-09-18", "source": "facebook", "users": 35, "male": 4, "female": 27, "unknown": 4, "avg_age": 39.8},
    {"date": "2025-09-18", "source": "instagram", "users": 7, "male": 1, "female": 6, "unknown": 0, "avg_age": 29.1},
    {"date": "2025-09-18", "source": "friends_family", "users": 1, "male": 1, "female": 0, "unknown": 0, "avg_age": 22.0},
    {"date": "2025-09-18", "source": "strava", "users": 1, "male": 0, "female": 0, "unknown": 1, "avg_age": 35.0},
    {"date": "2025-09-18", "source": "tiktok", "users": 1, "male": 0, "female": 1, "unknown": 0, "avg_age": 29.0},
    {"date": "2025-09-19", "source": "facebook", "users": 16, "male": 1, "female": 15, "unknown": 0, "avg_age": 39.4},
    {"date": "2025-09-19", "source": "Unknown", "users": 9, "male": 4, "female": 3, "unknown": 2, "avg_age": 30.3},
    {"date": "2025-09-19", "source": "instagram", "users": 8, "male": 3, "female": 3, "unknown": 2, "avg_age": 27.5},
    {"date": "2025-09-19", "source": "friends_family", "users": 4, "male": 4, "female": 0, "unknown": 0, "avg_age": 22.5},
    {"date": "2025-09-19", "source": "tiktok", "users": 3, "male": 0, "female": 3, "unknown": 0, "avg_age": 27.0},
    {"date": "2025-09-19", "source": "app_store", "users": 2, "male": 1, "female": 1, "unknown": 0, "avg_age": 32.0},
    {"date": "2025-09-19", "source": "youtube", "users": 2, "male": 2, "female": 0, "unknown": 0, "avg_age": 14.0},
]

# Age distribution data
age_dist_data = [
    {"date": "2025-09-18", "source": "facebook", "age_bucket": "18-24", "users": 2},
    {"date": "2025-09-18", "source": "facebook", "age_bucket": "25-34", "users": 10},
    {"date": "2025-09-18", "source": "facebook", "age_bucket": "35-44", "users": 14},
    {"date": "2025-09-18", "source": "facebook", "age_bucket": "45-54", "users": 4},
    {"date": "2025-09-18", "source": "facebook", "age_bucket": "55+", "users": 5},
    {"date": "2025-09-18", "source": "instagram", "age_bucket": "18-24", "users": 3},
    {"date": "2025-09-18", "source": "instagram", "age_bucket": "25-34", "users": 1},
    {"date": "2025-09-18", "source": "instagram", "age_bucket": "35-44", "users": 3},
    {"date": "2025-09-19", "source": "facebook", "age_bucket": "18-24", "users": 1},
    {"date": "2025-09-19", "source": "facebook", "age_bucket": "25-34", "users": 6},
    {"date": "2025-09-19", "source": "facebook", "age_bucket": "35-44", "users": 3},
    {"date": "2025-09-19", "source": "facebook", "age_bucket": "45-54", "users": 5},
    {"date": "2025-09-19", "source": "facebook", "age_bucket": "55+", "users": 1},
    {"date": "2025-09-19", "source": "instagram", "age_bucket": "Under 18", "users": 1},
    {"date": "2025-09-19", "source": "instagram", "age_bucket": "18-24", "users": 3},
    {"date": "2025-09-19", "source": "instagram", "age_bucket": "35-44", "users": 4},
    {"date": "2025-09-19", "source": "Unknown", "age_bucket": "Under 18", "users": 1},
    {"date": "2025-09-19", "source": "Unknown", "age_bucket": "18-24", "users": 3},
    {"date": "2025-09-19", "source": "Unknown", "age_bucket": "25-34", "users": 2},
    {"date": "2025-09-19", "source": "Unknown", "age_bucket": "35-44", "users": 2},
    {"date": "2025-09-19", "source": "Unknown", "age_bucket": "55+", "users": 1},
]

# Create DataFrames
df_leads = pd.DataFrame(lead_source_data)
df_age = pd.DataFrame(age_dist_data)

# Summary statistics
total_users = df_leads['users'].sum()
sept_18_users = df_leads[df_leads['date'] == '2025-09-18']['users'].sum()
sept_19_users = df_leads[df_leads['date'] == '2025-09-19']['users'].sum()

print("="*80)
print("FITCENTIVE LEAD SOURCE ANALYSIS - SEPTEMBER 18-19, 2025")
print("="*80)
print(f"📊 EXECUTIVE SUMMARY")
print(f"Total New Users: {total_users}")
print(f"Sept 18: {sept_18_users} users | Sept 19: {sept_19_users} users")
print(f"Daily Change: {((sept_19_users - sept_18_users) / sept_18_users * 100):+.1f}%")
print()

# Key findings
print("🎯 KEY FINDINGS:")
print("• Facebook is the dominant lead source (57.3% of all signups)")
print("• Instagram is the second largest source (16.9% of signups)")
print("• Female users dominate (66.3% vs 23.6% male)")
print("• Average age is 34.5 years across all sources")
print("• Apple Auth preferred over Google (61.8% vs 36.0%)")
print("• ZERO paid users during this period - all users are unpaid")
print()

# Create comprehensive visualizations
fig = plt.figure(figsize=(20, 24))

# 1. Lead Source Distribution (Pie Chart)
ax1 = plt.subplot(4, 3, 1)
source_totals = df_leads.groupby('source')['users'].sum().sort_values(ascending=False)
colors = plt.cm.Set3(np.linspace(0, 1, len(source_totals)))
wedges, texts, autotexts = ax1.pie(source_totals.values, labels=source_totals.index, autopct='%1.1f%%', 
                                  colors=colors, startangle=90)
ax1.set_title('Lead Source Distribution\n(Sept 18-19 Combined)', fontsize=14, fontweight='bold')
for autotext in autotexts:
    autotext.set_color('white')
    autotext.set_fontweight('bold')

# 2. Daily User Acquisition by Source
ax2 = plt.subplot(4, 3, 2)
pivot_data = df_leads.pivot(index='source', columns='date', values='users').fillna(0)
pivot_data.plot(kind='bar', ax=ax2, color=['#FF6B6B', '#4ECDC4'])
ax2.set_title('Daily User Acquisition by Source', fontsize=14, fontweight='bold')
ax2.set_xlabel('Lead Source')
ax2.set_ylabel('Number of Users')
ax2.legend(['Sept 18', 'Sept 19'])
ax2.tick_params(axis='x', rotation=45)

# 3. Gender Distribution by Source
ax3 = plt.subplot(4, 3, 3)
df_gender = df_leads.groupby('source')[['male', 'female', 'unknown']].sum()
df_gender.plot(kind='bar', stacked=True, ax=ax3, color=['#87CEEB', '#FFB6C1', '#D3D3D3'])
ax3.set_title('Gender Distribution by Lead Source', fontsize=14, fontweight='bold')
ax3.set_xlabel('Lead Source')
ax3.set_ylabel('Number of Users')
ax3.legend(['Male', 'Female', 'Unknown'])
ax3.tick_params(axis='x', rotation=45)

# 4. Average Age by Source
ax4 = plt.subplot(4, 3, 4)
age_by_source = df_leads.groupby('source').apply(
    lambda x: np.average(x['avg_age'], weights=x['users'])
).sort_values(ascending=True)
bars = ax4.barh(range(len(age_by_source)), age_by_source.values, color=plt.cm.viridis(np.linspace(0, 1, len(age_by_source))))
ax4.set_yticks(range(len(age_by_source)))
ax4.set_yticklabels(age_by_source.index)
ax4.set_xlabel('Average Age (Years)')
ax4.set_title('Average Age by Lead Source', fontsize=14, fontweight='bold')
for i, v in enumerate(age_by_source.values):
    ax4.text(v + 0.5, i, f'{v:.1f}', va='center', fontweight='bold')

# 5. Top Sources Detailed Breakdown
ax5 = plt.subplot(4, 3, 5)
top_sources = df_leads.groupby('source')['users'].sum().nlargest(5)
x_pos = np.arange(len(top_sources))
bars = ax5.bar(x_pos, top_sources.values, color=['#FF6B6B', '#4ECDC4', '#45B7D1', '#96CEB4', '#FFEAA7'])
ax5.set_xticks(x_pos)
ax5.set_xticklabels(top_sources.index, rotation=45)
ax5.set_ylabel('Total Users')
ax5.set_title('Top 5 Lead Sources (Total Users)', fontsize=14, fontweight='bold')
for i, v in enumerate(top_sources.values):
    ax5.text(i, v + 0.5, str(v), ha='center', va='bottom', fontweight='bold')

# 6. Gender Ratio Analysis
ax6 = plt.subplot(4, 3, 6)
total_male = df_leads['male'].sum()
total_female = df_leads['female'].sum()
total_unknown = df_leads['unknown'].sum()
gender_data = [total_female, total_male, total_unknown]
gender_labels = ['Female', 'Male', 'Unknown']
colors_gender = ['#FFB6C1', '#87CEEB', '#D3D3D3']
wedges, texts, autotexts = ax6.pie(gender_data, labels=gender_labels, autopct='%1.1f%%', 
                                  colors=colors_gender, startangle=90)
ax6.set_title('Overall Gender Distribution', fontsize=14, fontweight='bold')
for autotext in autotexts:
    autotext.set_color('white')
    autotext.set_fontweight('bold')

# 7. Age Distribution Heatmap
ax7 = plt.subplot(4, 3, 7)
age_pivot = df_age.pivot_table(index='source', columns='age_bucket', values='users', fill_value=0, aggfunc='sum')
age_order = ['Under 18', '18-24', '25-34', '35-44', '45-54', '55+']
age_pivot = age_pivot.reindex(columns=[col for col in age_order if col in age_pivot.columns])
sns.heatmap(age_pivot, annot=True, fmt='d', cmap='YlOrRd', ax=ax7)
ax7.set_title('Age Distribution Heatmap by Source', fontsize=14, fontweight='bold')
ax7.set_xlabel('Age Groups')
ax7.set_ylabel('Lead Sources')

# 8. Daily Trend Analysis
ax8 = plt.subplot(4, 3, 8)
daily_totals = df_leads.groupby('date')['users'].sum()
ax8.plot(daily_totals.index, daily_totals.values, marker='o', linewidth=3, markersize=8, color='#FF6B6B')
ax8.set_title('Daily User Acquisition Trend', fontsize=14, fontweight='bold')
ax8.set_xlabel('Date')
ax8.set_ylabel('Total Users')
ax8.grid(True, alpha=0.3)
for i, v in enumerate(daily_totals.values):
    ax8.annotate(str(v), (i, v), textcoords="offset points", xytext=(0,10), ha='center', fontweight='bold')

# 9. Source Performance Matrix
ax9 = plt.subplot(4, 3, 9)
source_summary = df_leads.groupby('source').agg({
    'users': 'sum',
    'avg_age': lambda x: np.average(x, weights=df_leads.loc[x.index, 'users'])
}).round(1)
scatter = ax9.scatter(source_summary['users'], source_summary['avg_age'], 
                     s=source_summary['users']*10, alpha=0.6, c=range(len(source_summary)), cmap='viridis')
ax9.set_xlabel('Total Users')
ax9.set_ylabel('Average Age')
ax9.set_title('Source Performance Matrix\n(Bubble size = User count)', fontsize=14, fontweight='bold')
for i, (source, data) in enumerate(source_summary.iterrows()):
    ax9.annotate(source, (data['users'], data['avg_age']), xytext=(5, 5), 
                textcoords='offset points', fontsize=9, fontweight='bold')

# 10. Auth Method Distribution
ax10 = plt.subplot(4, 3, 10)
auth_data = {
    'Apple': 55,
    'Google': 32,
    'Email': 2
}
ax10.pie(auth_data.values(), labels=auth_data.keys(), autopct='%1.1f%%', 
         colors=['#007AFF', '#4285F4', '#34A853'], startangle=90)
ax10.set_title('Authentication Method Distribution', fontsize=14, fontweight='bold')

# 11. Demographic Summary Table
ax11 = plt.subplot(4, 3, 11)
ax11.axis('tight')
ax11.axis('off')
demo_data = [
    ['Metric', 'Value'],
    ['Total Users', f'{total_users}'],
    ['Female %', f'{(total_female/total_users*100):.1f}%'],
    ['Male %', f'{(total_male/total_users*100):.1f}%'],
    ['Avg Age', '34.5 years'],
    ['Top Source', 'Facebook (57.3%)'],
    ['Paid Users', '0 (0.0%)'],
    ['Apple Auth', '61.8%'],
    ['Google Auth', '36.0%']
]
table = ax11.table(cellText=demo_data[1:], colLabels=demo_data[0], 
                  cellLoc='center', loc='center', colWidths=[0.4, 0.4])
table.auto_set_font_size(False)
table.set_fontsize(11)
table.scale(1.2, 2)
ax11.set_title('Key Demographics Summary', fontsize=14, fontweight='bold', pad=20)

# 12. Lead Source Quality Score
ax12 = plt.subplot(4, 3, 12)
# Quality score based on user volume and age diversity
quality_scores = {}
for source in df_leads['source'].unique():
    source_data = df_leads[df_leads['source'] == source]
    volume_score = source_data['users'].sum()  # Raw volume
    age_diversity = source_data['avg_age'].std() if len(source_data) > 1 else 0  # Age diversity
    quality_scores[source] = volume_score + (age_diversity * 2)  # Weighted quality score

quality_df = pd.DataFrame(list(quality_scores.items()), columns=['Source', 'Quality_Score'])
quality_df = quality_df.sort_values('Quality_Score', ascending=True)

bars = ax12.barh(quality_df['Source'], quality_df['Quality_Score'], 
                color=plt.cm.RdYlGn(np.linspace(0.2, 0.8, len(quality_df))))
ax12.set_xlabel('Quality Score (Volume + Age Diversity)')
ax12.set_title('Lead Source Quality Ranking', fontsize=14, fontweight='bold')
for i, v in enumerate(quality_df['Quality_Score']):
    ax12.text(v + 0.5, i, f'{v:.1f}', va='center', fontweight='bold')

plt.tight_layout()
plt.savefig('/Users/ellis.osborn/Aptos/fitcentive_analysis_charts.png', dpi=300, bbox_inches='tight')
plt.show()

# Detailed Analysis Report
print("="*80)
print("📈 DETAILED LEAD SOURCE ANALYSIS")
print("="*80)

print("\n🎯 LEAD SOURCE PERFORMANCE:")
for _, row in df_leads.iterrows():
    print(f"  {row['date']} | {row['source']:15} | {row['users']:2d} users | "
          f"M:{row['male']:2d} F:{row['female']:2d} U:{row['unknown']:1d} | "
          f"Avg Age: {row['avg_age']:4.1f}")

print(f"\n💡 INSIGHTS & RECOMMENDATIONS:")
print(f"1. FACEBOOK DOMINANCE: 51 users (57.3%) - Mature audience (avg 39.6 years)")
print(f"2. INSTAGRAM POTENTIAL: 15 users (16.9%) - Younger audience (avg 28.2 years)")  
print(f"3. UNKNOWN SOURCES: 9 users (10.1%) - Need better tracking")
print(f"4. GENDER SKEW: 66.3% female - Consider male-focused campaigns")
print(f"5. AGE DISTRIBUTION: Strong across 25-54 age groups")
print(f"6. PAYMENT STATUS: 0% conversion to paid - major monetization opportunity")
print(f"7. AUTH PREFERENCE: Apple (61.8%) > Google (36.0%) - iOS-heavy user base")

print(f"\n⚠️  CRITICAL OBSERVATIONS:")
print(f"• NO PAID USERS: All 89 users are unpaid - immediate revenue concern")
print(f"• UNKNOWN ATTRIBUTION: 10.1% of users have unknown source - tracking gaps")
print(f"• MALE UNDERREPRESENTATION: Only 23.6% male users")
print(f"• CHALLENGE PARTICIPATION: 0% of new users joined challenges")

print("\n" + "="*80)
