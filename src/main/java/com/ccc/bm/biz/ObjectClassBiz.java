/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ccc.bm.biz;

import com.ccc.bm.entity.ObjectClass;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 *
 * @author davidchang
 */
public class ObjectClassBiz {

    static final String DB_URL = "jdbc:mysql://localhost:3306/booking_manager?useUnicode=yes&characterEncoding=UTF-8";
    static final String JDBC_DRIVER = "com.mysql.jdbc.Driver";

    static final String USER = "booking";
    static final String PASS = "booking";
    Connection conn = null;
    Statement stmt = null;
    PreparedStatement ps = null;
    Statement st;
    ResultSet rs;

    public ObjectClassBiz() {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, USER, PASS);
        } catch (Exception e) {

        }

    }

    public int countObjectClass() {
        int count = 0;
        try {
            ps = conn.prepareStatement("SELECT COUNT(id) FROM `room_class`");
            rs = ps.executeQuery();
            count = rs.getInt(1);
        } catch (Exception e) {

        }
        return count;
    }

    public ObjectClass[] getObjectClasses() {
        int count = countObjectClass();
        ObjectClass[] objectClasses = new ObjectClass[count];
        try {
            ps = conn.prepareStatement("SELECT ?,?,?,?,? FROM `room_class`");
            ps.setString(1, "id");
            ps.setString(2, "disabled");
            ps.setString(3, "name");
            ps.setString(4, "admin_id");
            ps.setString(5, "image_uri");
            rs = ps.executeQuery();
            int i = 0;
            while (rs.next()) {
                ObjectClass objectClass = new ObjectClass();
                
                objectClass.setId(rs.getInt(1));
                objectClass.setDisabled(rs.getInt(2));
                objectClass.setName(rs.getString(3));
                objectClass.setAdmin_id(rs.getInt(4));
                objectClass.setImage_uri(rs.getString(5));
                
                objectClasses[i] = objectClass;
                i++;
            }
        } catch (Exception e) {

        }
        return objectClasses;
    }

    public void close() throws SQLException {
        conn.close();
        ps.close();
        st.close();
        rs.close();
    }
}
