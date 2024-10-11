import pandas as pd
import numpy as np

# 读取文件
file_path = 'Gbar_event.psi'  # 你的文件路径
df = pd.read_csv(file_path, sep='\t', index_col=0)

# 提取并去重时期名
periods = df.columns.str.extract(r'(.+dpa)')[0].unique()

for period in periods:
    # 筛选当前时期的列
    period_columns = df.columns[df.columns.str.contains(period)]
    
    # 当前时期至少一个不为0或nan
    in_period_condition = df[period_columns].apply(lambda x: (x != 0) & (~x.isna()), axis=1).any(axis=1)
    
    # 其他时期全部为0或nan
    other_periods_columns = df.columns[~df.columns.str.contains(period)]
    out_of_period_condition = ~(df[other_periods_columns].apply(lambda x: (x != 0) & (~x.isna()), axis=1).any(axis=1))
    
    # 满足条件的事件
    unique_events = df[in_period_condition & out_of_period_condition]
    
    # 如果存在满足条件的事件，打印并保存到文件
    if not unique_events.empty:
        # 打印信息
        print(f"Unique events for {period}:")
        print(unique_events)
        
        # 保存到文件，文件名包含时期名以区分
        file_name = f'unique_events_{period}.csv'
        unique_events.to_csv(file_name, sep='\t')
        print(f"Saved to {file_name}\n")

