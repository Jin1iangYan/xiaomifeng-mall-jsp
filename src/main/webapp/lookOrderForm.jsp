<%@ page contentType="text/html" %>
<%@ page pageEncoding="utf-8" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="java.sql.*" %>
<jsp:useBean id="loginBean" class="save.data.Login" scope="session" />
<!DOCTYPE html>
<html lang="zh">
<head>
    <%@ include file="head.txt" %>
    <title>查看订单</title>
    <style>
        body {
            font-family: "宋体", Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #e0ffff; /* 淡青色背景 */
            color: #333;
            padding-top: 100px; /* 适配导航栏 */
        }

        .container {
            width: 80%;
            margin: 20px auto;
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        h1 {
            font-size: 24px;
            color: #333;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

        table th, table td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
        }

        table th {
            background-color: #c9f159; /* 使用主题色 */
            color: #fff;
        }

        table td {
            color: #333;
        }

        .message {
            font-size: 18px;
            color: #555;
            margin: 20px 0;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>查看订单</h1>
    <%
        if (loginBean == null || loginBean.getLogname() == null || loginBean.getLogname().isEmpty()) {
            response.sendRedirect("login.jsp"); // 重定向到登录页面
            return;
        }

        Context context = new InitialContext();
        Context contextNeeded = (Context) context.lookup("java:comp/env");
        DataSource ds = (DataSource) contextNeeded.lookup("mobileConn");
        Connection con = null;
        Statement sql;
        ResultSet rs;

        try {
            con = ds.getConnection();
            sql = con.createStatement();
            String SQL = "SELECT * FROM orderForm WHERE logname = '" + loginBean.getLogname() + "'";
            rs = sql.executeQuery(SQL);

            out.print("<table>");
            out.print("<thead><tr>");
            out.print("<th>订单序号</th>");
            out.print("<th>用户名称</th>");
            out.print("<th>订单信息</th>");
            out.print("</tr></thead>");
            out.print("<tbody>");

            boolean hasData = false; // 判断是否有订单记录
            while (rs.next()) {
                hasData = true;
                out.print("<tr>");
                out.print("<td>" + rs.getString(1) + "</td>");
                out.print("<td>" + rs.getString(2) + "</td>");
                out.print("<td>" + rs.getString(3) + "</td>");
                out.print("</tr>");
            }

            if (!hasData) {
                out.print("<tr><td colspan='3'>暂无订单记录</td></tr>");
            }

            out.print("</tbody>");
            out.print("</table>");
        } catch (SQLException e) {
            out.print("<div class='message'>数据库错误: " + e.getMessage() + "</div>");
        } finally {
            if (con != null) {
                try {
                    con.close();
                } catch (SQLException e) {
                    out.print("<div class='message'>关闭连接错误: " + e.getMessage() + "</div>");
                }
            }
        }
    %>
</div>
</body>
</html>