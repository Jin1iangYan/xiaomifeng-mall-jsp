package handle.data;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import save.data.Login;

public class PutGoodsToCar extends HttpServlet {
    // 初始化方法
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    // 处理添加商品到购物车的请求的方法
    public void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("utf-8"); // 设置请求字符集编码为utf-8
        Connection con = null; // 数据库连接对象
        PreparedStatement pre = null; // 预处理语句对象
        ResultSet rs; // 结果集对象
        String mobileID = request.getParameter("mobileID"); // 获取请求中的手机ID
        Login loginBean = null;
        HttpSession session = request.getSession(true); // 获取session对象

        try {
            loginBean = (Login) session.getAttribute("loginBean"); // 从session中获取登录数据模型对象
            if (loginBean == null) {
                response.sendRedirect("login.jsp");// 重定向到登录页面
                return;
            } else {
                boolean b = loginBean.getLogname() == null ||
                        loginBean.getLogname().length() == 0;
                if (b) {
                    response.sendRedirect("login.jsp");// 重定向到登录页面
                    return;
                }
            }
        } catch (Exception exp) {
            response.sendRedirect("login.jsp");// 重定向到登录页面
            return;
        }

        try {
            Context context = new InitialContext();
            Context contextNeeded = (Context) context.lookup("java:comp/env");
            DataSource ds = (DataSource) contextNeeded.lookup("mobileConn"); // 获取连接池
            con = ds.getConnection();// 从连接池中获取连接

            String queryMobileForm = "select * from mobileForm where mobile_version =?"; // 查询商品表的sql语句
            String queryShoppingForm = "select goodsAmount from shoppingForm where goodsId =?"; // 购物车表的sql语句
            String updateSQL = "update shoppingForm set goodsAmount =? where goodsId=?"; // 更新购物车的sql语句
            String insertSQL = "insert into shoppingForm values(?,?,?,?,?)"; // 添加到购物车的sql语句

            pre = con.prepareStatement(queryShoppingForm); // 创建预处理语句对象
            pre.setString(1, mobileID); // 设置手机ID参数
            rs = pre.executeQuery(); // 执行查询语句
            if (rs.next()) { // 该货物已经在购物车中
                int amount = rs.getInt(1);
                amount++;
                pre = con.prepareStatement(updateSQL); // 创建预处理语句对象
                pre.setInt(1, amount); // 设置更新数量参数
                pre.setString(2, mobileID); // 设置手机ID参数
                pre.executeUpdate(); // 执行更新语句，更新购物车中该货物的数量
            } else { // 向购物车添加商品
                pre = con.prepareStatement(queryMobileForm); // 创建预处理语句对象
                pre.setString(1, mobileID); // 设置手机ID参数
                rs = pre.executeQuery(); // 执行查询语句
                if (rs.next()) {
                    pre = con.prepareStatement(insertSQL); // 创建预处理语句对象
                    pre.setString(1, rs.getString("mobile_version"));
                    pre.setString(2, loginBean.getLogname());
                    pre.setString(3, rs.getString("mobile_name"));
                    pre.setFloat(4, rs.getFloat("mobile_price"));
                    pre.setInt(5, 1);
                    pre.executeUpdate(); // 执行插入语句，向购物车中添加该货物
                }
            }

            con.close(); // 关闭连接
            response.sendRedirect("lookShoppingCar.jsp"); // 查看购物车
        } catch (SQLException exp) {
            response.getWriter().print("" + exp); // 输出异常信息
        } catch (NamingException exp) {
            // do nothing
        } finally {
            try {
                con.close(); // 关闭连接
            } catch (Exception ee) {
                // do nothing
            }
        }
    }
}