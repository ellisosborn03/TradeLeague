#!/usr/bin/env python3
"""
Fitcentive Lead Source Analysis - Bar Charts
Generates bar plots for new users by lead source with dates on x-axis
"""

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from datetime import datetime
import numpy as np

# Raw data from database query
raw_data = [
    {"signup_date": "2025-09-25T00:00:00.000Z", "referral_source": "app_store", "user_count": "2"},
    {"signup_date": "2025-09-25T00:00:00.000Z", "referral_source": "facebook", "user_count": "1"},
    {"signup_date": "2025-09-25T00:00:00.000Z", "referral_source": "friends_family", "user_count": "1"},
    {"signup_date": "2025-09-25T00:00:00.000Z", "referral_source": "instagram", "user_count": "9"},
    {"signup_date": "2025-09-25T00:00:00.000Z", "referral_source": "tiktok", "user_count": "3"},
    {"signup_date": "2025-09-24T00:00:00.000Z", "referral_source": "app_store", "user_count": "2"},
    {"signup_date": "2025-09-24T00:00:00.000Z", "referral_source": "facebook", "user_count": "8"},
    {"signup_date": "2025-09-24T00:00:00.000Z", "referral_source": "friends_family", "user_count": "2"},
    {"signup_date": "2025-09-24T00:00:00.000Z", "referral_source": "instagram", "user_count": "8"},
    {"signup_date": "2025-09-24T00:00:00.000Z", "referral_source": "reddit", "user_count": "1"},
    {"signup_date": "2025-09-24T00:00:00.000Z", "referral_source": "tiktok", "user_count": "13"},
    {"signup_date": "2025-09-24T00:00:00.000Z", "referral_source": "youtube", "user_count": "1"},
    {"signup_date": "2025-09-23T00:00:00.000Z", "referral_source": "app_store", "user_count": "1"},
    {"signup_date": "2025-09-23T00:00:00.000Z", "referral_source": "facebook", "user_count": "33"},
    {"signup_date": "2025-09-23T00:00:00.000Z", "referral_source": "friends_family", "user_count": "1"},
    {"signup_date": "2025-09-23T00:00:00.000Z", "referral_source": "instagram", "user_count": "11"},
    {"signup_date": "2025-09-23T00:00:00.000Z", "referral_source": "tiktok", "user_count": "22"},
    {"signup_date": "2025-09-23T00:00:00.000Z", "referral_source": "twitter_x", "user_count": "1"},
    {"signup_date": "2025-09-23T00:00:00.000Z", "referral_source": "youtube", "user_count": "3"},
    {"signup_date": "2025-09-22T00:00:00.000Z", "referral_source": "app_store", "user_count": "3"},
    {"signup_date": "2025-09-22T00:00:00.000Z", "referral_source": "facebook", "user_count": "21"},
    {"signup_date": "2025-09-22T00:00:00.000Z", "referral_source": "instagram", "user_count": "8"},
    {"signup_date": "2025-09-22T00:00:00.000Z", "referral_source": "tiktok", "user_count": "8"},
    {"signup_date": "2025-09-22T00:00:00.000Z", "referral_source": "twitter_x", "user_count": "1"},
    {"signup_date": "2025-09-21T00:00:00.000Z", "referral_source": "app_store", "user_count": "3"},
    {"signup_date": "2025-09-21T00:00:00.000Z", "referral_source": "facebook", "user_count": "29"},
    {"signup_date": "2025-09-21T00:00:00.000Z", "referral_source": "instagram", "user_count": "12"},
    {"signup_date": "2025-09-21T00:00:00.000Z", "referral_source": "tiktok", "user_count": "9"},
    {"signup_date": "2025-09-20T00:00:00.000Z", "referral_source": "app_store", "user_count": "6"},
    {"signup_date": "2025-09-20T00:00:00.000Z", "referral_source": "facebook", "user_count": "13"},
    {"signup_date": "2025-09-20T00:00:00.000Z", "referral_source": "friends_family", "user_count": "6"},
    {"signup_date": "2025-09-20T00:00:00.000Z", "referral_source": "instagram", "user_count": "6"},
    {"signup_date": "2025-09-20T00:00:00.000Z", "referral_source": "tiktok", "user_count": "10"},
    {"signup_date": "2025-09-19T00:00:00.000Z", "referral_source": "Unknown", "user_count": "9"},
    {"signup_date": "2025-09-19T00:00:00.000Z", "referral_source": "app_store", "user_count": "2"},
    {"signup_date": "2025-09-19T00:00:00.000Z", "referral_source": "facebook", "user_count": "16"},
    {"signup_date": "2025-09-19T00:00:00.000Z", "referral_source": "friends_family", "user_count": "4"},
    {"signup_date": "2025-09-19T00:00:00.000Z", "referral_source": "instagram", "user_count": "8"},
    {"signup_date": "2025-09-19T00:00:00.000Z", "referral_source": "tiktok", "user_count": "3"},
    {"signup_date": "2025-09-19T00:00:00.000Z", "referral_source": "youtube", "user_count": "2"},
    {"signup_date": "2025-09-18T00:00:00.000Z", "referral_source": "facebook", "user_count": "35"},
    {"signup_date": "2025-09-18T00:00:00.000Z", "referral_source": "friends_family", "user_count": "1"},
    {"signup_date": "2025-09-18T00:00:00.000Z", "referral_source": "instagram", "user_count": "7"},
    {"signup_date": "2025-09-18T00:00:00.000Z", "referral_source": "strava", "user_count": "1"},
    {"signup_date": "2025-09-18T00:00:00.000Z", "referral_source": "tiktok", "user_count": "1"},
    {"signup_date": "2025-09-17T00:00:00.000Z", "referral_source": "Unknown", "user_count": "1"},
    {"signup_date": "2025-09-17T00:00:00.000Z", "referral_source": "app_store", "user_count": "2"},
    {"signup_date": "2025-09-17T00:00:00.000Z", "referral_source": "facebook", "user_count": "7"},
    {"signup_date": "2025-09-17T00:00:00.000Z", "referral_source": "friends_family", "user_count": "4"},
    {"signup_date": "2025-09-17T00:00:00.000Z", "referral_source": "instagram", "user_count": "5"},
    {"signup_date": "2025-09-17T00:00:00.000Z", "referral_source": "tiktok", "user_count": "2"},
    {"signup_date": "2025-09-16T00:00:00.000Z", "referral_source": "Unknown", "user_count": "3"},
    {"signup_date": "2025-09-16T00:00:00.000Z", "referral_source": "facebook", "user_count": "7"},
    {"signup_date": "2025-09-16T00:00:00.000Z", "referral_source": "instagram", "user_count": "4"},
    {"signup_date": "2025-09-16T00:00:00.000Z", "referral_source": "tiktok", "user_count": "5"},
    {"signup_date": "2025-09-16T00:00:00.000Z", "referral_source": "youtube", "user_count": "2"},
    {"signup_date": "2025-09-15T00:00:00.000Z", "referral_source": "Unknown", "user_count": "4"},
    {"signup_date": "2025-09-15T00:00:00.000Z", "referral_source": "app_store", "user_count": "4"},
    {"signup_date": "2025-09-15T00:00:00.000Z", "referral_source": "facebook", "user_count": "6"},
    {"signup_date": "2025-09-15T00:00:00.000Z", "referral_source": "friends_family", "user_count": "1"},
    {"signup_date": "2025-09-15T00:00:00.000Z", "referral_source": "instagram", "user_count": "5"},
    {"signup_date": "2025-09-15T00:00:00.000Z", "referral_source": "tiktok", "user_count": "2"},
    {"signup_date": "2025-09-14T00:00:00.000Z", "referral_source": "Unknown", "user_count": "2"},
    {"signup_date": "2025-09-14T00:00:00.000Z", "referral_source": "app_store", "user_count": "1"},
    {"signup_date": "2025-09-14T00:00:00.000Z", "referral_source": "facebook", "user_count": "6"},
    {"signup_date": "2025-09-14T00:00:00.000Z", "referral_source": "instagram", "user_count": "2"},
    {"signup_date": "2025-09-14T00:00:00.000Z", "referral_source": "tiktok", "user_count": "4"},
]

