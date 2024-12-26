<%@ page contentType="text/html" %>
<%@ page pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <%@ include file="head.txt" %>
    <title>查询页面</title>
    <style>
        body {
            font-family: "宋体", Arial, sans-serif;
            margin: 0;
            padding: 0;
            color: #333;
            padding-top: 100px; /* 适配导航栏 */
        }

        .container {
            width: 60%;
            margin: 0 auto;
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .container p {
            font-size: 18px;
            line-height: 1.8;
            color: #555;
        }

        .container input[type="text"] {
            width: 80%;
            padding: 10px;
            margin: 15px 0;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
        }

        .container input[type="radio"] {
            margin-right: 5px;
        }

        .container label {
            font-size: 16px;
            margin-right: 15px;
            color: #333;
        }

        .container input[type="submit"] {
            background-color: #c9f159; /* 使用主题色 */
            color: #fff;
            border: none;
            border-radius: 5px;
            padding: 10px 20px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .container input[type="submit"]:hover {
            background-color: #a4d14f;
        }
    </style>
</head>
<body>
<div class="container">
    <p>查询时可以输入手机的版本号或手机名称及价格。<br>
        手机名称支持模糊查询。<br>
        输入价格是在 2 个值之间的价格，格式是：<strong>价格1-价格2</strong><br>
        例如：<strong>897.98-10000</strong>。
    </p>
    <form action="/servlet-1.0-SNAPSHOT/searchByConditionServlet" method="post">
        <input type="text" name="searchMess" placeholder="请输入查询信息">
        <br>
        <label>
            <input type="radio" name="radio" value="mobile_version"> 手机版本号
        </label>
        <label>
            <input type="radio" name="radio" value="mobile_name"> 手机名称
        </label>
        <label>
            <input type="radio" name="radio" value="mobile_price" checked> 手机价格
        </label>
        <br><br>
        <input type="submit" value="提交">
    </form>
</div>
</body>
</html>