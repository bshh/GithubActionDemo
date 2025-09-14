#!/bin/bash

# 创建一个最简单的html页面里面包含当天的日期

# 获取当天日期
current_date=$(date +"%Y-%m-%d")

# 创建HTML文件
cat <<EOF > dest/index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Simple HTML Page</title>
</head>
<body>
  <h1>Welcome!</h1>
  <p>Today's date is: $current_date</p>
</body>
</html>
EOF