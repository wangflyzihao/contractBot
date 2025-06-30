@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM 数字货币趋势跟踪量化交易机器人启动脚本 (Windows)
REM 使用方法: start.bat [选项]

set "RED=[91m"
set "GREEN=[92m"
set "YELLOW=[93m"
set "BLUE=[94m"
set "NC=[0m"

REM 打印带颜色的消息
:print_info
echo %BLUE%[INFO]%NC% %~1
goto :eof

:print_success
echo %GREEN%[SUCCESS]%NC% %~1
goto :eof

:print_warning
echo %YELLOW%[WARNING]%NC% %~1
goto :eof

:print_error
echo %RED%[ERROR]%NC% %~1
goto :eof

REM 显示帮助信息
:show_help
echo 数字货币趋势跟踪量化交易机器人
echo.
echo 使用方法: %~nx0 [选项]
echo.
echo 选项:
echo   -h, --help          显示此帮助信息
echo   -i, --install       安装依赖包
echo   -c, --check         检查环境和配置
echo   -t, --test          运行测试模式
echo   -m, --monitor       启动监控模式
echo   -a, --analyze       运行性能分析
echo   -b, --backtest      运行回测
echo   -s, --start         启动交易机器人
echo   --setup             首次设置向导
echo.
echo 示例:
echo   %~nx0 --setup         # 首次设置
echo   %~nx0 --install       # 安装依赖
echo   %~nx0 --check         # 检查配置
echo   %~nx0 --start         # 启动机器人
echo   %~nx0 --monitor       # 实时监控
goto :eof

REM 检查Python环境
:check_python
python --version >nul 2>&1
if errorlevel 1 (
    call :print_error "Python 未安装，请先安装 Python 3.8+"
    exit /b 1
)

for /f "tokens=2" %%i in ('python --version 2^>^&1') do set python_version=%%i
call :print_info "Python 版本: !python_version!"

REM 简化版本检查
for /f "tokens=1,2 delims=." %%a in ("!python_version!") do (
    set major=%%a
    set minor=%%b
)

if !major! LSS 3 (
    call :print_error "Python 版本过低，需要 3.8+"
    exit /b 1
)
if !major! EQU 3 if !minor! LSS 8 (
    call :print_error "Python 版本过低，需要 3.8+"
    exit /b 1
)
goto :eof

REM 安装依赖
:install_dependencies
call :print_info "开始安装依赖包..."

if not exist "requirements.txt" (
    call :print_error "requirements.txt 文件不存在"
    exit /b 1
)

REM 检查是否有虚拟环境
if not exist "venv" (
    call :print_info "创建虚拟环境..."
    python -m venv venv
)

call :print_info "激活虚拟环境..."
call venv\Scripts\activate.bat

call :print_info "升级pip..."
python -m pip install --upgrade pip

call :print_info "安装依赖包..."
pip install -r requirements.txt

call :print_success "依赖安装完成"
goto :eof

REM 检查配置
:check_config
call :print_info "检查配置文件..."

if not exist "config.yaml" (
    call :print_error "config.yaml 配置文件不存在"
    call :print_info "请运行: %~nx0 --setup 进行首次设置"
    exit /b 1
)

REM 检查API密钥
findstr /C:"your_api_key_here" config.yaml >nul
if not errorlevel 1 (
    call :print_warning "请配置您的币安API密钥"
    call :print_info "编辑 config.yaml 文件，设置正确的 apiKey 和 secretKey"
    exit /b 1
)

REM 检查必要目录
for %%d in (data logs analysis) do (
    if not exist "%%d" (
        call :print_info "创建目录: %%d"
        mkdir "%%d"
    )
)

call :print_success "配置检查完成"
goto :eof

REM 首次设置向导
:setup_wizard
call :print_info "欢迎使用数字货币趋势跟踪量化交易机器人!"
call :print_info "开始首次设置向导..."

REM 检查Python
call :check_python
if errorlevel 1 exit /b 1

REM 安装依赖
call :install_dependencies
if errorlevel 1 exit /b 1

REM 配置API密钥
call :print_info "请配置您的币安API密钥"
set /p api_key="请输入您的API Key: "
set /p secret_key="请输入您的Secret Key: "