def create_lead_source_charts():
    """Create bar charts for lead source analysis"""
    
    # Convert to DataFrame
    df = pd.DataFrame(raw_data)
    df['signup_date'] = pd.to_datetime(df['signup_date'])
    df['user_count'] = df['user_count'].astype(int)
    df['date_str'] = df['signup_date'].dt.strftime('%m/%d')
    
    # Color palette for different lead sources
    colors = {
        'facebook': '#1877F2',
        'instagram': '#E4405F', 
        'tiktok': '#000000',
        'youtube': '#FF0000',
        'app_store': '#007AFF',
        'friends_family': '#34C759',
        'twitter_x': '#1DA1F2',
        'reddit': '#FF4500',
        'strava': '#FC4C02',
        'Unknown': '#8E8E93'
    }
    
    # Create figure with 2 subplots
    fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(16, 12))
    
    # Chart 1: New Users by Lead Source and Date
    pivot_df = df.pivot(index='date_str', columns='referral_source', values='user_count').fillna(0)
    
    # Reorder columns by total users (descending)
    col_totals = pivot_df.sum().sort_values(ascending=False)
    pivot_df = pivot_df[col_totals.index]
    
    # Create stacked bar chart
    bottom = np.zeros(len(pivot_df))
    bars = []
    
    for source in pivot_df.columns:
        color = colors.get(source, '#999999')
        bar = ax1.bar(pivot_df.index, pivot_df[source], bottom=bottom, 
                     label=source, color=color, alpha=0.8)
        bars.append(bar)
        bottom += pivot_df[source]
    
    ax1.set_title('New Users by Lead Source (Last 2 Weeks)', fontsize=16, fontweight='bold', pad=20)
    ax1.set_xlabel('Date', fontsize=12)
    ax1.set_ylabel('Number of New Users', fontsize=12)
    ax1.legend(bbox_to_anchor=(1.05, 1), loc='upper left')
    ax1.grid(True, alpha=0.3)
    
    # Rotate x-axis labels for better readability
    plt.setp(ax1.get_xticklabels(), rotation=45, ha='right')
    
    # Chart 2: Lead Source Performance (Total Users)
    source_totals = df.groupby('referral_source')['user_count'].sum().sort_values(ascending=False)
    
    bar_colors = [colors.get(source, '#999999') for source in source_totals.index]
    bars2 = ax2.bar(range(len(source_totals)), source_totals.values, 
                   color=bar_colors, alpha=0.8)
    
    ax2.set_title('Total New Users by Lead Source (Last 2 Weeks)', fontsize=16, fontweight='bold', pad=20)
    ax2.set_xlabel('Lead Source', fontsize=12)
    ax2.set_ylabel('Total New Users', fontsize=12)
    ax2.set_xticks(range(len(source_totals)))
    ax2.set_xticklabels(source_totals.index, rotation=45, ha='right')
    ax2.grid(True, alpha=0.3)
    
    # Add value labels on bars
    for i, bar in enumerate(bars2):
        height = bar.get_height()
        ax2.text(bar.get_x() + bar.get_width()/2., height + 0.5,
                f'{int(height)}', ha='center', va='bottom', fontweight='bold')
    
    plt.tight_layout()
    plt.savefig('/Users/ellis.osborn/Aptos/fitcentive_lead_analysis_charts.png', 
                dpi=300, bbox_inches='tight')
    plt.show()
    
    # Print summary statistics
    print("\n=== LEAD SOURCE ANALYSIS SUMMARY ===")
    print(f"Total new users analyzed: {df['user_count'].sum()}")
    print(f"Date range: {df['signup_date'].min().strftime('%Y-%m-%d')} to {df['signup_date'].max().strftime('%Y-%m-%d')}")
    print("\nTop performing lead sources:")
    for i, (source, count) in enumerate(source_totals.head(5).items(), 1):
        percentage = (count / df['user_count'].sum()) * 100
        print(f"{i}. {source}: {count} users ({percentage:.1f}%)")
    
    return df, source_totals

