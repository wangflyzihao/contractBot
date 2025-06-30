# 数字货币趋势跟踪量化交易机器人

基于Python和币安API的专业级量化交易机器人，实现趋势跟踪策略，支持现货和合约交易。

## 🚀 项目特性

- **多指标趋势识别**: 集成EMA、MACD、ADX、布林带、RSI等多种技术指标
- **智能信号生成**: 综合多指标分析，生成高质量交易信号
- **风险管理**: 完善的止损止盈机制和资金管理
- **实时监控**: 提供实时性能监控和风险预警
- **回测分析**: 支持历史数据回测和策略优化
- **数据持久化**: SQLite数据库存储交易记录和分析数据
- **可视化分析**: 丰富的图表和性能报告

## 📁 项目结构

```
contractBot/
├── src/                    # 核心源代码
│   ├── strategy.py         # 交易策略实现
│   ├── exchange.py         # 交易所接口
│   ├── risk_manager.py     # 风险管理
│   ├── data_manager.py     # 数据管理
│   └── trading_bot.py      # 主交易机器人
├── tools/                  # 工具脚本
│   ├── monitor.py          # 实时监控工具
│   ├── analyzer.py         # 性能分析工具
│   └── backtest.py         # 回测工具
├── data/                   # 数据存储目录
├── logs/                   # 日志文件目录
├── analysis/               # 分析报告目录
├── config.yaml             # 配置文件
├── requirements.txt        # 依赖包列表
├── main.py                 # 主程序入口
└── README.md              # 项目说明文档
```

## 🛠️ 安装配置

### 1. 环境要求

- Python 3.8+
- 币安API账户

### 2. 安装依赖

```bash
pip3 install -r requirements.txt
```

### 3. 配置设置

编辑 `config.yaml` 文件，配置您的币安API密钥：

```yaml
binance:
  apiKey: "your_api_key_here"
  secretKey: "your_secret_key_here"
  sandbox: true  # 测试环境，正式交易请设为false
```

**⚠️ 安全提醒**: 
- 请妥善保管您的API密钥
- 建议先在测试环境中运行
- 设置适当的API权限（仅交易权限）

## 🎯 策略说明

### 趋势识别指标

1. **EMA (指数移动平均线)**
   - 快线: 12周期
   - 慢线: 26周期
   - 用于判断价格趋势方向

2. **MACD (移动平均收敛发散)**
   - 参数: (12, 26, 9)
   - 识别趋势转换点

3. **ADX (平均趋向指数)**
   - 周期: 14
   - 衡量趋势强度

4. **布林带 (Bollinger Bands)**
   - 周期: 20
   - 标准差: 2
   - 识别超买超卖

5. **RSI (相对强弱指数)**
   - 周期: 14
   - 辅助确认信号

### 交易信号逻辑

#### 买入/做多信号
- EMA金叉 + MACD金叉
- ADX > 25 (趋势强劲)
- RSI < 70 (非超买)
- 价格突破布林带中轨

#### 卖出/做空信号
- EMA死叉 + MACD死叉
- ADX > 25 (趋势强劲)
- RSI > 30 (非超卖)
- 价格跌破布林带中轨

#### 平仓信号
- 趋势反转确认
- 止损止盈触发
- ADX < 20 (趋势减弱)

### 风险管理

- **止损**: 2% (可配置)
- **止盈**: 4% (可配置)
- **最大持仓**: 账户资金的10%
- **每日交易限制**: 10笔
- **最大回撤控制**: 10%

## 🚀 使用方法

### 1. 启动交易机器人

```bash
python3 main.py
```

### 2. 实时监控

```bash
# 实时监控模式
python3 tools/monitor.py --mode monitor

# 生成监控报告
python3 tools/monitor.py --mode report

# 导出数据
python3 tools/monitor.py --mode export --days 7
```

### 3. 性能分析

```bash
# 完整性能分析
python3 tools/analyzer.py --days 30

# 仅生成报告
python3 tools/analyzer.py --report-only --days 30

# 不生成图表
python3 tools/analyzer.py --no-charts --days 30
```

### 4. 策略回测

```bash
python3 tools/backtest.py
```

## 📊 监控指标

### 实时监控
- 当前持仓状态
- 最新交易信号
- 今日交易统计
- 实时盈亏情况

### 风险指标
- 最大回撤
- 胜率统计
- 盈亏比
- 夏普比率
- 连续亏损次数

### 性能指标
- 总收益率
- 年化收益率
- 索提诺比率
- 卡尔马比率
- 信号准确率

## ⚙️ 参数调优

### 策略参数 (config.yaml)

```yaml
strategy:
  # EMA参数
  ema_fast: 12
  ema_slow: 26
  
  # MACD参数
  macd_fast: 12
  macd_slow: 26
  macd_signal: 9
  
  # ADX参数
  adx_period: 14
  adx_threshold: 25
  
  # 布林带参数
  bb_period: 20
  bb_std: 2
  
  # RSI参数
  rsi_period: 14
  rsi_overbought: 70
  rsi_oversold: 30
```

### 风险管理参数

```yaml
risk_management:
  stop_loss_pct: 2.0      # 止损百分比
  take_profit_pct: 4.0    # 止盈百分比
  max_position_pct: 10.0  # 最大持仓百分比
  max_daily_trades: 10    # 每日最大交易次数
  max_drawdown_pct: 10.0  # 最大回撤百分比
```

## 📈 回测结果示例

```
╔══════════════════════════════════════════════════════════════╗
║                    回测结果报告                              ║
╠══════════════════════════════════════════════════════════════╣
║ 回测期间: 2024-01-01 至 2024-01-31                          ║
║ 总交易次数: 45                                               ║
║ 胜率: 62.22%                                                 ║
║ 总收益率: 15.67%                                             ║
║ 最大回撤: 3.45%                                              ║
║ 夏普比率: 1.85                                               ║
║ 盈亏比: 1.45                                                 ║
╚══════════════════════════════════════════════════════════════╝
```

## 🔧 故障排除

### 常见问题

1. **API连接失败**
   - 检查API密钥是否正确
   - 确认网络连接正常
   - 验证API权限设置

2. **数据库错误**
   - 检查data目录权限
   - 确保SQLite正常安装

3. **策略无信号**
   - 检查市场数据是否正常
   - 调整策略参数敏感度
   - 确认时间周期设置

### 日志查看

```bash
# 查看交易日志
tail -f logs/trading_bot.log

# 查看错误日志
tail -f logs/error.log
```

## 📝 开发说明

### 添加新指标

1. 在 `strategy.py` 中添加指标计算函数
2. 在 `generate_signals()` 方法中集成新指标
3. 更新配置文件参数
4. 添加相应的单元测试

### 自定义策略

1. 继承 `TrendFollowingStrategy` 类
2. 重写 `generate_signals()` 方法
3. 实现自定义的信号逻辑
4. 更新配置文件

## ⚠️ 风险提示

- **投资有风险**: 量化交易存在亏损风险，请谨慎投资
- **参数调优**: 建议充分回测后再实盘交易
- **市场变化**: 策略需要根据市场环境调整
- **资金管理**: 严格控制仓位和风险

## 📄 许可证

MIT License

## 🤝 贡献

欢迎提交Issue和Pull Request来改进项目。

## 📞 联系方式

如有问题或建议，请通过以下方式联系：
- 提交GitHub Issue
- 发送邮件至项目维护者

---

**免责声明**: 本项目仅供学习和研究使用，不构成投资建议。使用者需自行承担交易风险。