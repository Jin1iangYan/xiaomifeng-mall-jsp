<%@ page contentType="text/html" %>
<%@ page pageEncoding="utf-8" %>
<jsp:useBean id="loginBean" class="save.data.Login" scope="session" />
<!DOCTYPE html>
<html lang="zh">
<head>
    <%@ include file="head.txt" %>
    <title>登录页面</title>
    <style>
        /* 全局样式 */
        body {
            font-family: "宋体", Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
            color: #333;
            padding-top: 100px; /* 为导航栏预留空间 */
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        /* 登录表单样式 */
        .login-container {
            background: #fff;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            max-width: 400px;
            width: 100%;
            text-align: center;
        }

        .login-container h1 {
            font-size: 24px;
            margin-bottom: 20px;
            color: #333;
        }

        .login-container label {
            display: block;
            text-align: left;
            font-size: 16px;
            margin-bottom: 5px;
        }

        .login-container input[type="text"],
        .login-container input[type="password"],
        .login-container input[type="submit"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
        }

        .login-container input[type="submit"] {
            background-color: #c9f159; /* 使用主题色 */
            color: #fff;
            border: none;
            cursor: pointer;
            font-weight: bold;
            transition: all 0.3s ease;
        }

        .login-container input[type="submit"]:hover {
            background-color: #a4d14f;
        }

        .feedback {
            margin-top: 15px;
            color: #555;
            font-size: 16px;
        }

        .feedback span {
            font-weight: bold;
            color: #333;
        }
    </style>
</head>
<body>
<div class="login-container">
    <h1>登录</h1>
    <form action="/servlet-1.0-SNAPSHOT/loginServlet" method="post">
        <label for="logname">登录名称</label>
        <input type="text" id="logname" name="logname" placeholder="请输入登录名称">
        
        <label for="password">输入密码</label>
        <input type="password" id="password" name="password" placeholder="请输入密码">
        
        <input type="submit" value="提交">
    </form>

    <!-- 登录反馈信息 -->
    <div class="feedback">
        登录反馈信息: <span><jsp:getProperty name="loginBean" property="backNews" /></span><br>
        登录名称: <span><jsp:getProperty name="loginBean" property="logname" /></span>
    </div>
</div>
</body>
</html>