def create_paid_users_chart():
    """Create chart for paid users by date"""
    
    # Paid users data from database (all showing 'Unknown' referral source)
    paid_data = [
        {"payment_date": "2025-09-25T00:00:00.000Z", "referral_source": "Unknown", "paid_users": "3"},
        {"payment_date": "2025-09-24T00:00:00.000Z", "referral_source": "Unknown", "paid_users": "2"},
        {"payment_date": "2025-09-23T00:00:00.000Z", "referral_source": "Unknown", "paid_users": "4"},
        {"payment_date": "2025-09-22T00:00:00.000Z", "referral_source": "Unknown", "paid_users": "4"},
        {"payment_date": "2025-09-21T00:00:00.000Z", "referral_source": "Unknown", "paid_users": "8"},
        {"payment_date": "2025-09-20T00:00:00.000Z", "referral_source": "Unknown", "paid_users": "6"},
        {"payment_date": "2025-09-19T00:00:00.000Z", "referral_source": "Unknown", "paid_users": "3"},
        {"payment_date": "2025-09-18T00:00:00.000Z", "referral_source": "Unknown", "paid_users": "2"},
        {"payment_date": "2025-09-17T00:00:00.000Z", "referral_source": "Unknown", "paid_users": "3"},
        {"payment_date": "2025-09-16T00:00:00.000Z", "referral_source": "Unknown", "paid_users": "3"},
        {"payment_date": "2025-09-15T00:00:00.000Z", "referral_source": "Unknown", "paid_users": "4"},
        {"payment_date": "2025-09-14T00:00:00.000Z", "referral_source": "Unknown", "paid_users": "2"},
        {"payment_date": "2025-09-13T00:00:00.000Z", "referral_source": "Unknown", "paid_users": "2"},
        {"payment_date": "2025-09-12T00:00:00.000Z", "referral_source": "Unknown", "paid_users": "5"},
        {"payment_date": "2025-09-11T00:00:00.000Z", "referral_source": "Unknown", "paid_users": "5"},
        {"payment_date": "2025-09-10T00:00:00.000Z", "referral_source": "Unknown", "paid_users": "10"},
        {"payment_date": "2025-09-09T00:00:00.000Z", "referral_source": "Unknown", "paid_users": "6"},
        {"payment_date": "2025-09-08T00:00:00.000Z", "referral_source": "Unknown", "paid_users": "7"},
        {"payment_date": "2025-09-07T00:00:00.000Z", "referral_source": "Unknown", "paid_users": "5"},
        {"payment_date": "2025-09-06T00:00:00.000Z", "referral_source": "Unknown", "paid_users": "5"},
    ]
    
    # Convert to DataFrame
    paid_df = pd.DataFrame(paid_data)
    paid_df['payment_date'] = pd.to_datetime(paid_df['payment_date'])
    paid_df['paid_users'] = paid_df['paid_users'].astype(int)
    paid_df['date_str'] = paid_df['payment_date'].dt.strftime('%m/%d')
    
    # Sort by date
    paid_df = paid_df.sort_values('payment_date')
    
    fig, ax = plt.subplots(1, 1, figsize=(14, 8))
    
    # Create bar chart
    bars = ax.bar(paid_df['date_str'], paid_df['paid_users'], 
                  color='#FF6B6B', alpha=0.8, edgecolor='black', linewidth=0.5)
    
    # Add value labels on bars
    for bar in bars:
        height = bar.get_height()
        if height > 0:
            ax.text(bar.get_x() + bar.get_width()/2., height + 0.1,
                    f'{int(height)}', ha='center', va='bottom', fontweight='bold')
    
    ax.set_title('Paid Users by Date (Last 20 Days)', fontsize=16, fontweight='bold', pad=20)
    ax.set_xlabel('Date', fontsize=12)
    ax.set_ylabel('Number of Paid Users', fontsize=12)
    ax.grid(True, alpha=0.3, axis='y')
    
    # Rotate x-axis labels
    plt.setp(ax.get_xticklabels(), rotation=45, ha='right')
    
    # Add note about referral source
    ax.text(0.02, 0.98, 'Note: All paid users show "Unknown" referral source\n(likely older users before tracking)', 
            transform=ax.transAxes, fontsize=10, verticalalignment='top',
            bbox=dict(boxstyle="round,pad=0.3", facecolor="yellow", alpha=0.3))
    
    plt.tight_layout()
    plt.savefig('/Users/ellis.osborn/Aptos/fitcentive_paid_users_analysis.png', 
                dpi=300, bbox_inches='tight')
    plt.show()
    
    print("\n=== PAID USERS ANALYSIS ===")
    print(f"Total paid users in last 20 days: {paid_df['paid_users'].sum()}")
    print(f"Average daily paid users: {paid_df['paid_users'].mean():.1f}")
    print(f"Peak day: {paid_df.loc[paid_df['paid_users'].idxmax(), 'date_str']} ({paid_df['paid_users'].max()} users)")
    print("Note: All paying users show 'Unknown' referral source (likely pre-tracking users)")
    
    return paid_df

if __name__ == "__main__":
    print("Creating Lead Source Analysis Charts...")
    df, totals = create_lead_source_charts()
    
    print("\nCreating Paid Users Analysis Chart...")
    create_paid_users_chart()
    
    print("\nCharts saved as PNG files in the current directory.")
