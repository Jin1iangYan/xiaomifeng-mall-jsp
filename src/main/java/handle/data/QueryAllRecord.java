package handle.data;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import save.data.Record_Bean;

public class QueryAllRecord extends HttpServlet {
    // 初始化方法
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    // 处理查询所有记录的请求的方法
    public void service(HttpServletRequest request,
                        HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("utf-8"); // 设置请求字符集编码为utf-8
        String idNumber = request.getParameter("fenleiNumber"); // 获取请求中的分类编号
        if (idNumber == null)
            idNumber = "1";
        int id = Integer.parseInt(idNumber); // 将分类编号转换为整数类型
        HttpSession session = request.getSession(true); // 获取session对象
        Connection con = null; // 数据库连接对象
        Record_Bean dataBean = null; // 记录数据模型对象
        try {
            dataBean = (Record_Bean) session.getAttribute("dataBean"); // 从session中获取记录数据模型对象
            if (dataBean == null) {
                dataBean = new Record_Bean(); // 创建记录数据模型对象
                session.setAttribute("dataBean", dataBean); // 将记录数据模型对象存入session
            }
        } catch (Exception exp) {
        }
        try {
            Context context = new InitialContext();
            Context contextNeeded = (Context) context.lookup("java:comp/env");
            DataSource ds =
                    (DataSource) contextNeeded.lookup("mobileConn"); // 获取连接池
            con = ds.getConnection(); // 从连接池中获取连接
            Statement sql = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY); // 创建语句对象
            String query =
                    "SELECT mobile_version,mobile_name,mobile_made,mobile_price " +
                            "FROM mobileForm where id=" + id; // 查询所有记录的SQL语句
            ResultSet rs = sql.executeQuery(query); // 执行查询语句，获取结果集
            ResultSetMetaData metaData = rs.getMetaData(); // 获取结果集的元数据对象
            int columnCount = metaData.getColumnCount(); // 得到结果集的列数
            rs.last(); // 将结果集光标移动到最后一行
            int rows = rs.getRow(); // 得到记录数
            String[][] tableRecord = dataBean.getTableRecord(); // 获取数据模型中的记录数组
            tableRecord = new String[rows][columnCount]; // 根据记录数和列数创建新的记录数组
            rs.beforeFirst(); // 将结果集光标移动到第一行之前
            int i = 0;
            while (rs.next()) {
                for (int k = 0; k < columnCount; k++)
                    tableRecord[i][k] = rs.getString(k + 1); // 将查询结果存入记录数组
                i++;
            }
            dataBean.setTableRecord(tableRecord); // 更新数据模型中的记录数组
            con.close(); // 关闭连接，将连接返回连接池
            response.sendRedirect("byPageShow.jsp"); // 重定向到指定页面
        } catch (Exception e) {
            response.getWriter().print("" + e); // 输出异常信息
        } finally {
            try {
                con.close(); // 关闭连接
            } catch (Exception ee) {
            }
        }
    }
}