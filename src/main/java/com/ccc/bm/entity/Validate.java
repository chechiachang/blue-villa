/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ccc.bm.entity;

import java.io.PrintWriter;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author davidchang
 */
public class Validate {

    public static String checkUser(String name, String password) {
        String status = "0";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            Class.forName(JdbcConn.getDRIVER_MANAGER());
            conn = DriverManager.getConnection(JdbcConn.getDB_URL(), JdbcConn.getUSER(), JdbcConn.getPASS());
            ps = conn.prepareStatement("SELECT `level` FROM `users` WHERE `name` = ? AND `password` = ?" );
            ps.setString(1, name);
            ps.setString(2, getMD5(password));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                status = rs.getString(1);
            }
            rs.close();
        } catch (Exception e) {
            //do nothing
        } finally {
            try {
                if (ps != null) {
                    ps.close();
                }
            } catch (SQLException se2) {
                se2.printStackTrace();
            }// nothing we can do
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException se) {
                se.printStackTrace();
            }//end finally try
        }

        return status;
    }

    public static String getMD5(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] messageDigest = md.digest(input.getBytes());
            BigInteger number = new BigInteger(1, messageDigest);
            String hashtext = number.toString(16);
            // Now we need to zero pad it if you actually want the full 32 chars.
            while (hashtext.length() < 32) {
                hashtext = "0" + hashtext;
            }
            return hashtext;
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }
    /*
     public static String getUserId(String name) {
     String id = null;
     Connection conn = null;
     PreparedStatement ps = null;
     try {
     //loading driver for mysql
     Class.forName("com.mysql.jdbc.Driver");

     //creating connection with the database
     conn = DriverManager.getConnection(DB_URL, USER, PASS);
     ps = conn.prepareStatement("SELECT `id` FROM `users` WHERE `name` = ? ");
     ps.setString(1, name);
     ResultSet rs = ps.executeQuery();
     while (rs.next()) {
     id = rs.getString(1);
     }
     } catch (Exception e) {
     //do nothing
     } finally {
     try {
     if (ps != null) {
     ps.close();
     }
     } catch (SQLException se2) {
     se2.printStackTrace();
     }// nothing we can do
     try {
     if (conn != null) {
     conn.close();
     }
     } catch (SQLException se) {
     se.printStackTrace();
     }//end finally try
     }

     return id;
     }
     */

}
