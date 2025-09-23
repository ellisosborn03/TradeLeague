#!/usr/bin/env python3
"""
Fitcentive Payment Analysis - Visual Dashboard
Generate plots for paid users by location with cost analysis
"""

import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import seaborn as sns
from matplotlib.patches import Rectangle
import warnings
warnings.filterwarnings('ignore')

# Set style
plt.style.use('seaborn-v0_8')
sns.set_palette("husl")

# Payment data from database
payment_data = {
    'Region': [
        'United States (Eastern)',
        'United States (Central)', 
        'United States (Pacific)',
        'Europe',
        'Pacific',
        'Americas (Other)',
        'Asia'
    ],
    'Unique_Paid_Users': [29, 23, 15, 6, 1, 2, 2],
    'Total_Payments': [43, 29, 23, 8, 5, 2, 3],
    'Total_Revenue': [920.00, 690.00, 500.00, 195.00, 100.00, 50.00, 30.00],
    'Avg_Payment': [21.40, 23.79, 21.74, 24.38, 20.00, 25.00, 10.00],
    'Revenue_Per_User': [31.72, 30.00, 33.33, 32.50, 100.00, 25.00, 15.00]
}

df = pd.DataFrame(payment_data)

# Create the comprehensive dashboard
fig = plt.figure(figsize=(20, 16))

# Color scheme
colors = ['#FF6B6B', '#4ECDC4', '#45B7D1', '#96CEB4', '#FECA57', '#FF9FF3', '#54A0FF']

# 1. Revenue by Region (Bar Chart)
ax1 = plt.subplot(2, 3, 1)
bars1 = ax1.bar(range(len(df)), df['Total_Revenue'], color=colors, alpha=0.8)
ax1.set_title('💰 Total Revenue by Region', fontsize=16, fontweight='bold', pad=20)
ax1.set_xlabel('Region', fontsize=12)
ax1.set_ylabel('Revenue (USD)', fontsize=12)
ax1.set_xticks(range(len(df)))
ax1.set_xticklabels([region.replace(' ', '\n') for region in df['Region']], rotation=0, ha='center', fontsize=10)

# Add value labels on bars
for i, bar in enumerate(bars1):
    height = bar.get_height()
    ax1.text(bar.get_x() + bar.get_width()/2., height + 10,
             f'${height:.0f}', ha='center', va='bottom', fontweight='bold')

# 2. Number of Paid Users by Region
ax2 = plt.subplot(2, 3, 2)
bars2 = ax2.bar(range(len(df)), df['Unique_Paid_Users'], color=colors, alpha=0.8)
ax2.set_title('👥 Paid Users by Region', fontsize=16, fontweight='bold', pad=20)
ax2.set_xlabel('Region', fontsize=12)
ax2.set_ylabel('Number of Users', fontsize=12)
ax2.set_xticks(range(len(df)))
ax2.set_xticklabels([region.replace(' ', '\n') for region in df['Region']], rotation=0, ha='center', fontsize=10)

# Add value labels
for i, bar in enumerate(bars2):
    height = bar.get_height()
    ax2.text(bar.get_x() + bar.get_width()/2., height + 0.5,
             f'{int(height)}', ha='center', va='bottom', fontweight='bold')

# 3. Revenue per User (Most Important Metric)
ax3 = plt.subplot(2, 3, 3)
bars3 = ax3.bar(range(len(df)), df['Revenue_Per_User'], color=colors, alpha=0.8)
ax3.set_title('💎 Revenue per User by Region', fontsize=16, fontweight='bold', pad=20)
ax3.set_xlabel('Region', fontsize=12)
ax3.set_ylabel('Revenue per User (USD)', fontsize=12)
ax3.set_xticks(range(len(df)))
ax3.set_xticklabels([region.replace(' ', '\n') for region in df['Region']], rotation=0, ha='center', fontsize=10)

# Add value labels
for i, bar in enumerate(bars3):
    height = bar.get_height()
    ax3.text(bar.get_x() + bar.get_width()/2., height + 1,
             f'${height:.2f}', ha='center', va='bottom', fontweight='bold')

# 4. Market Share Pie Chart
ax4 = plt.subplot(2, 3, 4)
wedges, texts, autotexts = ax4.pie(df['Total_Revenue'], labels=df['Region'], autopct='%1.1f%%', 
                                   colors=colors, startangle=90, textprops={'fontsize': 10})
