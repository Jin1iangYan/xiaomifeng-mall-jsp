<%@ page contentType="text/html" %>
<%@ page pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <%@ include file="head.txt" %>
    <title>分页浏览页面</title>
    <style>
        body {
            font-family: "宋体", Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
            color: #333;
            padding-top: 100px; /* 适配导航栏 */
        }

        center {
            margin-top: 20px;
        }

        table {
            width: 80%;
            margin: 20px auto;
            border-collapse: collapse;
            background: #fff;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        table th, table td {
            border: 1px solid #ddd;
            text-align: center;
            padding: 10px;
        }

        table th {
            background-color: #c9f159; /* 主题色 */
            color: #fff;
        }

        .button {
            display: inline-block;
            padding: 10px 20px;
            margin: 5px;
            font-size: 16px;
            color: #fff;
            background-color: #c9f159;
            border: none;
            border-radius: 5px;
            text-align: center;
            text-decoration: none;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .button:hover {
            background-color: #a4d14f;
        }

        .button:disabled {
            background-color: #ddd;
            cursor: not-allowed;
        }

        input[type="text"] {
            padding: 5px;
            font-size: 16px;
            border: 1px solid #ddd;
            border-radius: 5px;
            width: 50px;
            text-align: center;
        }

        .info {
            text-align: center;
            font-size: 18px;
            margin: 20px 0;
        }

        .info span {
            font-weight: bold;
            color: #555;
        }
    </style>
</head>
<body>
<jsp:useBean id="dataBean" class="save.data.Record_Bean" scope="session" />
<center>
    <!-- 分页数据表格 -->
    <table>
        <thead>
            <tr>
                <th>手机标识号</th>
                <th>手机名称</th>
                <th>手机制造商</th>
                <th>手机价格</th>
                <th>查看细节</th>
                <th>添加到购物车</th>
            </tr>
        </thead>
        <tbody>
            <%
                String[][] table = dataBean.getTableRecord();
                if (table == null) {
            %>
                <tr>
                    <td colspan="6">没有记录</td>
                </tr>
            <%
                } else {
                    int totalRecord = table.length;
                    int pageSize = dataBean.getPageSize();
                    int currentPage = dataBean.getCurrentPage();
                    int totalPages = (totalRecord + pageSize - 1) / pageSize;

                    dataBean.setTotalPages(totalPages);
                    if (currentPage < 1) {
                        currentPage = totalPages;
                    }
                    if (currentPage > totalPages) {
                        currentPage = 1;
                    }
                    dataBean.setCurrentPage(currentPage);

                    int start = (currentPage - 1) * pageSize;
                    for (int i = start; i < start + pageSize && i < totalRecord; i++) {
                        out.print("<tr>");
                        for (int j = 0; j < table[0].length; j++) {
                            out.print("<td>" + table[i][j] + "</td>");
                        }
                        out.print("<td><a class='button' href='showDetail.jsp?mobileID=" + table[i][0] + "'>手机详情</a></td>");
                        out.print("<td><a class='button' href='putGoodsServlet?mobileID=" + table[i][0] + "'>添加到购物车</a></td>");
                        out.print("</tr>");
                    }
                }
            %>
        </tbody>
    </table>

    <!-- 分页信息 -->
    <div class="info">
        全部记录数: <span><jsp:getProperty name="dataBean" property="totalRecords" /></span> 条。<br>
        每页最多显示: <span><jsp:getProperty name="dataBean" property="pageSize" /></span> 条记录。<br>
        当前显示第: <span><jsp:getProperty name="dataBean" property="currentPage" /></span> 页 
        (共有 <span><jsp:getProperty name="dataBean" property="totalPages" /></span> 页)。
    </div>

    <!-- 分页控制 -->
    <div class="pagination-controls">
        <form action="" method="post" style="display:inline;">
            <input type="hidden" name="currentPage" value="<%= dataBean.getCurrentPage() - 1 %>" />
            <button type="submit" class="button" <%= dataBean.getCurrentPage() <= 1 ? "disabled" : "" %>>上一页</button>
        </form>
        <form action="" method="post" style="display:inline;">
            <input type="hidden" name="currentPage" value="<%= dataBean.getCurrentPage() + 1 %>" />
            <button type="submit" class="button" <%= dataBean.getCurrentPage() >= dataBean.getTotalPages() ? "disabled" : "" %>>下一页</button>
        </form>
        <form action="" method="post" style="display:inline;">
            输入页码: <input type="text" name="currentPage" size="2" />
            <button type="submit" class="button">跳转</button>
        </form>
        <form action="" method="post" style="display:inline;">
            每页显示: <input type="text" name="pageSize" value="<%= dataBean.getPageSize() %>" size="2" />
            <button type="submit" class="button">设置</button>
        </form>
    </div>
</center>
</body>
</html>