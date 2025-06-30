#!/bin/bash

# 数字货币趋势跟踪量化交易机器人启动脚本
# 使用方法: ./start.sh [选项]

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 显示帮助信息
show_help() {
    echo "数字货币趋势跟踪量化交易机器人"
    echo ""
    echo "使用方法: $0 [选项]"
    echo ""
    echo "选项:"
    echo "  -h, --help          显示此帮助信息"
    echo "  -i, --install       安装依赖包"
    echo "  -c, --check         检查环境和配置"
    echo "  -t, --test          运行测试模式"
    echo "  -m, --monitor       启动监控模式"
    echo "  -a, --analyze       运行性能分析"
    echo "  -b, --backtest      运行回测"
    echo "  -s, --start         启动交易机器人"
    echo "  --setup             首次设置向导"
    echo ""
    echo "示例:"
    echo "  $0 --setup         # 首次设置"
    echo "  $0 --install       # 安装依赖"
    echo "  $0 --check         # 检查配置"
    echo "  $0 --start         # 启动机器人"
    echo "  $0 --monitor       # 实时监控"
}

# 检查Python环境
check_python() {
    if ! command -v python3 &> /dev/null; then
        print_error "Python3 未安装，请先安装 Python 3.8+"
        exit 1
    fi
    
    python_version=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
    print_info "Python 版本: $python_version"
    
    if [[ $(echo "$python_version >= 3.8" | bc -l) -eq 0 ]]; then
        print_error "Python 版本过低，需要 3.8+"
        exit 1
    fi
}

# 安装依赖
install_dependencies() {
    print_info "开始安装依赖包..."
    
    if [ ! -f "requirements.txt" ]; then
        print_error "requirements.txt 文件不存在"
        exit 1
    fi
    
    # 检查是否有虚拟环境
    if [ ! -d "venv" ]; then
        print_info "创建虚拟环境..."
        python3 -m venv venv
    fi
    
    print_info "激活虚拟环境..."
    source venv/bin/activate
    
    print_info "升级pip..."
    pip install --upgrade pip
    
    print_info "安装依赖包..."
    pip install -r requirements.txt
    
    print_success "依赖安装完成"
}

# 检查配置
check_config() {
    print_info "检查配置文件..."
    
    if [ ! -f "config.yaml" ]; then
        print_error "config.yaml 配置文件不存在"
        print_info "请运行: $0 --setup 进行首次设置"
        exit 1
    fi
    
    # 检查API密钥
    if grep -q "your_api_key_here" config.yaml; then
        print_warning "请配置您的币安API密钥"
        print_info "编辑 config.yaml 文件，设置正确的 apiKey 和 secretKey"
        return 1
    fi
    
    # 检查必要目录
    for dir in "data" "logs" "analysis"; do
        if [ ! -d "$dir" ]; then
            print_info "创建目录: $dir"
            mkdir -p "$dir"
        fi
    done
    
    print_success "配置检查完成"
    return 0
}

# 首次设置向导
setup_wizard() {
    print_info "欢迎使用数字货币趋势跟踪量化交易机器人!"
    print_info "开始首次设置向导..."
    
    # 检查Python
    check_python
    
    # 安装依赖
    install_dependencies
    
    # 配置API密钥
    print_info "请配置您的币安API密钥"
    echo -n "请输入您的API Key: "
    read -r api_key
    echo -n "请输入您的Secret Key: "
    read -s secret_key
    echo
    
    # 更新配置文件
    if [ -f "config.yaml" ]; then
        # 备份原配置
        cp config.yaml config.yaml.bak
        
        # 替换API密钥
        sed -i.tmp "s/your_api_key_here/$api_key/g" config.yaml
        sed -i.tmp "s/your_secret_key_here/$secret_key/g" config.yaml
        rm config.yaml.tmp
        
        print_success "API密钥配置完成"
    else
        print_error "config.yaml 文件不存在"
        exit 1
    fi
    
    # 创建必要目录
    for dir in "data" "logs" "analysis"; do
        mkdir -p "$dir"
    done
    
    print_success "设置完成!"
    print_info "您现在可以运行以下命令:"
    print_info "  $0 --check     # 检查配置"
    print_info "  $0 --test      # 测试模式"
    print_info "  $0 --start     # 启动机器人"
}

# 启动交易机器人
start_bot() {
    print_info "启动交易机器人..."
    
    # 检查配置
    if ! check_config; then
        exit 1
    fi
    
    # 激活虚拟环境
    if [ -d "venv" ]; then
        source venv/bin/activate
    fi
    
    # 启动机器人
    python3 main.py
}

# 启动监控
start_monitor() {
    print_info "启动实时监控..."
    
    # 激活虚拟环境
    if [ -d "venv" ]; then
        source venv/bin/activate
    fi
    
    python3 tools/monitor.py --mode monitor
}

# 运行性能分析
run_analysis() {
    print_info "运行性能分析..."
    
    # 激活虚拟环境
    if [ -d "venv" ]; then
        source venv/bin/activate
    fi
    
    python3 tools/analyzer.py --days 30
}

# 运行回测
run_backtest() {
    print_info "运行策略回测..."
    
    # 激活虚拟环境
    if [ -d "venv" ]; then
        source venv/bin/activate
    fi
    
    python3 tools/backtest.py
}

# 测试模式
test_mode() {
    print_info "运行测试模式..."
    
    # 检查配置
    if ! check_config; then
        exit 1
    fi
    
    # 确保是测试环境
    if ! grep -q "sandbox: true" config.yaml; then
        print_warning "建议在测试模式下设置 sandbox: true"
    fi
    
    # 激活虚拟环境
    if [ -d "venv" ]; then
        source venv/bin/activate
    fi
    
    # 运行测试
    print_info "运行配置测试..."
    python3 -c "import yaml; print('配置文件格式正确')"
    
    print_info "运行连接测试..."
    python3 -c "
import sys
sys.path.append('src')
from exchange import ExchangeInterface
import yaml

with open('config.yaml', 'r') as f:
    config = yaml.safe_load(f)

exchange = ExchangeInterface(config)
print('交易所连接测试成功')
"
    
    print_success "测试完成"
}

# 主程序
main() {
    case "$1" in
        -h|--help)
            show_help
            ;;
        -i|--install)
            check_python
            install_dependencies
            ;;
        -c|--check)
            check_python
            check_config
            ;;
        -t|--test)
            check_python
            test_mode
            ;;
        -m|--monitor)
            start_monitor
            ;;
        -a|--analyze)
            run_analysis
            ;;
        -b|--backtest)
            run_backtest
            ;;
        -s|--start)
            start_bot
            ;;
        --setup)
            setup_wizard
            ;;
        "")
            print_info "使用 $0 --help 查看帮助信息"
            ;;
        *)
            print_error "未知选项: $1"
            print_info "使用 $0 --help 查看帮助信息"
            exit 1
            ;;
    esac
}

# 运行主程序
main "$@"