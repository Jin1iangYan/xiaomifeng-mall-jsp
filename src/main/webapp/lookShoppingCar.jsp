<%@ page import="save.data.Login" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page contentType="text/html" %>
<%@ page pageEncoding="utf-8" %>
<jsp:useBean id="loginBean" class="save.data.Login" scope="session" />
<!DOCTYPE html>
<html lang="zh">
<head>
    <%@ include file="head.txt" %>
    <title>查看购物车</title>
    <style>
        body {
            font-family: "宋体", Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
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
        }

        h1 {
            text-align: center;
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

        form {
            margin: 0;
        }

        input[type="text"] {
            width: 60px;
            padding: 5px;
            font-size: 14px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

        input[type="submit"] {
            background-color: #c9f159;
            color: #fff;
            border: none;
            border-radius: 5px;
            padding: 5px 10px;
            font-size: 14px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        input[type="submit"]:hover {
            background-color: #a4d14f;
        }

        .order-button {
            display: block;
            margin: 20px auto;
            background-color: #ff5722;
            color: #fff;
            border: none;
            border-radius: 5px;
            padding: 10px 20px;
            font-size: 16px;
            cursor: pointer;
            text-align: center;
            text-decoration: none;
            transition: background-color 0.3s ease;
        }

        .order-button:hover {
            background-color: #e64a19;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>购物车</h1>
    <%
        if (loginBean == null || loginBean.getLogname() == null || loginBean.getLogname().isEmpty()) {
            response.sendRedirect("login.jsp");
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
            String SQL = "SELECT goodsId, goodsName, goodsPrice, goodsAmount FROM shoppingForm WHERE logname = '" + loginBean.getLogname() + "'";
            rs = sql.executeQuery(SQL);

            out.print("<table>");
            out.print("<thead><tr>");
            out.print("<th>手机标识号</th>");
            out.print("<th>手机名称</th>");
            out.print("<th>手机价格</th>");
            out.print("<th>购买数量</th>");
            out.print("<th>修改数量</th>");
            out.print("<th>删除商品</th>");
            out.print("</tr></thead>");
            out.print("<tbody>");

            while (rs.next()) {
                String goodsId = rs.getString(1);
                String name = rs.getString(2);
                float price = rs.getFloat(3);
                int amount = rs.getInt(4);

                out.print("<tr>");
                out.print("<td>" + goodsId + "</td>");
                out.print("<td>" + name + "</td>");
                out.print("<td>" + price + "</td>");
                out.print("<td>" + amount + "</td>");
                out.print("<td>");
                out.print("<form action='updateServlet' method='post'>");
                out.print("<input type='text' name='update' value='" + amount + "' />");
                out.print("<input type='hidden' name='goodsId' value='" + goodsId + "' />");
                out.print("<input type='submit' value='更新数量' />");
                out.print("</form>");
                out.print("</td>");
                out.print("<td>");
                out.print("<form action='deleteServlet' method='post'>");
                out.print("<input type='hidden' name='goodsId' value='" + goodsId + "' />");
                out.print("<input type='submit' value='删除商品' />");
                out.print("</form>");
                out.print("</td>");
                out.print("</tr>");
            }
            out.print("</tbody>");
            out.print("</table>");

            out.print("<a href='buyServlet' class='order-button'>生成订单 (同时清空购物车)</a>");

        } catch (SQLException e) {
            out.print("<h1>数据库错误: " + e.getMessage() + "</h1>");
        } finally {
            if (con != null) {
                try {
                    con.close();
                } catch (SQLException e) {
                    out.print("<h1>关闭连接错误: " + e.getMessage() + "</h1>");
                }
            }
        }
    %>
</div>
</body>
</html>