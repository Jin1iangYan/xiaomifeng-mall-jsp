<%@ page contentType="text/html" %>
<%@ page pageEncoding="utf-8" %>
<jsp:useBean id="userBean" class="save.data.Register" scope="request" />
<!DOCTYPE html>
<html lang="zh">
<head>
    <%@ include file="head.txt" %>
    <title>注册页面</title>
    <style>
        /* 全局样式 */
        body {
            font-family: "宋体", Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
            color: #333;
            padding-top: 100px; /* 为导航栏预留空间 */
        }

        #ok {
            font-size: 20px;
            color: black;
        }

        #yes {
            font-family: "黑体", Arial, sans-serif;
            font-size: 18px;
            color: black;
        }

        form {
            background: #fff;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            max-width: 800px;
            margin: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        td {
            padding: 10px;
            vertical-align: middle;
        }

        input[type="text"],
        input[type="password"],
        input[type="submit"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
        }

        input[type="submit"] {
            background-color: #c9f159; /* 使用主题色 */
            color: #fff;
            border: none;
            cursor: pointer;
            font-weight: bold;
            transition: all 0.3s ease;
        }

        input[type="submit"]:hover {
            background-color: #a4d14f;
        }

        .feedback {
            margin: 20px auto;
            max-width: 800px;
            text-align: center;
        }

        .feedback table {
            margin-top: 10px;
            width: 100%;
            border: 3px solid #c9f159; /* 使用主题色 */
        }

        .feedback td {
            padding: 10px;
            border: 1px solid #ddd;
        }
    </style>
</head>
<body>
<div align="center">
    <form action="/servlet-1.0-SNAPSHOT/registerServlet" method="post">
        <table>
            <tr>
                <td colspan="4" align="center" style="font-weight: bold;">
                    用户名由字母、数字、下划线构成，*注释的项必须填写。
                </td>
            </tr>
            <tr>
                <td>*用户名称:</td>
                <td><input type="text" name="logname" /></td>
                <td>*用户密码:</td>
                <td><input type="password" name="password" /></td>
            </tr>
            <tr>
                <td>*重复密码:</td>
                <td><input type="password" name="again_password" /></td>
                <td>联系电话:</td>
                <td><input type="text" name="phone" /></td>
            </tr>
            <tr>
                <td>邮寄地址:</td>
                <td><input type="text" name="address" /></td>
                <td>真实姓名:</td>
                <td><input type="text" name="realname" /></td>
            </tr>
            <tr>
                <td colspan="4" align="center">
                    <input type="submit" value="提交" />
                </td>
            </tr>
        </table>
    </form>
</div>
<div class="feedback">
    <h2>注册反馈：</h2>
    <p><jsp:getProperty name="userBean" property="backNews" /></p>
    <table>
        <tr>
            <td>会员名称:</td>
            <td><jsp:getProperty name="userBean" property="logname" /></td>
        </tr>
        <tr>
            <td>姓名:</td>
            <td><jsp:getProperty name="userBean" property="realname" /></td>
        </tr>
        <tr>
            <td>地址:</td>
            <td><jsp:getProperty name="userBean" property="address" /></td>
        </tr>
        <tr>
            <td>电话:</td>
            <td><jsp:getProperty name="userBean" property="phone" /></td>
        </tr>
    </table>
</div>
</body>
</html>