#!/bin/bash

show_art() {
    cat << "EOF"
#                                                                                                                             
#                                                                                                                             
#  BBBBBBBBBBBBBBBBB                                 000000000           222222222222222              999999999               
#  B::::::::::::::::B                              00:::::::::00        2:::::::::::::::22          99:::::::::99             
#  B::::::BBBBBB:::::B                           00:::::::::::::00      2::::::222222:::::2       99:::::::::::::99           
#  BB:::::B     B:::::B                         0:::::::000:::::::0     2222222     2:::::2      9::::::99999::::::9          
#    B::::B     B:::::Byyyyyyy           yyyyyyy0::::::0   0::::::0                 2:::::2      9:::::9     9:::::9          
#    B::::B     B:::::B y:::::y         y:::::y 0:::::0     0:::::0                 2:::::2      9:::::9     9:::::9          
#    B::::BBBBBB:::::B   y:::::y       y:::::y  0:::::0     0:::::0              2222::::2        9:::::99999::::::9          
#    B:::::::::::::BB     y:::::y     y:::::y   0:::::0 000 0:::::0         22222::::::22          99::::::::::::::9          
#    B::::BBBBBB:::::B     y:::::y   y:::::y    0:::::0 000 0:::::0       22::::::::222              99999::::::::9           
#    B::::B     B:::::B     y:::::y y:::::y     0:::::0     0:::::0      2:::::22222                      9::::::9            
#    B::::B     B:::::B      y:::::y:::::y      0:::::0     0:::::0     2:::::2                          9::::::9             
#    B::::B     B:::::B       y:::::::::y       0::::::0   0::::::0     2:::::2                         9::::::9              
#  BB:::::BBBBBB::::::B        y:::::::y        0:::::::000:::::::0     2:::::2       222222           9::::::9               
#  B:::::::::::::::::B          y:::::y          00:::::::::::::00      2::::::2222222:::::2          9::::::9                
#  B::::::::::::::::B          y:::::y             00:::::::::00        2::::::::::::::::::2         9::::::9                 
#  BBBBBBBBBBBBBBBBB          y:::::y                000000000          22222222222222222222        99999999                  
#                            y:::::y                                                                                          
#                           y:::::y                                                                                           
#                          y:::::y                                                                                            
#                         y:::::y                                                                                             
#                        yyyyyyy                                                                                              
#       版本1.0由by-029制作【只能用于镜像仿真搜索使用】                                                                                                                      
#请确定029.txt这个文件里面存在关键字或你想搜索的关键字
#[即将开始搜索...]                                                                                                                             
EOF
}
show_art
sleep 6
check_pv() {
    if ! command -v pv &> /dev/null; then
        echo "注意: pv 工具未安装。"
        read -p "是否要手动安装 pv 工具？(Y/N): " choice
        case "$choice" in
            y|Y )
                echo "请按照以下步骤手动安装 pv 工具："
                echo "1. 对于 Debian/Ubuntu 系统，请运行以下命令进行安装："
                echo "   sudo apt-get install pv"
                echo "2. 对于 CentOS/RHEL 系统，请运行以下命令进行安装："
                echo "   sudo yum install pv"
                echo "3. 对于其他系统，请使用适合您系统的包管理器进行安装。"
                exit 1
                ;;
            * )
                echo "终止执行脚本。"
                exit 1
                ;;
        esac
    else
        echo "pv 工具已安装，可以获得更好的进度条效果。"
    fi
}


check_pv

# 检查是否提供了正确数量的参数
if [ $# -ne 1 ]; then
    echo "用法: $0 [029.txt]"
    exit 1
fi

# 定义并行搜索函数
parallel_search() {
    local keyword="$1"
    grep_result=$(grep -rnw --color=always . -e "$keyword")
    find_result=$(find . -type f -name "*$keyword*")
    dir_result=$(find . -type d -name "*$keyword*")
    
    # 输出搜索结果
    if [ -n "$grep_result" ]; then
        echo "文件内容中包含 \"$keyword\" 的搜索结果:"
        echo "$grep_result"
    fi
    
    if [ -n "$find_result" ]; then
        echo "文件名中包含 \"$keyword\" 的搜索结果:"
        echo "$find_result"
    fi
    
    if [ -n "$dir_result" ]; then
        echo "文件夹名称中包含 \"$keyword\" 的搜索结果:"
        echo "$dir_result"
    fi
}

# 获取关键字文件路径
keyword_file=$1

# 检查关键字文件是否存在
if [ ! -f "$keyword_file" ]; then
    echo "错误: 关键字文件 \"$keyword_file\" 不存在。"
    exit 1
fi

# 逐行读取关键字文件并并行搜索关键字
while IFS= read -r keyword; do
    echo "开始搜索 \"$keyword\" ..."
    parallel_search "$keyword"
    echo "关键字 \"$keyword\" 搜索完成。"
    echo "即将搜索下一个关键字..."
    sleep 3
done < "$keyword_file"

# 显示搜索任务已完成的消息和当前时间
echo "搜索任务已完成，当前时间：$(date)"
echo "备注: 本工具用于在当前目录及其子目录中搜索指定关键字文件中的内容、文件夹名称和文件名。"
echo "      请确保029.txt中每行包含关键字。"
