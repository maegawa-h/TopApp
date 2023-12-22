import matplotlib.pyplot as plt
import pandas as pd

# データの読み込み
data = pd.read_csv('data.csv')

# 図表の作成
plt.figure(figsize=(10,6))
plt.plot(data['column1'], data['column2'])
plt.title('Title')
plt.xlabel('X-axis label')
plt.ylabel('Y-axis label')

# 画像ファイルとして保存
plt.savefig('chart.png')