ax4.set_title('🌍 Revenue Market Share', fontsize=16, fontweight='bold', pad=20)

# 5. Payment Frequency Analysis
ax5 = plt.subplot(2, 3, 5)
payment_frequency = df['Total_Payments'] / df['Unique_Paid_Users']
bars5 = ax5.bar(range(len(df)), payment_frequency, color=colors, alpha=0.8)
ax5.set_title('🔄 Avg Payments per User', fontsize=16, fontweight='bold', pad=20)
ax5.set_xlabel('Region', fontsize=12)
ax5.set_ylabel('Payments per User', fontsize=12)
ax5.set_xticks(range(len(df)))
ax5.set_xticklabels([region.replace(' ', '\n') for region in df['Region']], rotation=0, ha='center', fontsize=10)

# Add value labels
for i, bar in enumerate(bars5):
    height = bar.get_height()
    ax5.text(bar.get_x() + bar.get_width()/2., height + 0.05,
             f'{height:.2f}x', ha='center', va='bottom', fontweight='bold')

# 6. Summary Statistics Table
ax6 = plt.subplot(2, 3, 6)
ax6.axis('off')

# Create summary table
summary_data = [
    ['Total Paid Users', f"{df['Unique_Paid_Users'].sum()}", '👥'],
    ['Total Revenue', f"${df['Total_Revenue'].sum():.2f}", '💰'],
    ['Avg Revenue/User', f"${df['Total_Revenue'].sum() / df['Unique_Paid_Users'].sum():.2f}", '💎'],
    ['Top Region (Revenue)', df.loc[df['Total_Revenue'].idxmax(), 'Region'], '🏆'],
    ['Top Region (Users)', df.loc[df['Unique_Paid_Users'].idxmax(), 'Region'], '👑'],
    ['Highest RPU', df.loc[df['Revenue_Per_User'].idxmax(), 'Region'], '⭐']
]

# Create table
table_y = 0.8
for i, (metric, value, emoji) in enumerate(summary_data):
    ax6.text(0.05, table_y - i*0.12, f"{emoji} {metric}:", fontsize=14, fontweight='bold', va='center')
    ax6.text(0.65, table_y - i*0.12, value, fontsize=14, va='center', 
             bbox=dict(boxstyle="round,pad=0.3", facecolor=colors[i % len(colors)], alpha=0.3))

ax6.set_title('📊 Key Metrics Summary', fontsize=16, fontweight='bold', pad=20)

# Overall title
fig.suptitle('🌟 Fitcentive Global Payment Analysis Dashboard 🌟', 
             fontsize=24, fontweight='bold', y=0.98)

# Add footer with insights
footer_text = (
    "💡 KEY INSIGHTS: Pacific region has highest Revenue/User ($100) but lowest volume (1 user). "
    "US Eastern leads in total revenue ($920) and users (29). Asia has lowest RPU ($15) - growth opportunity!"
)
fig.text(0.5, 0.02, footer_text, ha='center', va='bottom', fontsize=12, 
         style='italic', wrap=True, bbox=dict(boxstyle="round,pad=0.5", facecolor='lightblue', alpha=0.3))

plt.tight_layout()
plt.subplots_adjust(top=0.93, bottom=0.1)

# Save the plot
plt.savefig('/Users/ellis.osborn/Aptos/fitcentive_payment_dashboard.png', 
            dpi=300, bbox_inches='tight', facecolor='white')

print("🎉 Payment analysis dashboard saved as 'fitcentive_payment_dashboard.png'")
print("\n📈 EXECUTIVE SUMMARY:")
print(f"Total Paid Users: {df['Unique_Paid_Users'].sum()}")
print(f"Total Revenue: ${df['Total_Revenue'].sum():.2f}")
print(f"Average Revenue per User: ${df['Total_Revenue'].sum() / df['Unique_Paid_Users'].sum():.2f}")
print("\n🏆 TOP PERFORMERS:")
print(f"Highest Revenue: {df.loc[df['Total_Revenue'].idxmax(), 'Region']} (${df['Total_Revenue'].max():.2f})")
print(f"Most Users: {df.loc[df['Unique_Paid_Users'].idxmax(), 'Region']} ({df['Unique_Paid_Users'].max()} users)")
print(f"Highest RPU: {df.loc[df['Revenue_Per_User'].idxmax(), 'Region']} (${df['Revenue_Per_User'].max():.2f})")

plt.show()