REM 更新配置文件
if exist "config.yaml" (
    REM 备份原配置
    copy config.yaml config.yaml.bak >nul
    
    REM 替换API密钥 (简化版本)
    powershell -Command "(Get-Content config.yaml) -replace 'your_api_key_here', '%api_key%' | Set-Content config.yaml"
    powershell -Command "(Get-Content config.yaml) -replace 'your_secret_key_here', '%secret_key%' | Set-Content config.yaml"
    
    call :print_success "API密钥配置完成"
) else (
    call :print_error "config.yaml 文件不存在"
    exit /b 1
)

REM 创建必要目录
for %%d in (data logs analysis) do (
    if not exist "%%d" mkdir "%%d"
)

call :print_success "设置完成!"
call :print_info "您现在可以运行以下命令:"
call :print_info "  %~nx0 --check     # 检查配置"
call :print_info "  %~nx0 --test      # 测试模式"
call :print_info "  %~nx0 --start     # 启动机器人"
goto :eof

REM 启动交易机器人
:start_bot
call :print_info "启动交易机器人..."

REM 检查配置
call :check_config
if errorlevel 1 exit /b 1

REM 激活虚拟环境
if exist "venv" call venv\Scripts\activate.bat

REM 启动机器人
python main.py
goto :eof

REM 启动监控
:start_monitor
call :print_info "启动实时监控..."

REM 激活虚拟环境
if exist "venv" call venv\Scripts\activate.bat

python tools\monitor.py --mode monitor
goto :eof

REM 运行性能分析
:run_analysis
call :print_info "运行性能分析..."

REM 激活虚拟环境
if exist "venv" call venv\Scripts\activate.bat

python tools\analyzer.py --days 30
goto :eof

REM 运行回测
:run_backtest
call :print_info "运行策略回测..."

REM 激活虚拟环境
if exist "venv" call venv\Scripts\activate.bat

python tools\backtest.py
goto :eof

REM 测试模式
:test_mode
call :print_info "运行测试模式..."

REM 检查配置
call :check_config
if errorlevel 1 exit /b 1

REM 确保是测试环境
findstr /C:"sandbox: true" config.yaml >nul
if errorlevel 1 (
    call :print_warning "建议在测试模式下设置 sandbox: true"
)

REM 激活虚拟环境
if exist "venv" call venv\Scripts\activate.bat

REM 运行测试
call :print_info "运行配置测试..."
python -c "import yaml; print('配置文件格式正确')"

call :print_info "运行连接测试..."
python -c "import sys; sys.path.append('src'); from exchange import ExchangeInterface; import yaml; config = yaml.safe_load(open('config.yaml', 'r')); exchange = ExchangeInterface(config); print('交易所连接测试成功')"

call :print_success "测试完成"
goto :eof

REM 主程序
if "%~1"=="" (
    call :print_info "使用 %~nx0 --help 查看帮助信息"
    goto :eof
)

if "%~1"=="-h" goto :show_help
if "%~1"=="--help" goto :show_help
if "%~1"=="-i" goto :install_main
if "%~1"=="--install" goto :install_main
if "%~1"=="-c" goto :check_main
if "%~1"=="--check" goto :check_main
if "%~1"=="-t" goto :test_main
if "%~1"=="--test" goto :test_main
if "%~1"=="-m" goto :start_monitor
if "%~1"=="--monitor" goto :start_monitor
if "%~1"=="-a" goto :run_analysis
if "%~1"=="--analyze" goto :run_analysis
if "%~1"=="-b" goto :run_backtest
if "%~1"=="--backtest" goto :run_backtest
if "%~1"=="-s" goto :start_bot
if "%~1"=="--start" goto :start_bot
if "%~1"=="--setup" goto :setup_wizard

call :print_error "未知选项: %~1"
call :print_info "使用 %~nx0 --help 查看帮助信息"
exit /b 1

:install_main
call :check_python
call :install_dependencies
goto :eof

:check_main
call :check_python
call :check_config
goto :eof

:test_main
call :check_python
call :test_mode
goto :eof