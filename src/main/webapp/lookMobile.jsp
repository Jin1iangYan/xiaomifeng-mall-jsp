<%@ page contentType="text/html" %>
<%@ page pageEncoding="utf-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <%@ include file="head.txt" %>
    <title>浏览手机页面</title>
    <style>
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

        .container {
            background: #fff;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            max-width: 500px;
            width: 100%;
            text-align: center;
        }

        .container h1 {
            font-size: 24px;
            margin-bottom: 20px;
            color: #333;
        }

        .container select,
        .container input[type="submit"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
        }

        .container input[type="submit"] {
            background-color: #c9f159; /* 使用主题色 */
            color: #fff;
            border: none;
            cursor: pointer;
            font-weight: bold;
            transition: all 0.3s ease;
        }

        .container input[type="submit"]:hover {
            background-color: #a4d14f;
        }

        .error {
            color: red;
            font-size: 14px;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>浏览手机</h1>
    <p>选择某类手机，分页显示这类手机。</p>
    <%
        Connection con = null;
        Statement sql = null;
        ResultSet rs = null; // 确保初始化为 null
        try {
            Context context = new InitialContext();
            Context contextNeeded = (Context) context.lookup("java:comp/env");
            DataSource ds = (DataSource) contextNeeded.lookup("mobileConn"); // 获得连接池。
            con = ds.getConnection(); // 使用连接池中的连接。
            sql = con.createStatement();
            rs = sql.executeQuery("SELECT * FROM mobileClassify"); // 查询分类数据。

            // 输出分类表单
            out.print("<form action='queryServlet' method='post'>");
            out.print("<select name='fenleiNumber'>");
            while (rs.next()) {
                int id = rs.getInt(1);
                String mobileCategory = rs.getString(2);
                out.print("<option value='" + id + "'>" + mobileCategory + "</option>");
            }
            out.print("</select>");
            out.print("<input type='submit' value='提交'>");
            out.print("</form>");

        } catch (SQLException e) {
            out.print("<div class='error'>发生错误: " + e.getMessage() + "</div>");
        } catch (Exception e) {
            out.print("<div class='error'>初始化错误: " + e.getMessage() + "</div>");
        } finally {
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException e) {
                    out.print("<div class='error'>关闭结果集时出错: " + e.getMessage() + "</div>");
                }
            }
            if (sql != null) {
                try {
                    sql.close();
                } catch (SQLException e) {
                    out.print("<div class='error'>关闭声明时出错: " + e.getMessage() + "</div>");
                }
            }
            if (con != null) {
                try {
                    con.close(); // 连接返回连接池。
                } catch (SQLException e) {
                    out.print("<div class='error'>关闭连接时出错: " + e.getMessage() + "</div>");
                }
            }
        }
    %>
</div>
</body>
</html>